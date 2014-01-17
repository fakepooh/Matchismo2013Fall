//
//  PlayingCardGameViewController.m
//  Matchismo2013Fall
//
//  Created by pooh on 1/11/14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (NSAttributedString *)describeCardsArray:(NSArray *)cards {
	return [[NSAttributedString alloc] initWithString:[cards componentsJoinedByString:@" "]];
}

@end
