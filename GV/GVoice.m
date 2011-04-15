//
//  GVVoice.m
//  GV
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright 2011 Joey Gibson <joey@joeygibson.com>, Inc. All rights reserved.
//

#import "GVoice.h"
#import "NSString-GVoice.h"
#import "ParsingUtils.h"
#import "GVAllSettings.h"

#pragma mark - Private Properties
@interface GVoice ()
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, retain) NSString *captchaToken;
@property (nonatomic, retain) NSString *captchaUrl;
@property (nonatomic, retain) NSString *captchaUrl2;
@property (nonatomic, assign) NSInteger redirectCounter;
@end

@implementation GVoice

#pragma mark - Public Properties
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
@synthesize logToConsole = _logToConsole;
@synthesize general = _general;

#pragma mark - Utility Methods
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

- (NSString *) accountTypeAsString {
	NSString *string;
	
	switch (self.accountType) {
		case GOOGLE:
			string = @"GOOGLE";
			break;
		case HOSTED:
			string = @"HOSTED";
			break;
		case HOSTED_OR_GOOGLE:
			string = @"HOSTED_OR_GOOGLE";
			break;
	}
	
	return string;
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
		case TooManyRedirects:
			retString = @"Too many redirects to handle.";
			break;
	}
	
	return retString;
}

#pragma mark - Initialization Methods
- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source {
	return [self initWithUser: user
					 password: password
					   source: source
				  accountType: GOOGLE
			  captchaResponse: nil
				 captchaToken: nil];
}

- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (AccountType) accountType {
	return [self initWithUser: user
					 password: password
					   source: source
				  accountType: accountType
			  captchaResponse: nil
				 captchaToken: nil];	
}

- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (AccountType) accountType 
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

#pragma mark - Login Methods
- (BOOL) login {
	return [self loginWithCaptchaResponse: nil captchaToken: nil];
}

- (BOOL) loginWithCaptchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken {
	NSString *data = [NSString stringWithFormat: @"accountType=%@&Email=%@&Passwd=%@&service=%@&source=%@", 
					  self.accountTypeAsString,
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
		
		NSString *tmpAuthToken;
		
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
					tmpAuthToken = [[tokens objectAtIndex: 1] retain];
					break;
				}
			}
		}
		
		if (self.logToConsole) {
			NSLog(@"GVoice Login Auth Token: %@", tmpAuthToken);
		}
		
		self.authToken = tmpAuthToken;
		
		[retString release];		
	}
	
	[request release];
	
	self.general = [self fetchGeneral];
	
	return YES;
}

#pragma mark - Private Methods
- (NSString *) fetchPage: (NSInteger) page fromUrl: (NSString *) urlString{
	NSURL *url = [NSURL URLWithString: urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
	
	NSString *authString = [NSString stringWithFormat: @"GoogleLogin auth=%@", self.authToken];
	
	[request setValue: authString forHTTPHeaderField: @"Authorization"];
	[request setValue: USER_AGENT forHTTPHeaderField: @"User-agent"];

	NSHTTPURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];

	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice Fetch Error: %@", err);
		}
		
		self.errorCode = Unknown;
		
		return NO;
	} else {
		NSInteger statusCode = resp.statusCode;
		
		if (statusCode == 200) {
			NSString *retString = [[[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding] autorelease];

			if (self.logToConsole) {
				NSLog(@"GVoice Fetch: %@", retString);
			}
			
			return retString;			
		} else if (statusCode == 301 ||
				   statusCode == 302 ||
				   statusCode == 303 ||
				   statusCode == 307) {
			self.redirectCounter++;
			
			if (self.redirectCounter > MAX_REDIRECTS) {
				self.redirectCounter = 0;
				
				self.errorCode = TooManyRedirects;
				return nil;
			}
			
			// Need to handle redirect
			return @"";
		}
	}
	
	[request release];
	
	return @"";
}

- (NSString *) fetchFromUrl: (NSString *) urlString {
	return [self fetchPage: 0 fromUrl: urlString];
}

#pragma mark - Life Cycle Methods
- (void)dealloc {	
    [_source release], _source = nil;
    [_user release], _user = nil;
    [_password release], _password = nil;
    [_authToken release], _authToken = nil;
    [_captchaToken release], _captchaToken = nil;
    [_captchaUrl release], _captchaUrl = nil;
    [_captchaUrl2 release], _captchaUrl2 = nil;
    [_general release], _general = nil;
	
	[super dealloc];
}

#pragma mark - Google Voice Methods
- (GVAllSettings *) fetchSettings {
	NSString *string = [self fetchFromUrl: GROUPS_INFO_URL_STRING];

	if (self.logToConsole) {
		NSLog(@"GVoice getSettings: %@", string);
	}
	
	NSString *jsonSubStr = [ParsingUtils removeTextSurrounding: string
												  startingWith: @"<json><![CDATA["
													endingWith: @"]]></json>"
											   includingTokens: NO];
	
	if (self.logToConsole) {
		NSLog(@"GVoice getSettings jsonSubStr: %@", jsonSubStr);
	}
	
	GVAllSettings *allSettings = [[GVAllSettings alloc] initWithJsonString: jsonSubStr];

	return allSettings;
}

- (NSString *) fetchGeneral {
	return [self fetchFromUrl: GENERAL_URL_STRING];
}




























@end
