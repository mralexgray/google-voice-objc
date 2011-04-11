//
//  ParsingUtils.h
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ParsingUtils : NSObject {
    
}

+ (NSString *) removeTextSurrounding: (NSString *) text startingWith: (NSString *) start endingWith: (NSString *) end includingTokens: (BOOL) includeTokens;

@end
