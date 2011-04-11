//
//  ParsingUtilsTests.m
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import "ParsingUtilsTests.h"
#import "ParsingUtils.h"

@implementation ParsingUtilsTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
	
    [super tearDown];
}

- (void)testRemoveTextExcludingTokens {
	NSString *str = @"This is a test of the Emergency Broadcast System. This is only a test.";
	
	NSString *res = [ParsingUtils removeTextSurrounding: str
										   startingWith: @"test"
											 endingWith: @"System"
										includingTokens: NO];
	
	STAssertEqualObjects(@" of the Emergency Broadcast ", res, @"Tokenizer failed");
}

- (void)testRemoveTextIncludingTokens {
	NSString *str = @"This is a test of the Emergency Broadcast System. This is only a test.";
	
	NSString *res = [ParsingUtils removeTextSurrounding: str
										   startingWith: @"test"
											 endingWith: @"System"
										includingTokens: YES];
	
	STAssertEqualObjects(@"test of the Emergency Broadcast System", res, @"Tokenizer failed");
}
@end
