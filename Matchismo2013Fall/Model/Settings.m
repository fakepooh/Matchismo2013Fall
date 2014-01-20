//
//  Settings.m
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 20.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "Settings.h"

@implementation Settings

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

static const int SS2 = 1;   // suits match
static const int RR2 = 4;  // ranks match

static const int SET_MATCH = 7;

 NSString *const SettingsKeyGeneral = @"General";
 NSString *const SettingsKeyMismatchPenalty = @"MISMATCH_PENALTY";
 NSString *const SettingsKeyMatchBonus = @"MATCH_BONUS";
 NSString *const SettingsKeyCostToChoose = @"COST_TO_CHOOSE";

 NSString *const SettingsKeyPlayingCard = @"Playing Card game";
 NSString *const SettingsKeySuitsMatch = @"SS2";
 NSString *const SettingsKeyRanksMatch = @"RR2";

 NSString *const SettingsKeySet = @"Set!";
 NSString *const SettingsKeySetMatch = @"SET_MATCH";

+ (Settings *)defaults {
	Settings *settings = [[Settings alloc] init];
	
	settings.settings =		[@{SettingsKeyGeneral: [@{SettingsKeyMismatchPenalty: @(MISMATCH_PENALTY),
														   SettingsKeyMatchBonus: @(MATCH_BONUS),
														 SettingsKeyCostToChoose: @(COST_TO_CHOOSE)} mutableCopy],
						   SettingsKeyPlayingCard: [@{SettingsKeySuitsMatch: @(SS2),
													  SettingsKeyRanksMatch: @(RR2)} mutableCopy],
								   SettingsKeySet: [@{SettingsKeySetMatch: @(SET_MATCH)} mutableCopy]} mutableCopy];
	
	return settings;
}

@synthesize settings = _settings;

- (NSMutableDictionary *)settings {
	if (!_settings)
		_settings = [Settings defaults].settings;
	return _settings;
}

- (void)setSettings:(NSMutableDictionary *)settings {
	_settings = settings;
	if (_settings) {
		[_settings setObject:[[settings objectForKey:SettingsKeyGeneral] mutableCopy]
					  forKey:SettingsKeyGeneral];
		[_settings setObject:[[settings objectForKey:SettingsKeyPlayingCard] mutableCopy]
					  forKey:SettingsKeyPlayingCard];
		[_settings setObject:[[settings objectForKey:SettingsKeySet] mutableCopy]
					  forKey:SettingsKeySet];
	}
}

- (NSUInteger)mismatchPenalty {
	return [[[self.settings objectForKey:SettingsKeyGeneral] objectForKey:SettingsKeyMismatchPenalty] unsignedIntegerValue];
}

- (void)setMismatchPenalty:(NSUInteger)mismatchPenalty {
	[[self.settings objectForKey:SettingsKeyGeneral] setObject:@(mismatchPenalty)
														forKey:SettingsKeyMismatchPenalty];
}

- (NSUInteger)matchBonus {
	return [[[self.settings objectForKey:SettingsKeyGeneral] objectForKey:SettingsKeyMatchBonus] unsignedIntegerValue];
}

- (void)setMatchBonus:(NSUInteger)matchBonus {
	[[self.settings objectForKey:SettingsKeyGeneral] setObject:@(matchBonus)
														forKey:SettingsKeyMatchBonus];
}

- (NSUInteger)costToChoose {
	return [[[self.settings objectForKey:SettingsKeyGeneral] objectForKey:SettingsKeyCostToChoose] unsignedIntegerValue];
}

- (void)setCostToChoose:(NSUInteger)costToChoose {
	[[self.settings objectForKey:SettingsKeyGeneral] setObject:@(costToChoose)
														forKey:SettingsKeyCostToChoose];
}

- (NSUInteger)suitsMatch {
	return [[[self.settings objectForKey:SettingsKeyPlayingCard] objectForKey:SettingsKeySuitsMatch] unsignedIntegerValue];
}

- (void)setSuitsMatch:(NSUInteger)suitsMatch {
	[[self.settings objectForKey:SettingsKeyPlayingCard] setObject:@(suitsMatch)
															forKey:SettingsKeySuitsMatch];
}

- (NSUInteger)ranksMatch {
	return [[[self.settings objectForKey:SettingsKeyPlayingCard] objectForKey:SettingsKeyRanksMatch] unsignedIntegerValue];
}

- (void)setRanksMatch:(NSUInteger)ranksMatch {
	[[self.settings objectForKey:SettingsKeyPlayingCard] setObject:@(ranksMatch)
															forKey:SettingsKeyRanksMatch];
}

- (NSUInteger)setMatch {
	return [[[self.settings objectForKey:SettingsKeySet] objectForKey:SettingsKeySetMatch] unsignedIntegerValue];
}

- (void)setSetMatch:(NSUInteger)setMatch {
	[[self.settings objectForKey:SettingsKeySet] setObject:@(setMatch)
													forKey:SettingsKeySetMatch];
}

@end
