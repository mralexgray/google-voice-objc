//
//  GVTests.h
//  GVTests
//
//  Created by Joey Gibson on 4/10/11.
//  Copyright 2011 Spectrum K12 School Solutions, Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "GVoice.h"

@interface GVTests : SenTestCase {
@private
    GVoice *_voice;
}

@property (nonatomic, retain) GVoice *voice;

@end
