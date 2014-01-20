//
//  PlayingCard.m
//  Matchismo2013Fall
//
//  Created by pooh on 11/19/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

//// Match scores for different game modes and matches
//// 2-card game
//static const int SS2 = 1;   // suits match
//static const int RR2 = 4;  // ranks match
//// 3-card game - NOT USED NOW
//static const int SS3 = 4;   // 2 suits match
//static const int RR3 = 14;  // 2 ranks match
//static const int SSS3 = 31; // all suits match
//static const int RRSS3 = 33;// 2 ranks and 2 suits match
//static const int RRR3 = 686;// all ranks match

- (int)match:(NSArray *)otherCards {
    int score = 0;
	Settings *settings = [SettingsSingleton sharedSettingsSingleton].settings;
    
    if ([otherCards count] == 1) {
// 2-card game
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = settings.ranksMatch;
        } else {
            if ([otherCard.suit isEqualToString:self.suit])
                score = settings.suitsMatch;
        }
    } else if ([otherCards count] == 2) {
// 3-card game - NOT USED NOW
//        PlayingCard *otherCard1 = [otherCards firstObject];
//        PlayingCard *otherCard2 = [otherCards lastObject];
//        if (self.rank == otherCard1.rank && self.rank == otherCard2.rank) {
//            score = RRR3;
//        } else if ((self.rank == otherCard1.rank || self.rank == otherCard2.rank || otherCard2.rank == otherCard1.rank) && (self.suit == otherCard1.suit || self.suit == otherCard2.suit || otherCard2.suit == otherCard1.suit)) {
//            score = RRSS3;
//        } else if (self.suit == otherCard1.suit && self.suit == otherCard2.suit) {
//            score = SSS3;
//        } else if (self.rank == otherCard1.rank || self.rank == otherCard2.rank || otherCard2.rank == otherCard1.rank) {
//            score = RR3;
//        } else if (self.suit == otherCard1.suit || self.suit == otherCard2.suit || otherCard2.suit == otherCard1.suit) {
//            score = SS3;
//        }
    }
    
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (NSString *)description {
    return [self contents];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♠",@"♣",@"♥",@"♦"];
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {
    return 13;
}

@end
