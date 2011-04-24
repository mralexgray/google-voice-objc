//
//  GVoice.h
//  GV
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright 2011 Joey Gibson <joey@joeygibson.com>, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVoiceAllSettings;

// Important Constants
#define SERVICE @"grandcentral"

#define MAX_REDIRECTS 5
#define USER_AGENT @"Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.A.B.C Safari/525.13"

#define RAW_DATA @"RAW_DATA"

// HTTP Headers
#define AUTHORIZATION_HEADER @"Authorization"
#define USER_AGENT_HEADER @"User-agent"

/**
 * The URLs that lead to various parts of Google Voice.
 */
#define GENERAL_URL_STRING @"https://www.google.com/voice/"
#define LOGIN_URL_STRING @"https://www.google.com/accounts/ClientLogin"
#define INBOX_URL_STRING @"https://www.google.com/voice/inbox/recent/inbox/"
#define STARRED_URL_STRING @"https://www.google.com/voice/inbox/recent/starred/"
#define RECENT_ALL_URL_STRING @"https://www.google.com/voice/inbox/recent/all/"
#define SPAM_URL_STRING @"https://www.google.com/voice/inbox/recent/spam/"
#define TRASH_URL_STRING @"https://www.google.com/voice/inbox/recent/trash/"
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

/**
 * Error codes that can come back from Google Voice.
 */
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
} GVoiceErrorCode;

/**
 * Types of Google Voice accounts.
 *
 * It's better to use either GOOGLE or HOSTED, but not the 
 * combined HOSTED_OR_GOOGLE.
 */
typedef enum {
	GOOGLE,
	HOSTED,
	HOSTED_OR_GOOGLE
} GVoiceAccountType;

/**
 * The interface to Google Voice. 
 *
 * This class provides methods to do most of what you'd want to
 * do with Google Voice. You can send SMS messages, initiate calls, enable/disable phones, change 
 * various settings, and download messages. Among other things.
 */
@interface GVoice : NSObject {
    @private
	GVoiceAccountType _accountType;
	NSString *_source;
	NSString *_user;
	NSString *_password;
	NSString *_authToken;
	NSString *_captchaToken;
	NSString *_captchaUrl;
	NSString *_captchaUrl2;
	NSInteger _redirectCounter;
	GVoiceErrorCode _errorCode;
	BOOL _logToConsole;
	
	NSString *_general;
	NSString *_rnrSe;
	GVoiceAllSettings *_allSettings;
}

/**
 * What type of Google Voice account we are working with.
 */
@property (nonatomic, assign) GVoiceAccountType accountType;

/**
 * Source is required by Google. It should be of the form company-product-version
 *
 * @see http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html#Request
 */
@property (nonatomic, retain) NSString *source;

/**
 * The username that will be used for GV access.
 */
@property (nonatomic, retain) NSString *user;

/**
 * The password that will be used for GV access.
 */
@property (nonatomic, retain) NSString *password;

/**
 * The result of some sort of error from GV. 
 */
@property (nonatomic, assign) GVoiceErrorCode errorCode;

/**
 * Whether to log output using NSLog(). Default is NO.
 */
@property (nonatomic, assign) BOOL logToConsole;

/**
 * The top-level settings for GV. 
 */
@property (nonatomic, retain) GVoiceAllSettings *allSettings;

/**
 * Convenience access to allSettings.settings.defaultGreetingId
 */
@property (readonly) NSInteger defaultGreetingId;

/**
 * Convenience access to allSettings.settings.directConnect
 */
@property (readonly) BOOL directConnectEnabled;

/**
 * Convenience accesc to allSettings.settings.doNotDisturb
 */
@property (readonly) BOOL doNotDisturbEnabled;

/**
 * The init method that will be used most often. 
 *
 * This creates a GVoice object that is ready for use, though it has NOT been logged-in yet.
 * @param user the user's GV username
 * @param password the user's GV password
 * @param source the parameter required by GV for logging
 * @param accountType what type of account we are working with
 *
 * @see http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html#Request
 */
- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (GVoiceAccountType) accountType;
- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (GVoiceAccountType) accountType 
	captchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken;

- (BOOL) login;
- (BOOL) loginWithCaptchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken;

- (NSString *) errorDescription;

- (NSDictionary *) fetchGeneral;
- (GVoiceAllSettings *) fetchSettings;
- (GVoiceAllSettings *) forceFetchSettings: (BOOL) force;
- (BOOL) isPhoneEnabled: (NSInteger) phoneId;
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
