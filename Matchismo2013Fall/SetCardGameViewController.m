//
//  SetCardGameViewController.m
//  Matchismo2013Fall
//
//  Created by pooh on 1/14/14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (void)viewWillAppear:(BOOL)animated {
    self.gameMode = 1; //Set Game
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @""; // change it
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"]; // change it
}

@end
