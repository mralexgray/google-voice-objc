//
//  GVSettings.h
//  GV
//
//  Created by Joey Gibson on 4/11/11.
//  Copyright Joey Gibson <joey@joeygibson.com>. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GVSettings : NSObject {
	@private
	NSArray *_activeForwardingList;
	NSString *_baseUrl;
	NSInteger _credits;
	NSInteger _defaultGreetingId;
	NSArray *_didInfos;
	BOOL _directConnect;
	NSArray *_disabledIds;
    BOOL _doNotDisturb;
    NSArray *_emailAddresses;
	BOOL _emailNotificationActive;
    NSString *_emailNotificationAddress;
	NSArray *_greetings;
    NSArray *_groupList;
	NSArray *_groups;
	NSString *_language;
	NSString *_primaryDid;
	NSInteger _screenBehavior;
	BOOL _showTranscripts;
	NSArray *_smsNotifications;
	BOOL _smsToEmailActive;
	BOOL _smsToEmailSubject;
	NSInteger _spam;
	NSString *_timezone;
	BOOL _useDidAsCallerId;
	BOOL _useDidAsSource;
}

@property (nonatomic, retain) NSArray *activeForwardingList;
@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic, assign) NSInteger credits;
@property (nonatomic, assign) NSInteger defaultGreetingId;
@property (nonatomic, retain) NSArray *didInfos;
@property (nonatomic, assign, getter=isDirectConnect) BOOL directConnect;
@property (nonatomic, retain) NSArray *disabledIds;
@property (nonatomic, assign, getter=isDoNotDisturb) BOOL doNotDisturb;
@property (nonatomic, retain) NSArray *emailAddresses;
@property (nonatomic, assign, getter=isEmailNotificationActive) BOOL emailNotificationActive;
@property (nonatomic, retain) NSString *emailNotificationAddress;
@property (nonatomic, retain) NSArray *greetings;
@property (nonatomic, retain) NSArray *groupList;
@property (nonatomic, retain) NSArray *groups;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *primaryDid;
@property (nonatomic, assign) NSInteger screenBehavior;
@property (nonatomic, assign, getter=isShowTranscripts) BOOL showTranscripts;
@property (nonatomic, retain) NSArray *smsNotifications;
@property (nonatomic, assign, getter=isSmsToEmailActive) BOOL smsToEmailActive;
@property (nonatomic, assign, getter=isSmsToEmailSubject) BOOL smsToEmailSubject;
@property (nonatomic, assign) NSInteger spam;
@property (nonatomic, retain) NSString *timezone;
@property (nonatomic, assign, getter=isUseDidAsCallerId) BOOL useDidAsCallerId;
@property (nonatomic, assign, getter=isUseDidAsSource) BOOL useDidAsSource;

- (id) initWithDictionary: (NSDictionary *) dict;
@end
