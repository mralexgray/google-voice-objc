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
	self.voice = [[GVoice alloc] initWithUser: USERNAME password: PASSWORD source: SOURCE accountType: TEST_ACCOUNT_TYPE];
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
		
		STAssertEquals(self.voice.errorCode, BadAuthentication, @"Should have generated BadAuthentication");
	}
}

- (void) testGetSettings {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
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

- (void) testTogglePhone {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	BOOL enabledAlready = [self.voice isPhoneEnabled: 1];
	
	BOOL ret;
	
	if (enabledAlready) {
		ret = [self.voice disablePhone: 1];
	} else {
		ret = [self.voice enablePhone: 1];
	}
		
	STAssertTrue(ret, @"Failed to %@ phone", (enabledAlready ? @"disable" : @"enable"));
	
	// Put things back the way they were
	if (enabledAlready) {
		ret = [self.voice enablePhone: 1];
	} else {
		ret = [self.voice disablePhone: 1];
	}
	
	STAssertTrue(ret, @"Failed to %@ phone", (enabledAlready ? @"re-disable" : @"re-enable"));
}

// This test will disable all enabled phones, and enable all disabled phones. It then
// puts things back the way they started.
- (void) testToggleAllPhones {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSMutableArray *phonesToEnable = [NSMutableArray array];
	NSMutableArray *phonesToDisable = [NSMutableArray array];
	NSInteger failureCount = 0;
	
	for (NSNumber *num in self.voice.allSettings.phoneList) {
		NSInteger phoneId = [num integerValue];
		
		BOOL enabledAlready = [self.voice isPhoneEnabled: phoneId];
		
		NSLog(@"Phone %@ is %@", num, (enabledAlready ? @"enabled" : @"disabled"));
			  
		if (enabledAlready) {
			[phonesToDisable addObject: num];
		} else {
			[phonesToEnable addObject: num];
		}
	}
	
	if ([phonesToDisable count] > 0) {
		NSArray *retVals = [self.voice disablePhones: phonesToDisable];
		
		NSPredicate *predicate = [NSPredicate predicateWithValue: NO];
		
		NSArray *failed = [retVals filteredArrayUsingPredicate: predicate];
		
		if ([failed count] > 0) {
			failureCount += [failed count];
		}
		
		retVals = [self.voice enablePhones: phonesToDisable];
	}
	
	if ([phonesToEnable count] > 0) {
		NSArray *retVals = [self.voice enablePhones: phonesToEnable];
		
		NSPredicate *predicate = [NSPredicate predicateWithValue: NO];
		
		NSArray *failed = [retVals filteredArrayUsingPredicate: predicate];
		
		if ([failed count] > 0) {
			failureCount += [failed count];
		}
		
		retVals = [self.voice disablePhones: phonesToEnable];
	}
	
	STAssertEquals(failureCount, 0, @"Failure count should be 0");
}

- (void) testSendSmsTextToNumber {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	BOOL ok = [self.voice sendSmsText: @"Testing 1, 2, 3" toNumber: TEXT_PHONE_NUMBER];
	
	STAssertTrue(ok, @"Failed sending SMS");
}

- (void) testToggleDnd {
	BOOL res = [self.voice login];
	STAssertTrue(res, @"Login failed");
	
	BOOL enabledAlready = self.voice.doNotDisturbEnabled;
	
	BOOL ok;
	
	if (enabledAlready) {
		ok = [self.voice enableDoNotDisturb: NO];
	} else {
		ok = [self.voice enableDoNotDisturb: YES];
	}
	
	STAssertTrue(ok, @"Failed to %@ DND", (enabledAlready ? @"disable" : @"enable"));
	
	if (enabledAlready) {
		ok = [self.voice enableDoNotDisturb: YES];
	} else {
		ok = [self.voice enableDoNotDisturb: NO];
	}
	
	STAssertTrue(ok, @"Failed to %@ DND", (enabledAlready ? @"re-disable" : @"re-enable"));
}

// "Call Presentation" is the pretty name for "directConnect". So, if directConnect is YES,
// then calls will NOT be presented (i.e. you won't get an announcement, and ask if you want 
// to take the call). If it is NO, then you WILL be asked if you want to take the call.
- (void) testToggleCallPresentation {
	BOOL res = [self.voice login];
	STAssertTrue(res, @"Login failed");
	
	BOOL enabledAlready = self.voice.directConnectEnabled;
	
	BOOL ok;
	
	if (enabledAlready) {
		ok = [self.voice enableCallPresentation: NO];
	} else {
		ok = [self.voice enableCallPresentation: YES];
	}
	
	STAssertTrue(ok, @"Failed to %@ call presentation", (enabledAlready ? @"disable" : @"enable"));
	
	if (enabledAlready) {
		ok = [self.voice enableCallPresentation: YES];
	} else {
		ok = [self.voice enableCallPresentation: NO];
	}
	
	STAssertTrue(ok, @"Failed to %@ call presentation", (enabledAlready ? @"re-disable" : @"re-enable"));

}

- (void) testSelectGreeting {
	BOOL res = [self.voice login];
	STAssertTrue(res, @"Login failed");
	
	NSInteger currentGreetingId = self.voice.defaultGreetingId;
	
	NSArray *greetings = self.voice.allSettings.settings.greetings;
	
	NSInteger otherGreetingId = -1;
	
	for (NSDictionary *greeting in greetings) {
		NSNumber *num = [greeting objectForKey: @"id"];
		NSInteger id = [num integerValue];
		
		if (id != currentGreetingId) {
			otherGreetingId = id;
			break;
		}
	}
	
	if (otherGreetingId >= 0) {
		BOOL ok = [self.voice selectGreeting: otherGreetingId];
		
		STAssertTrue(ok, @"Failed setting greeting");
		
		ok = [self.voice selectGreeting: currentGreetingId];
		
		STAssertTrue(ok, @"Failed re-setting greeting");
	}
}

- (void) testFetchGeneral {
	BOOL res = [self.voice login];
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchGeneral];
	
	STAssertNotNil(dict, @"Nil results fetching General");
		
	STAssertTrue([dict count] == 1, @"No results fetching General");
	
	STAssertNotNil([dict objectForKey: RAW_DATA], @"General string is null");
}

- (void) testFetchInbox {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchInbox];
	
	STAssertNotNil(dict, @"Nil results fetching Inbox");
	
	STAssertTrue([dict count] > 0, @"No results fetching Inbox");
}

- (void) testFetchMissed {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchMissed];
	
	STAssertNotNil(dict, @"Nil results fetching Missed");
	
	STAssertTrue([dict count] > 0, @"No results fetching Missed");
}

- (void) testFetchPlaced {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchPlaced];
	
	STAssertNotNil(dict, @"Nil results fetching Placed");
	
	STAssertTrue([dict count] > 0, @"No results fetching Placed");
}

- (void) testFetchReceived {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchReceived];
	
	STAssertNotNil(dict, @"Nil results fetching Received");
	
	STAssertTrue([dict count] > 0, @"No results fetching Received");
}

- (void) testFetchRecent {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchRecent];
	
	STAssertNotNil(dict, @"Nil results fetching Recent");
	
	STAssertTrue([dict count] > 0, @"No results fetching Recent");
}

- (void) testFetchRecorded {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchRecorded];
	
	STAssertNotNil(dict, @"Nil results fetching Recorded");
	
	STAssertTrue([dict count] > 0, @"No results fetching Recorded");
}

- (void) testFetchSms {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchSms];
	
	STAssertNotNil(dict, @"Nil results fetching SMS");
	
	STAssertTrue([dict count] > 0, @"No results fetching SMS");
}

- (void) testFetchSpam {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchSpam];
	
	STAssertNotNil(dict, @"Nil results fetching Spam");
	
	STAssertTrue([dict count] > 0, @"No results fetching Spam");
}

- (void) testFetchStarred {
	BOOL res = [self.voice login];
	
	STAssertTrue(res, @"Login failed");
	
	NSDictionary *dict = [self.voice fetchStarred];
	
	STAssertNotNil(dict, @"Nil results fetching Starred");
	
	STAssertTrue([dict count] > 0, @"No results fetching Starred");
}

//- (NSDictionary *) fetchRawPhonesInfo;

















@end
