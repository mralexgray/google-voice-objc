//
//  GVSettings.m
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import "GVoiceSettings.h"

@implementation GVoiceSettings

@synthesize activeForwardingList = _activeForwardingList;
@synthesize baseUrl = _baseUrl;
@synthesize credits = _credits;
@synthesize defaultGreetingId = _defaultGreetingId;
@synthesize didInfos = _didInfos;
@synthesize directConnect = _directConnect;
@synthesize disabledIds = _disabledIds;
@synthesize doNotDisturb = _doNotDisturb;
@synthesize emailAddresses = _emailAddresses;
@synthesize emailNotificationActive = _emailNotificationActive;
@synthesize emailNotificationAddress = _emailNotificationAddress;
@synthesize greetings = _greetings;
@synthesize groupList = _groupList;
@synthesize groups = _groups;
@synthesize language = _language;
@synthesize primaryDid = _primaryDid;
@synthesize screenBehavior = _screenBehavior;
@synthesize showTranscripts = _showTranscripts;
@synthesize smsNotifications = _smsNotifications;
@synthesize smsToEmailActive = _smsToEmailActive;
@synthesize smsToEmailSubject = _smsToEmailSubject;
@synthesize spam = _spam;
@synthesize timezone = _timezone;
@synthesize useDidAsCallerId = _useDidAsCallerId;
@synthesize useDidAsSource = _useDidAsSource;

#pragma mark - Life Cycle Methods
- (id) initWithDictionary: (NSDictionary *) dict {
	self = [super init];
	
	if (self) {
		self.activeForwardingList = [dict objectForKey: @"activeForwardingIds"];
		self.baseUrl = [dict objectForKey: @"baseUrl"];
		self.credits = [[dict objectForKey: @"credits"] integerValue];
		self.defaultGreetingId = [[dict objectForKey: @"defaultGreetingId"] integerValue];
		self.didInfos = [dict objectForKey: @"didInfos"];
 		self.directConnect = [[dict objectForKey: @"directConnect"] boolValue];
		self.disabledIds = [dict objectForKey: @"disabledIdMap"];
		self.doNotDisturb = [[dict objectForKey: @"doNotDisturb"] boolValue];
		self.emailAddresses = [dict objectForKey: @"emailAddresses"];
		self.emailNotificationActive = [[dict objectForKey: @"emailNotificationActive"] boolValue];
		self.emailNotificationAddress = [dict objectForKey: @"emailNotificationAddress"];
		self.greetings = [dict objectForKey: @"greetings"];
		self.groupList = [dict objectForKey: @"groupList"];
		self.groups = [dict objectForKey: @"groups"];
		self.language = [dict objectForKey: @"language"];
		self.primaryDid = [dict objectForKey: @"primaryDid"];
		self.screenBehavior = [[dict objectForKey: @"screenBehavior"] integerValue];
		self.showTranscripts = [[dict objectForKey: @"showTranscripts"] boolValue];
		self.smsNotifications = [dict objectForKey: @"smsNotifications"];
		self.smsToEmailActive = [[dict objectForKey: @"smsToEmailActive"] boolValue];
		self.smsToEmailSubject = [[dict objectForKey: @"smsToEmailSubject"] boolValue];
		self.spam = [[dict objectForKey: @"spam"] integerValue];
		self.timezone = [dict objectForKey: @"timezone"];
		self.useDidAsCallerId = [[dict objectForKey: @"useDidAsCallerId"] boolValue];
		self.useDidAsSource = [[dict objectForKey: @"useDidAsSource"] boolValue];
	}
	
	return self;
}

- (void)dealloc {	
    [_activeForwardingList release], _activeForwardingList = nil;
    [_baseUrl release], _baseUrl = nil;
    [_didInfos release], _didInfos = nil;
    [_disabledIds release], _disabledIds = nil;
    [_emailAddresses release], _emailAddresses = nil;
    [_emailNotificationAddress release], _emailNotificationAddress = nil;
    [_greetings release], _greetings = nil;
    [_groupList release], _groupList = nil;
    [_groups release], _groups = nil;
    [_language release], _language = nil;
    [_primaryDid release], _primaryDid = nil;
    [_smsNotifications release], _smsNotifications = nil;
    [_timezone release], _timezone = nil;
	
	[super dealloc];
}
@end
