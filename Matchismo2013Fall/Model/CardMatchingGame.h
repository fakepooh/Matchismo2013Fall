//
//  CardMatchingGame.h
//  Matchismo2013Fall
//
//  Created by pooh on 11/27/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

/*! Designated initializer
 @param count Cout of cards in the deck
 @param deck Deck to draw cards from 
 @param mode Playing 2-card game (0) or Set (3-card) game (1)
 */
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                           inMode:(NSInteger)mode; // 0 - 2-card, 1 - 3-card

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;

/*! 0 - result, 1-n - cards involved
 result:
 -N - mismatch
 N - match
 count < 2 - match was not performed
 */
@property (nonatomic, strong, readonly) NSMutableArray *lastActionResult;

@end
