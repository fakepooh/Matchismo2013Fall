//
//  Deck.h
//  Matchismo2013Fall
//
//  Created by pooh on 11/19/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
