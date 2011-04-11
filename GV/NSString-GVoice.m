//
//  NSString-GVoice.m
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//
//  This code came from http://stackoverflow.com/questions/2590545/urlencoding-a-string-with-objective-c/2590725#2590725

#import "NSString-GVoice.h"

@implementation NSString (GVoice)
-(NSString *) urlEncoded
{
	CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
																	NULL,
																	(CFStringRef)self,
																	NULL,
																	(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	kCFStringEncodingUTF8 );
    return [(NSString *)urlString autorelease];
}
@end
