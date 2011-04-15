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
	self.voice = [[GVoice alloc] initWithUser: USERNAME password: PASSWORD source: SOURCE accountType: GOOGLE];
	self.voice.logToConsole = YES;
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
	
	BOOL res = [self.voice login];
	
	if (!res) {
		STFail(@"Failed Login: %@", self.voice.errorDescription);
	}
}

- (void) testLoginWithBadCredentials
{
	NSString *saveUser = self.voice.user;
	
	self.voice.user = [self.voice.user stringByAppendingString: @"BOGUS"];
	
	BOOL res = [self.voice login];
	
	if (!res) {
		self.voice.user = saveUser;
		
		STAssertTrue(self.voice.errorCode == BadAuthentication, @"Should have generated BadAuthentication");
	}
}

- (void) testGetSettings {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	[NSRunLoop currentRunLoop];
	
	GVAllSettings *allSettings = [self.voice fetchSettings];
	
	STAssertNotNil(allSettings, @"Settings should not be nil");
	STAssertNotNil(allSettings.phoneList, @"phoneList should not be nil");
	STAssertNotNil(allSettings.phones, @"phones should not be nil");

	GVSettings *settings = allSettings.settings;
	
	STAssertNotNil(settings, @"settings should not be nil");
	
	STAssertNotNil(settings.language, @"language should not be nil");
	STAssertNotNil(settings.activeForwardingList, @"activeForwardingList should not be nil");
	STAssertTrue([settings.activeForwardingList count] > 0, @"activeForwardingList should not be nil");
	STAssertNotNil(settings.baseUrl, @"baseUrl should not be nil");
	STAssertNotNil(settings.emailAddresses, @"emailAddresses should not be nil");
	STAssertTrue([settings.emailAddresses count] > 0, @"emailAddresses should not be nil");
}

























@end
