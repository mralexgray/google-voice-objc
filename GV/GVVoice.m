//
//  GVVoice.m
//  GV
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright 2011 Joey Gibson <joey@joeygibson.com>, Inc. All rights reserved.
//

#import "GVVoice.h"

@interface GVVoice ()
@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, retain) NSString *captchaToken;
@property (nonatomic, retain) NSString *captchaUrl;
@property (nonatomic, retain) NSString *captchaUrl2;
@property (nonatomic, assign) NSInteger redirectCounter;
@end
	
@implementation GVVoice

@synthesize accountType = _accountType;
@synthesize source = _source;
@synthesize user = _user;
@synthesize password = _password;
@synthesize authToken = _authToken;
@synthesize captchaToken = _captchaToken;
@synthesize captchaUrl = _captchaUrl;
@synthesize captchaUrl2 = _captchaUrl2;
@synthesize redirectCounter = _redirectCounter;

- (id) initWithUser: (NSString *) user password: (NSString *) password source: (NSString *) source {
	return [self initWIthUser: user
					 password: password
					   source: source
				  accountType: nil
			  captchaResponse: nil
				 captchaToken: nil];
}

- (id) initWIthUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (NSString *) accountType {
	return [self initWIthUser: user
					 password: password
					   source: source
				  accountType: accountType
			  captchaResponse: nil
				 captchaToken: nil];	
}

- (id) initWIthUser: (NSString *) user password: (NSString *) password source: (NSString *) source accountType: (NSString *) accountType 
	captchaResponse: (NSString *) captchaResponse captchaToken: (NSString *) captchaToken {
	self = [super init];
	
	if (self) {
		self.user = user;
		self.password = password;
		self.source = source;
		self.accountType = accountType;
		self.captchaToken = captchaToken;
	}
	
	return self;
}

@end
