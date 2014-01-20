//
//  SettingsSingleton.h
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 21.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface SettingsSingleton : NSObject
+ (SettingsSingleton *)sharedSettingsSingleton;
@property (nonatomic, strong) Settings *settings;
@end
