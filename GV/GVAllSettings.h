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
	NSDictionary *_phones;
	GVSettings *_settings;
}

@property (nonatomic, retain) NSArray *phoneList;
@property (nonatomic, retain) NSDictionary *phones;
@property (nonatomic, retain) GVSettings *settings;

- (id) initWithDictionary: (NSDictionary *) dict;
@end
