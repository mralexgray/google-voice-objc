//
//  GVVoice.m
//  GV
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright 2011 Joey Gibson <joey@joeygibson.com>, Inc. All rights reserved.
//

#import "GVoice.h"
#import "NSString-GVoice.h"

#pragma mark - Private Properties
@interface GVoice ()
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, retain) NSString *captchaToken;
@property (nonatomic, retain) NSString *captchaUrl;
@property (nonatomic, retain) NSString *captchaUrl2;
@property (nonatomic, assign) NSInteger redirectCounter;
@end

@implementation GVoice

@synthesize accountType = _accountType;
@synthesize source = _source;
@synthesize user = _user;
@synthesize password = _password;
@synthesize authToken = _authToken;
@synthesize captchaToken = _captchaToken;
@synthesize captchaUrl = _captchaUrl;
@synthesize captchaUrl2 = _captchaUrl2;
@synthesize redirectCounter = _redirectCounter;
@synthesize errorCode = _errorCode;
@synthesize logToConsole;

- (void) setErrorCodeFromReturnValue: (NSString *) retValue {
	if ([retValue isEqualToString: @"BadAuthentication"]) {
		self.errorCode = BadAuthentication;
	} else if ([retValue isEqualToString: @"NotVerified"]) {
		self.errorCode = NotVerified;
	} else if ([retValue isEqualToString: @"TermsNotAgreed"]) {
		self.errorCode = TermsNotAgreed;
	} else if ([retValue isEqualToString: @"CaptchaRequired"]) {
		self.errorCode = CaptchaRequired;
	} else if ([retValue isEqualToString: @"Unknown"]) {
		self.errorCode = Unknown;
	} else if ([retValue isEqualToString: @"AccountDeleted"]) {
		self.errorCode = AccountDeleted;
	} else if ([retValue isEqualToString: @"AccountDisabled"]) {
		self.errorCode = AccountDisabled;
	} else if ([retValue isEqualToString: @"ServiceDisabled"]) {
		self.errorCode = ServiceDisabled;
	} else if ([retValue isEqualToString: @"ServiceUnavailable"]) {
		self.errorCode = ServiceUnavailable;
	}
}

- (NSString *) errorDescription {
	NSString *retString;
	
	switch (self.errorCode) {
		case NoError:
			retString = @"";
			break;
		case BadAuthentication:
			retString = @"Wrong username or password.";
			break;
		case NotVerified:
			retString = @"The account email address has not been verified. You need to access your Google account directly to resolve the issue before logging in using google-voice-java.";
			break;
		case TermsNotAgreed:
			retString = @"You have not agreed to terms. You need to access your Google account directly to resolve the issue before logging in using google-voice-java.";
			break;
		case CaptchaRequired:
			retString = @"A CAPTCHA is required. (A response with this error code will also contain an image URL and a CAPTCHA token.)";
			break;
		case Unknown:
			retString = @"Unknown or unspecified error; the request contained invalid input or was malformed.";
			break;
		case AccountDeleted:
			retString = @"The user account has been deleted.";
			break;
		case AccountDisabled:
			retString = @"The user account has been disabled.";
			break;
		case ServiceDisabled:
			retString = @"Your access to the voice service has been disabled. (Your user account may still be valid.)";
			break;
		case ServiceUnavailable:
			retString = @"The service is not available; try again later.";
			break;
	}
	
	return retString;
}

- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source {
	return [self initWIthUser: user
					 password: password
					   source: source
				  accountType: nil
			  captchaResponse: nil
				 captchaToken: nil];
}

- (id) initWIthUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (NSString *) accountType {
	return [self initWIthUser: user
					 password: password
					   source: source
				  accountType: accountType
			  captchaResponse: nil
				 captchaToken: nil];	
}

- (id) initWIthUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (NSString *) accountType 
	captchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken {
	self = [super init];
	
	if (self) {
		self.user = user;
		self.password = password;
		self.source = source;
		self.accountType = accountType;
		self.captchaToken = captchaToken;
	}
	
	return self;
}

- (BOOL) login {
	return [self loginWithCaptchaResponse: nil captchaToken: nil];
}

- (BOOL) loginWithCaptchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken {
	NSString *data = [NSString stringWithFormat: @"accountType=%@&Email=%@&Passwd=%@&service=%@&source=%@", 
					  @"HOSTED_OR_GOOGLE".urlEncoded,
					  self.user.urlEncoded,
					  self.password.urlEncoded,
					  SERVICE.urlEncoded,
					  self.source.urlEncoded];
	
	if (captchaResponse && captchaToken) {
		data = [data stringByAppendingFormat: @"&logintoken=%@&logincaptcha=%@",
				captchaToken.urlEncoded, 
				captchaResponse.urlEncoded];
	}
	
	NSData *requestData = [NSData dataWithBytes: [data UTF8String] length: [data length]];
	
	NSURL *url = [NSURL URLWithString: LOGIN_URL_STRING];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
	
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: requestData];
	[request addValue: USER_AGENT forHTTPHeaderField: @"User-agent"];

	NSURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
	
	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice Login Error: %@", err);
		}
		
		self.errorCode = Unknown;
		
		return NO;
	} else {
		NSString *retString = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
		
		if (self.logToConsole) {
			NSLog(@"GVoice Login: %@", retString);
		}
				
		NSArray *lines = [retString componentsSeparatedByString: @"\n"];
		
		NSString *authToken;
		
		for (NSString *line in lines) {
			NSRange errorRange = [line rangeOfString: @"Error"];
			
			if (errorRange.location != NSNotFound) {
				NSArray *tokens = [line componentsSeparatedByString: @"="];
				
				[self setErrorCodeFromReturnValue: [tokens objectAtIndex: 1]];
				return NO;
			} else {			
				NSRange textRange = [line rangeOfString: @"Auth"];
				
				if (textRange.location != NSNotFound) {
					NSArray *tokens = [line componentsSeparatedByString: @"="];
					authToken = [[tokens objectAtIndex: 1] retain];
					break;
				}
			}
		}
		
		if (self.logToConsole) {
			NSLog(@"GVoice Login Auth Token: %@", authToken);
		}
		
		[retString release];		
	}
	
	[request release];
	
	return YES;
}





































@end
