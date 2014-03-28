//
//  SetCard.m
//  Matchismo2013Fall
//
//  Created by pooh on 1/14/14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSString *)contents {
    return nil;
}

//static const int MATCH_SCORE = 7;

- (NSInteger)match:(NSArray *)otherCards {
    NSInteger score = 0;
	Settings *settings = [SettingsSingleton sharedSettingsSingleton].settings;
    
    if ([otherCards count] == 2) {
		// 3-card game
        SetCard *otherCard1 = [otherCards firstObject];
        SetCard *otherCard2 = [otherCards lastObject];
//		Conditions:
		BOOL condition1, condition2, condition3, condition4;
//	1.	They all have the same number, or they have three different numbers.
		condition1 = (self.number == otherCard1.number && self.number == otherCard2.number) ||
			(self.number != otherCard1.number && self.number != otherCard2.number && otherCard1.number != otherCard2.number);
//	2.	They all have the same symbol, or they have three different symbols.
		condition2 = ([self.symbol isEqualToString:otherCard1.symbol] && [self.symbol isEqualToString:otherCard2.symbol]) || (![self.symbol isEqualToString:otherCard1.symbol] && ![self.symbol isEqualToString:otherCard2.symbol] && ![otherCard1.symbol isEqualToString:otherCard2.symbol]);
//	3.	They all have the same shading, or they have three different shadings.
		condition3 = ([self.shading isEqualToString:otherCard1.shading] && [self.shading isEqualToString:otherCard2.shading]) || (![self.shading isEqualToString:otherCard1.shading] && ![self.shading isEqualToString:otherCard2.shading] && ![otherCard1.shading isEqualToString:otherCard2.shading]);
//	4.	They all have the same color, or they have three different colors.
		condition4 = ([self.color isEqualToString:otherCard1.color] && [self.color isEqualToString:otherCard2.color]) || (![self.color isEqualToString:otherCard1.color] && ![self.color isEqualToString:otherCard2.color] && ![otherCard1.color isEqualToString:otherCard2.color]);
		if (condition1 && condition2 && condition3 && condition4) {
			score = settings.setMatch; // match!
		}
    }
    
    return score;
}

+ (NSArray *)validSymbols {
    return @[@"▴", @"●", @"▪︎"];
}

+ (NSArray *)validShadings {
    return @[@"solid", @"striped", @"open"];
}

+ (NSArray *)validColors {
    return @[@"red", @"green", @"purple"];
}

+ (NSUInteger)maxNumber {
    return 3;
}



@synthesize symbol = _symbol;
@synthesize color = _color;
@synthesize shading = _shading;

- (void)setSymbol:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)symbol {
    return _symbol ? _symbol : @"?";
}

- (void)setShading:(NSString *)shading {
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (NSString *)shading {
    return _shading ? _shading : @"?";
}

- (void)setColor:(NSString *)color {
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *)color {
    return _color ? _color : @"?";
}

@end
