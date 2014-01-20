//
//  Settings.h
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 20.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
/*! Returns default settings
 */
+ (Settings *)defaults;

/*! Returns settings inside the dictionary
 */
@property (nonatomic, strong) NSMutableDictionary *settings;

@property (nonatomic) NSUInteger mismatchPenalty;
@property (nonatomic) NSUInteger matchBonus;
@property (nonatomic) NSUInteger costToChoose;
@property (nonatomic) NSUInteger suitsMatch;
@property (nonatomic) NSUInteger ranksMatch;
@property (nonatomic) NSUInteger setMatch;

extern NSString *const SettingsKeyGeneral;
extern NSString *const SettingsKeyMismatchPenalty;
extern NSString *const SettingsKeyMatchBonus;
extern NSString *const SettingsKeyCostToChoose;

extern NSString *const SettingsKeyPlayingCard;
extern NSString *const SettingsKeySuitsMatch;
extern NSString *const SettingsKeyRanksMatch;

extern NSString *const SettingsKeySet;
extern NSString *const SettingsKeySetMatch;

@end
