//
//  GVVoice.h
//  GV
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright 2011 Joey Gibson <joey@joeygibson.com>, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Important Constants
#define SERVICE @"grandcentral"

#define GOOGLE @"GOOGLE"
#define HOSTED @"HOSTED"
#define HOSTED_OR_GOOGLE @"HOSTED_OR_GOOGLE"

#define MAX_REDIRECTS 5
#define USER_AGENT @"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.A.B.C Safari/525.13"

// URLs
#define GENERAL_URL_STRING "https://www.google.com/voice/"
#define LOGIN_URL_STRING "https://www.google.com/accounts/ClientLogin"
#define INBOX_URL_STRING "https://www.google.com/voice/inbox/recent/inbox/"
#define STARRED_URL_STRING "https://www.google.com/voice/inbox/recent/starred/"
#define RECENT_ALL_URL_STRING "https://www.google.com/voice/inbox/recent/all/"
#define SPAM_URL_STRING "https://www.google.com/voice/inbox/recent/spam/"
#define TRASH_URL_STRING "https://www.google.com/voice/inbox/recent/spam/"
#define VOICE_MAIL_URL_STRING "https://www.google.com/voice/inbox/recent/voicemail/"
#define SMS_URL_STRING "https://www.google.com/voice/inbox/recent/sms/"
#define RECORDED_URL_STRING "https://www.google.com/voice/inbox/recent/recorded/"
#define PLACED_URL_STRING "https://www.google.com/voice/inbox/recent/placed/"
#define RECEIVED_URL_STRING "https://www.google.com/voice/inbox/recent/received/"
#define MISSED_URL_STRING "https://www.google.com/voice/inbox/recent/missed/"
#define PHONE_ENABLE_URL_STRING "https://www.google.com/voice/settings/editDefaultForwarding/"
#define GENERAL_SETTING_URL_STRING "https://www.google.com/voice/settings/editGeneralSettings/"
#define PHONES_INFO_URL_STRING "https://www.google.com/voice/settings/tab/phones"
#define GROUPS_INFO_URL_STRING "https://www.google.com/voice/settings/tab/groups"
#define VOICE_MAIL_INFO_URL_STRING "https://www.google.com/voice/settings/tab/voicemailsettings"
#define GROUPS_SETTINGS_URL_STRING "https://www.google.com/voice/settings/editGroup/"

@interface GVVoice : NSObject {
    @private
	NSString *_accountType;
	NSString *_source;
	NSString *_user;
	NSString *_password;
	NSString *_authToken;
	NSString *_captchaToken;
	NSString *_captchaUrl;
	NSString *_captchaUrl2;
	NSInteger _redirectCounter;
}

@property (nonatomic, retain) NSString *accountType;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *password;

- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source;
- (id) initWIthUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (NSString *) accountType;
- (id) initWIthUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (NSString *) accountType 
	captchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken;
@end
