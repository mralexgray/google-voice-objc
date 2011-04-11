//
//  GVTests.m
//  GVTests
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import "GVTests.h"
#import "GVCredentials.h"

@implementation GVTests

@synthesize voice = _voice;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
	self.voice = [[GVoice alloc] initWithUser: USERNAME password: PASSWORD source: SOURCE];
}

- (void)tearDown
{
    // Tear-down code here.
    self.voice = nil;
	
    [super tearDown];
}

//- (void)testLogin
//{
//	STAssertNotNil(self.voice, @"No voice object");
//	
//	self.voice.logToConsole = YES;
//	
//	BOOL res = [self.voice login];
//	
//	if (!res) {
//		STFail(@"Failed Login: %@", self.voice.errorDescription);
//	}
//}
//
//- (void)testLoginWithBadCredentials
//{
//	self.voice.logToConsole = YES;
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

@end
