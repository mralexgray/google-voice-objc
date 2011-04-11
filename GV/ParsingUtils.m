//
//  ParsingUtils.m
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import "ParsingUtils.h"


@implementation ParsingUtils

+ (NSString *) removeTextSurrounding: (NSString *) text startingWith: (NSString *) start endingWith: (NSString *) end includingTokens: (BOOL) includeTokens {
	NSRange startRange = [text rangeOfString: start];
	NSRange endRange = [text rangeOfString: end];
	
	if (startRange.location == NSNotFound ||
		endRange.location == NSNotFound) {
		return text;
	}
	
	if (!includeTokens) {
		startRange.location += startRange.length;
		startRange.length = 0;
		
		endRange.location -= endRange.length;
	}
	
	NSRange substringRange = NSUnionRange(startRange, endRange);
	
	return [text substringWithRange: substringRange];
}

@end
