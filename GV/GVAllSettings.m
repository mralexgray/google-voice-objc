//
//  GVSettings.m
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import "GVAllSettings.h"

@implementation GVAllSettings

@synthesize phoneList = _phoneList;
@synthesize phones = _phones;
@synthesize settings = _settings;

#pragma mark - Init Methods
- (id) initWithDictionary: (NSDictionary *) dict {
	self = [super init];
	
	if (self) {
		self.phoneList = [dict objectForKey: @"phoneList"];
		self.phones = [dict objectForKey: @"phones"];
		self.settings = [[GVSettings alloc] initWithDictionary: [dict objectForKey: @"settings"]];
	}
	
	return self;
}

#pragma mark - Life Cycle Methods
- (void)dealloc {	
    [_phoneList release], _phoneList = nil;
    [_phones release], _phones = nil;
    [_settings release], _settings = nil;
	
	[super dealloc];
}
@end
