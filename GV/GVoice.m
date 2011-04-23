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
#import "JSON.h"

#pragma mark - Private Properties
@interface GVoice ()
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, retain) NSString *captchaToken;
@property (nonatomic, retain) NSString *captchaUrl;
@property (nonatomic, retain) NSString *captchaUrl2;
@property (nonatomic, assign) NSInteger redirectCounter;
@property (nonatomic, retain) NSString *rnrSe;

- (NSString *) discoverRNRSE;
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
@synthesize rnrSe = _rnrSe;
@synthesize allSettings = _allSettings;

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
	BOOL ok = NO;
	
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
	[request setValue: USER_AGENT forHTTPHeaderField: USER_AGENT_HEADER];

	NSURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
	
	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice Login Error: %@", err);
		}
		
		self.errorCode = Unknown;
		
		ok = NO;
	} else {
		NSString *retString = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
		
		NSArray *lines = [retString componentsSeparatedByString: @"\n"];
		
		for (NSString *line in lines) {
			NSRange errorRange = [line rangeOfString: @"Error"];
			
			if (errorRange.location != NSNotFound) {
				NSArray *tokens = [line componentsSeparatedByString: @"="];
				
				[self setErrorCodeFromReturnValue: [tokens objectAtIndex: 1]];
				ok = NO;
				
				break;
			} else {			
				NSRange textRange = [line rangeOfString: @"Auth"];
				
				if (textRange.location != NSNotFound) {
					NSArray *tokens = [line componentsSeparatedByString: @"="];
					self.authToken = [tokens objectAtIndex: 1];
					break;
				}
			}
		}

		if (self.authToken) {
			ok = YES;
		}
				
		[retString release];		
	}
	
	[request release];
	
	if (ok) {
		NSDictionary *dict = [self fetchGeneral];
		
		self.general = [dict objectForKey: RAW_DATA];
		
		if (self.general) {
			self.rnrSe = [self discoverRNRSE];
		}
	}
	
	return ok;
}

#pragma mark - Private Methods
- (NSString *) fullAuthString {
	return [NSString stringWithFormat: @"GoogleLogin auth=%@", self.authToken];	
}

- (NSDictionary *) fetchPage: (NSInteger) page fromUrl: (NSString *) urlString asDictionary: (BOOL) asDictionary {
	NSString *fullUrlString;
	
	if (page == 0) {
		fullUrlString = urlString;
	} else {
		fullUrlString = [urlString stringByAppendingFormat: @"?page=p%d", page];
	}
	
	NSURL *url = [NSURL URLWithString: fullUrlString];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
		
	[request setValue: [self fullAuthString] forHTTPHeaderField: @"Authorization"];
	[request setValue: USER_AGENT forHTTPHeaderField: @"User-agent"];

	NSHTTPURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
	NSString *retString = nil;
	
	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice Fetch Error: %@", err);
		}
		
		self.errorCode = Unknown;
	} else {
		NSInteger statusCode = resp.statusCode;
		
		if (statusCode == 200) {
			retString = [[[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding] autorelease];
		} else if (statusCode == 301 ||
				   statusCode == 302 ||
				   statusCode == 303 ||
				   statusCode == 307) {
			self.redirectCounter++;
			
			if (self.redirectCounter > MAX_REDIRECTS) {
				self.redirectCounter = 0;
				
				self.errorCode = TooManyRedirects;
			}
			
			// Need to handle redirect
		}
	}
	
	[request release];
	
	NSDictionary *dict;
	
	if (retString) {
		if (asDictionary) {
			NSString *jsonSubStr = [ParsingUtils removeTextSurrounding: retString
														  startingWith: @"<json><![CDATA["
															endingWith: @"]]></json>"
													   includingTokens: NO];
			
			SBJsonParser *json = [[SBJsonParser alloc] init];
			dict = [[json objectWithString: jsonSubStr] autorelease];
			
			[json release];
		} else {
			dict = [NSDictionary dictionaryWithObject: retString forKey: RAW_DATA];
		}
	}
	
	return dict;
}

- (NSDictionary *) fetchPage: (NSInteger) page fromUrl: (NSString *) urlString {
	return [self fetchPage: page fromUrl: urlString asDictionary: YES];
}

- (NSDictionary *) fetchFromUrl: (NSString *) urlString asDictionary: (BOOL) asDictionary {
	return [self fetchPage: 0 fromUrl: urlString asDictionary: asDictionary];
}

- (NSDictionary *) fetchFromUrl: (NSString *) urlString {
	return [self fetchPage: 0 fromUrl: urlString asDictionary: YES];
}

- (NSDictionary *) postParameters: (NSString *) params toUrl: (NSString *) urlString {
	NSData *requestData = [NSData dataWithBytes: [params UTF8String] length: [params length]];
	
	NSURL *url = [NSURL URLWithString: urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
	
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: requestData];
	
	[request setValue: [self fullAuthString] forHTTPHeaderField: AUTHORIZATION_HEADER];
	[request setValue: USER_AGENT forHTTPHeaderField: USER_AGENT_HEADER];
	
	NSURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
	NSString *retString = nil;
	
	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice POST Error: %@", err);
		}
		
		self.errorCode = Unknown;
	} else {
		retString = [[[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding] autorelease];
	}
	
	[request release];
	
	NSString *jsonSubStr = [ParsingUtils removeTextSurrounding: retString
												  startingWith: @"<json><![CDATA["
													endingWith: @"]]></json>"
											   includingTokens: NO];

	SBJsonParser *json = [[SBJsonParser alloc] init];
	NSDictionary *dict = [[json objectWithString: jsonSubStr] autorelease];
	
	[json release];
	
	return dict;
}

- (NSString *) discoverRNRSE {
	NSString *rnr = nil;
	
	if (self.general) {
		NSArray *chunks = [self.general componentsSeparatedByString: @"'_rnr_se': '"];
		
		if (chunks && [chunks count] >= 2) {
			NSString *rnrSsMajor = [chunks objectAtIndex: 1];
			NSArray *rnrChunks = [rnrSsMajor componentsSeparatedByString: @"',"];
			
			if (rnrChunks && [rnrChunks count] > 0) {
				rnr = [rnrChunks objectAtIndex: 0];
			}
		}
	}

	return rnr;
}

- (BOOL) enableOrDisablePhone: (NSString *) paramString {
	BOOL ok = NO;
	
	NSData *requestData = [NSData dataWithBytes: [paramString UTF8String] length: [paramString length]];
	
	NSURL *url = [NSURL URLWithString: PHONE_ENABLE_URL_STRING];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
	
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: requestData];
	
	[request setValue: [self fullAuthString] forHTTPHeaderField: AUTHORIZATION_HEADER];
	[request setValue: USER_AGENT forHTTPHeaderField: USER_AGENT_HEADER];
	
	NSHTTPURLResponse *resp = nil;
	NSError *err = nil;
	
	NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse: &resp error: &err];
	
	if (err) {
		if (self.logToConsole) {
			NSLog(@"GVoice enableOrDisablePhone Error: %@", err);
		}
		
		self.errorCode = Unknown;
		
		ok = NO;
	} else {
		NSInteger statusCode = resp.statusCode;
		
		if (statusCode == 200) {
			NSString *retString = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];
			
			SBJsonParser *json = [[SBJsonParser alloc] init];
			NSDictionary *dict = [json objectWithString: retString];
			
			ok = [[dict objectForKey: @"ok"] boolValue];
						
			[retString release];
			[json release];
		} else if (statusCode == 301 ||
				   statusCode == 302 ||
				   statusCode == 303 ||
				   statusCode == 307) {
			self.redirectCounter++;
			
			if (self.redirectCounter > MAX_REDIRECTS) {
				self.redirectCounter = 0;
				
				self.errorCode = TooManyRedirects;
			}
			
			// Need to handle redirect
		}
	}
	
	[request release];
	
	// At this point, we need to change enabled/disabled for the given phone
	return ok;
}

- (NSArray *) enableOrDisable: (BOOL) enabled phones: (NSArray *) phones  {
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	
	for (int i = 0; i < [phones count]; i++) {
		NSInteger phoneId = [[phones objectAtIndex: i] integerValue];
		
		BOOL res;
		
		if (enabled) {
			res = [self enablePhone: phoneId];	
		} else {
			res = [self disablePhone: phoneId];
		}
		
		[results addObject: [NSNumber numberWithBool: res]];
	}
	
	return results;
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
    [_rnrSe release], _rnrSe = nil;	
    [_allSettings release], _allSettings = nil;
	
	[super dealloc];
}

#pragma mark - Google Voice Methods
- (GVAllSettings *) fetchSettings {
	return [self forceFetchSettings: NO];
}

- (GVAllSettings *) forceFetchSettings: (BOOL) force {
	if (!self.allSettings || force) {
		NSDictionary *dict = [self fetchFromUrl: GROUPS_INFO_URL_STRING];

		GVAllSettings *settings = [[GVAllSettings alloc] initWithDictionary: dict];
		
		self.allSettings = settings;
	}
	
	return self.allSettings;
}

- (NSDictionary *) fetchGeneral {
	return [self fetchFromUrl: GENERAL_URL_STRING asDictionary: NO];
}

- (BOOL) disablePhone: (NSInteger) phoneId {
	NSString *paraString = [NSString stringWithFormat: @"enabled=0&phoneId=%d&_rnr_se=%@", phoneId, [self.rnrSe urlEncoded]];
	
	return [self enableOrDisablePhone: paraString];	
}

- (BOOL) enablePhone: (NSInteger) phoneId {
	NSString *paraString = [NSString stringWithFormat: @"enabled=1&phoneId=%d&_rnr_se=%@", phoneId, [self.rnrSe urlEncoded]];

	return [self enableOrDisablePhone: paraString];
}

- (NSArray *) disablePhones: (NSArray*) phones {
	return [self enableOrDisable: NO phones: phones];
}

- (NSArray *) enablePhones: (NSArray*) phones {
	return [self enableOrDisable: YES phones: phones];	
}

- (NSDictionary *) fetchInbox {
	return [self fetchInboxPage: 0];
}

- (NSDictionary *) fetchInboxPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: INBOX_URL_STRING];
}

- (NSDictionary *) fetchMissed {
	return [self fetchMissedPage: 0];
}

- (NSDictionary *) fetchMissedPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: MISSED_URL_STRING];
}

- (NSDictionary *) fetchPlaced {
	return [self fetchPlacedPage: 0];
}

- (NSDictionary *) fetchPlacedPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: PLACED_URL_STRING];
}

- (NSDictionary *) fetchRawPhonesInfo {
	return [self fetchFromUrl: PHONES_INFO_URL_STRING];
}

- (NSDictionary *) fetchReceived {
	return [self fetchReceivedPage: 0];
}

- (NSDictionary *) fetchReceivedPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: RECEIVED_URL_STRING];
}

- (NSDictionary *) fetchRecent {
	return [self fetchRecentPage: 0];
}

- (NSDictionary *) fetchRecentPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: RECENT_ALL_URL_STRING];
}

- (NSDictionary *) fetchRecorded {
	return [self fetchRecordedPage: 0];
}

- (NSDictionary *) fetchRecordedPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: RECORDED_URL_STRING];
}

- (NSDictionary *) fetchSms {
	return [self fetchSmsPage: 0];
}

- (NSDictionary *) fetchSmsPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: SMS_URL_STRING];
}

- (NSDictionary *) fetchSpam {
	return [self fetchSpamPage: 0];
}

- (NSDictionary *) fetchSpamPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: SPAM_URL_STRING];
}

- (NSDictionary *) fetchStarred {
	return [self fetchStarredPage: 0];
}

- (NSDictionary *) fetchStarredPage: (NSInteger) page {
	return [self fetchPage: page fromUrl: STARRED_URL_STRING];
}

- (BOOL) sendSmsText: (NSString *) text toNumber: (NSString *) number {
	NSString *params = [NSString stringWithFormat: @"phoneNumber=%@&text=%@&_rnr_se=%@",
						[number urlEncoded],
						[text urlEncoded],
						[self.rnrSe urlEncoded]];
	
	NSDictionary *dict = [self postParameters: params toUrl: SMS_SEND_URL_STRING];
	
	return [[dict objectForKey: @"ok"] boolValue];
}

- (BOOL) enableCallPresentation: (BOOL) enable {
	NSString *params = [NSString stringWithFormat: @"directConnect=%d&_rnr_se=%@",
						(enable ? 0 : 1),
						[self.rnrSe urlEncoded]];
	
	NSDictionary *dict = [self postParameters: params toUrl: GENERAL_SETTING_URL_STRING];
	
	return [[dict objectForKey: @"ok"] boolValue];
}

- (BOOL) enableDoNotDisturb: (BOOL) doNotDisturb {
	NSString *params = [NSString stringWithFormat: @"doNotDisturb=%d&_rnr_se=%@",
						(doNotDisturb ? 1 : 0),
						[self.rnrSe urlEncoded]];
	
	NSDictionary *dict = [self postParameters: params toUrl: GENERAL_SETTING_URL_STRING];
	
	return [[dict objectForKey: @"ok"] boolValue];
}

- (BOOL) selectGreeting: (NSInteger) greetingId {
	NSString *params = [NSString stringWithFormat: @"greetingId=%d&_rnr_se=%@",
						greetingId,
						[self.rnrSe urlEncoded]];
	
	NSDictionary *dict = [self postParameters: params toUrl: GENERAL_SETTING_URL_STRING];
	
	return [[dict objectForKey: @"ok"] boolValue];
}





















@end
