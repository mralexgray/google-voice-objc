//
//  GVoice.h
//  GV
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright 2011 Joey Gibson <joey@joeygibson.com>, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVAllSettings;

// Important Constants
#define SERVICE @"grandcentral"

#define MAX_REDIRECTS 5
#define USER_AGENT @"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.A.B.C Safari/525.13"

#define RAW_DATA @"RAW_DATA"

// HTTP Headers
#define AUTHORIZATION_HEADER @"Authorization"
#define USER_AGENT_HEADER @"User-agent"

// URLs
#define GENERAL_URL_STRING @"https://www.google.com/voice/"
#define LOGIN_URL_STRING @"https://www.google.com/accounts/ClientLogin"
#define INBOX_URL_STRING @"https://www.google.com/voice/inbox/recent/inbox/"
#define STARRED_URL_STRING @"https://www.google.com/voice/inbox/recent/starred/"
#define RECENT_ALL_URL_STRING @"https://www.google.com/voice/inbox/recent/all/"
#define SPAM_URL_STRING @"https://www.google.com/voice/inbox/recent/spam/"
#define TRASH_URL_STRING @"https://www.google.com/voice/inbox/recent/spam/"
#define VOICE_MAIL_URL_STRING @"https://www.google.com/voice/inbox/recent/voicemail/"
#define SMS_URL_STRING @"https://www.google.com/voice/inbox/recent/sms/"
#define RECORDED_URL_STRING @"https://www.google.com/voice/inbox/recent/recorded/"
#define PLACED_URL_STRING @"https://www.google.com/voice/inbox/recent/placed/"
#define RECEIVED_URL_STRING @"https://www.google.com/voice/inbox/recent/received/"
#define MISSED_URL_STRING @"https://www.google.com/voice/inbox/recent/missed/"
#define PHONE_ENABLE_URL_STRING @"https://www.google.com/voice/settings/editDefaultForwarding/"
#define GENERAL_SETTING_URL_STRING @"https://www.google.com/voice/settings/editGeneralSettings/"
#define PHONES_INFO_URL_STRING @"https://www.google.com/voice/settings/tab/phones"
#define GROUPS_INFO_URL_STRING @"https://www.google.com/voice/settings/tab/groups"
#define VOICE_MAIL_INFO_URL_STRING @"https://www.google.com/voice/settings/tab/voicemailsettings"
#define GROUPS_SETTINGS_URL_STRING @"https://www.google.com/voice/settings/editGroup/"
#define SMS_SEND_URL_STRING @"https://www.google.com/voice/sms/send/"

typedef enum {
	NoError,
	BadAuthentication,
	NotVerified,
	TermsNotAgreed,
	CaptchaRequired,
	Unknown,
	AccountDeleted,
	AccountDisabled,
	ServiceDisabled,
	ServiceUnavailable,
	TooManyRedirects
} ErrorCode;

typedef enum {
	GOOGLE,
	HOSTED,
	HOSTED_OR_GOOGLE
} AccountType;

@interface GVoice : NSObject {
    @private
	AccountType _accountType;
	NSString *_source;
	NSString *_user;
	NSString *_password;
	NSString *_authToken;
	NSString *_captchaToken;
	NSString *_captchaUrl;
	NSString *_captchaUrl2;
	NSInteger _redirectCounter;
	ErrorCode _errorCode;
	BOOL _logToConsole;
	
	NSString *_general;
	NSString *_rnrSe;
	GVAllSettings *_allSettings;
}

@property (nonatomic, assign) AccountType accountType;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) ErrorCode errorCode;
@property (nonatomic, assign) BOOL logToConsole;
@property (nonatomic, retain) NSString *general;
@property (nonatomic, retain) GVAllSettings *allSettings;

- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source;
- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (AccountType) accountType;
- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (AccountType) accountType 
	captchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken;

- (BOOL) login;
- (BOOL) loginWithCaptchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken;

- (NSString *) errorDescription;

- (NSDictionary *) fetchGeneral;
- (GVAllSettings *) fetchSettings;
- (GVAllSettings *) forceFetchSettings: (BOOL) force;
- (BOOL) disablePhone: (NSInteger) phoneId;
- (BOOL) enablePhone: (NSInteger) phoneId;
- (NSArray *) disablePhones: (NSArray*) phones;
- (NSArray *) enablePhones: (NSArray*) phones;
- (NSDictionary *) fetchInbox;
- (NSDictionary *) fetchInboxPage: (NSInteger) page;
- (NSDictionary *) fetchMissed;
- (NSDictionary *) fetchMissedPage: (NSInteger) page;
- (NSDictionary *) fetchPlaced;
- (NSDictionary *) fetchPlacedPage: (NSInteger) page;
- (NSDictionary *) fetchRawPhonesInfo;
- (NSDictionary *) fetchReceived;
- (NSDictionary *) fetchReceivedPage: (NSInteger) page;
- (NSDictionary *) fetchRecent;
- (NSDictionary *) fetchRecentPage: (NSInteger) page;
- (NSDictionary *) fetchRecorded;
- (NSDictionary *) fetchRecordedPage: (NSInteger) page;
- (NSDictionary *) fetchSms;
- (NSDictionary *) fetchSmsPage: (NSInteger) page;
- (NSDictionary *) fetchSpam;
- (NSDictionary *) fetchSpamPage: (NSInteger) page;
- (NSDictionary *) fetchStarred;
- (NSDictionary *) fetchStarredPage: (NSInteger) page;
- (BOOL) sendSmsText: (NSString *) text toNumber: (NSString *) number;
- (BOOL) enableCallPresentation: (BOOL) enable;
- (BOOL) enableDoNotDisturb: (BOOL) doNotDisturb;
- (BOOL) selectGreeting: (NSInteger) greetingId;

// - (BOOL) applySettingsForGroup: (GVGroup *) group;
// - (NSArray *) fetchGreetings;
// - (BOOL) isLoggedIn;









@end
