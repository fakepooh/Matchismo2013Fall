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

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    
    
    return score;
}

+ (NSArray *)validSymbols {
    return @[@"▲", @"●", @"◼"];
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
