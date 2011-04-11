//
//  GVSettings.h
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVSettings.h"

@interface GVAllSettings : NSObject {
    NSArray *_phoneList;
	NSArray *_phones;
	GVSettings *_settings;
}

@property (nonatomic, retain) NSArray *phoneList;
@property (nonatomic, retain) NSArray *phones;
@property (nonatomic, retain) GVSettings *settings;

- (id) initWithJsonString: (NSString *) string;
@end
