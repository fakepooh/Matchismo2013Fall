//
//  Card.m
//  Matchismo2013Fall
//
//  Created by pooh on 11/19/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSInteger)match:(NSArray *)otherCards {
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
