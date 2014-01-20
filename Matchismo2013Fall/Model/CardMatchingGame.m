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

//static const int MISMATCH_PENALTY = 2;
//static const int MATCH_BONUS = 4;
//static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    self.lastActionResult = nil;
	Settings *settings = [SettingsSingleton sharedSettingsSingleton].settings;
    
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
                            self.score += matchScore * settings.matchBonus;
                            self.lastActionResult[0] = [NSNumber numberWithInt:matchScore * settings.matchBonus];
                            for (Card *matchedCard in cardsToMatch) {
                                matchedCard.matched = YES;
                            }
                            card.matched = YES;
                            
                        } else {
                            self.score -= settings.mismatchPenalty;
                            self.lastActionResult[0] = [NSNumber numberWithInt:-settings.mismatchPenalty];
                            for (Card *mismatchedCard in cardsToMatch) {
                                mismatchedCard.chosen = NO;
                            }
                        }
                        break;
                    }
                }
            }
            
            self.score -= settings.costToChoose;
            card.chosen = YES;
        }
    }
}

@end
