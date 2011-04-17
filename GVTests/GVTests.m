//
//  GVTests.m
//  GVTests
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import "GVTests.h"
#import "GVCredentials.h"
#import "GVAllSettings.h"
#import "GVSettings.h"

@implementation GVTests

@synthesize voice = _voice;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	self.voice = [[GVoice alloc] initWithUser: USERNAME password: PASSWORD source: SOURCE accountType: HOSTED];
	self.voice.logToConsole = NO;
}

- (void)tearDown
{
    // Tear-down code here.
    self.voice = nil;
	
    [super tearDown];
}

- (void) testLogin
{
	STAssertNotNil(self.voice, @"No voice object");
	self.voice.logToConsole = YES;
	
	BOOL res = [self.voice login];
	
	if (!res) {
		STFail(@"Failed Login: %@", self.voice.errorDescription);
	}
}
//
//- (void) testLoginWithBadCredentials
//{
//	NSString *saveUser = self.voice.user;
//	
//	self.voice.user = [self.voice.user stringByAppendingString: @"BOGUS"];
//	
//	BOOL res = [self.voice login];
//	
//	if (!res) {
//		self.voice.user = saveUser;
//		
//		STAssertTrue(self.voice.errorCode == BadAuthentication, @"Should have generated BadAuthentication");
//	}
//}
//
//- (void) testGetSettings {
//	BOOL res = [self.voice login];
//	
//	STAssertTrue(res, @"Login failed");
//	
//	GVAllSettings *allSettings = [self.voice fetchSettings];
//	
//	STAssertNotNil(allSettings, @"Settings should not be nil");
//	STAssertNotNil(allSettings.phoneList, @"phoneList should not be nil");
//	STAssertNotNil(allSettings.phones, @"phones should not be nil");
//
//	GVSettings *settings = allSettings.settings;
//	
//	STAssertNotNil(settings, @"settings should not be nil");
//	
//	STAssertNotNil(settings.language, @"language should not be nil");
//	STAssertNotNil(settings.activeForwardingList, @"activeForwardingList should not be nil");
//	STAssertTrue([settings.activeForwardingList count] > 0, @"activeForwardingList should not be nil");
//	STAssertNotNil(settings.baseUrl, @"baseUrl should not be nil");
//	STAssertNotNil(settings.emailAddresses, @"emailAddresses should not be nil");
//	STAssertTrue([settings.emailAddresses count] > 0, @"emailAddresses should not be nil");
//}
//
//- (void) testDisablePhone {
//	BOOL res = [self.voice login];
//	
//	STAssertTrue(res, @"Login failed");
//	
//	BOOL ret = [self.voice disablePhone: 1];
//	
//	STAssertTrue(ret, @"Failed to enable phone");
//}
//
//- (void) testEnablePhone {
//	BOOL res = [self.voice login];
//	
//	STAssertTrue(res, @"Login failed");
//	
//	BOOL ret = [self.voice enablePhone: 1];
//	
//	STAssertTrue(ret, @"Failed to disable phone");
//}
//
//- (void) testSendSmsTextToNumber {
//	BOOL res = [self.voice login];
//	
//	STAssertTrue(res, @"Login failed");
//	
//	BOOL ok = [self.voice sendSmsText: @"Testing 1, 2, 3" toNumber: TEXT_PHONE_NUMBER];
//	
//	STAssertTrue(ok, @"Failed sending SMS");
//}

//- (void) testEnableDnd {
//	BOOL res = [self.voice login];
//	self.voice.logToConsole = YES;
//	STAssertTrue(res, @"Login failed");
//	
//	BOOL ok = [self.voice enableDoNotDisturb: YES];
//	
//	STAssertTrue(ok, @"Failed enabling DND");
//
//	ok = [self.voice enableDoNotDisturb: NO];
//	
//	STAssertTrue(ok, @"Failed enabling DND");
//}

//- (void) testEnableCallPresentation {
//	BOOL res = [self.voice login];
//	self.voice.logToConsole = YES;
//	STAssertTrue(res, @"Login failed");
//	
//	BOOL ok = [self.voice enableCallPresentation: NO];
//	
//	STAssertTrue(ok, @"Failed enabling call presentation");
//	
//	ok = [self.voice enableCallPresentation: YES];
//	
//	STAssertTrue(ok, @"Failed enabling call presentation");
//}

//- (void) testSelectGreeting {
//	BOOL res = [self.voice login];
//	self.voice.logToConsole = YES;
//	STAssertTrue(res, @"Login failed");
//	
//	BOOL ok = [self.voice selectGreeting: 6];
//	
//	STAssertTrue(ok, @"Failed setting greeting");
//	
//	ok = [self.voice selectGreeting: 0];
//	
//	STAssertTrue(ok, @"Failed setting greeting");
//}

//- (void) testFetchSms {
//	BOOL res = [self.voice login];
//	self.voice.logToConsole = YES;
//	STAssertTrue(res, @"Login failed");
//	
//	NSString *retString = [self.voice fetchSms];
//	
//	STAssertNotNil(retString, @"Nil results getting SMS");
//	STAssertTrue([retString length] > 0, @"Empty string getting SMS");
//}

//- (void) testFetchGeneral {
//	BOOL res = [self.voice login];
//	self.voice.logToConsole = YES;
//	STAssertTrue(res, @"Login failed");
//	
//	NSDictionary *dict = [self.voice fetchGeneral];
//	
//	STAssertNotNil(dict, @"Nil results fetching General");
//	
////	STAssertTrue([dict ] > 0, @"Empty string fetching General");
//}


















@end
