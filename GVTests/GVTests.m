//
//  GVTests.m
//  GVTests
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright 2011 Spectrum K12 School Solutions, Inc. All rights reserved.
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

- (void)testLogin
{
	STAssertNotNil(self.voice, @"No voice object");
	
	self.voice.logToConsole = YES;
	
	NSLog(@"Testing login");
	BOOL res = [self.voice login];
	NSLog(@"Login: %d", res);
	
	if (!res) {
		STFail(@"Failed Login: %@", self.voice.errorDescription);
	}
}

@end
