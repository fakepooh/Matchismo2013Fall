//
//  SetCard.h
//  Matchismo2013Fall
//
//  Created by pooh on 1/14/14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *shading;
@property (nonatomic, strong) NSString *color;

+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;
+ (NSUInteger)maxNumber;

@end
