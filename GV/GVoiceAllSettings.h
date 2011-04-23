//
//  GVSettings.h
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVoiceSettings.h"

@interface GVoiceAllSettings : NSObject {
    NSArray *_phoneList;
	NSDictionary *_phones;
	GVoiceSettings *_settings;
}

@property (nonatomic, retain) NSArray *phoneList;
@property (nonatomic, retain) NSDictionary *phones;
@property (nonatomic, retain) GVoiceSettings *settings;

- (id) initWithDictionary: (NSDictionary *) dict;
@end
