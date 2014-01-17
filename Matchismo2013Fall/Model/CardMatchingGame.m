//
//  CardMatchingGame.m
//  Matchismo2013Fall
//
//  Created by pooh on 11/27/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic) NSInteger gameMode; // 1 - 2-card (Playing card game), 2 - 3-card (Set card game), etc.
@property (nonatomic, strong, readwrite) NSMutableArray *lastActionResult; // 0 - result, 1-n - cards involved

@end

@implementation CardMatchingGame

- (NSMutableArray *)lastActionResult {
    if (!_lastActionResult) _lastActionResult = [[NSMutableArray alloc] init];
    return _lastActionResult;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    return [self initWithCardCount:count usingDeck:deck inMode:0];
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                           inMode:(NSInteger)mode {
    self = [super init];
    
    if (self) {
        for (int i=0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        if (mode >= 0) {
            self.gameMode = mode + 1;
        } else {
            self = nil;
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 14;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 7;

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    self.lastActionResult = nil;
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            [self.lastActionResult addObject:[NSNumber numberWithInt:0]];
            
            // match against other chosen cards
            NSMutableArray *cardsToMatch = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [cardsToMatch addObject:otherCard];
                    
                    if (cardsToMatch.count == self.gameMode) {
                        int matchScore = [card match:cardsToMatch];
                        [self.lastActionResult addObject:card];
                        [self.lastActionResult addObjectsFromArray:cardsToMatch];
                        
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            self.lastActionResult[0] = [NSNumber numberWithInt:matchScore * MATCH_BONUS];
                            for (Card *matchedCard in cardsToMatch) {
                                matchedCard.matched = YES;
                            }
                            card.matched = YES;
                            
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            self.lastActionResult[0] = [NSNumber numberWithInt:-MISMATCH_PENALTY];
                            for (Card *mismatchedCard in cardsToMatch) {
                                mismatchedCard.chosen = NO;
                            }
                        }
                        break;
                    }
                }
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
