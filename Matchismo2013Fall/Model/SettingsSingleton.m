//
//  SettingsSingleton.m
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 21.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "SettingsSingleton.h"

@implementation SettingsSingleton

+ (SettingsSingleton *)sharedSettingsSingleton
{
    static SettingsSingleton* modelSingleton = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        modelSingleton = [[SettingsSingleton alloc] init];
    });
	
    return modelSingleton;
}

- (Settings *)settings {
	if (!_settings)
		_settings = [[Settings alloc] init];
	return _settings;
}

@end
