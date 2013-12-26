//
//  CardGameViewController.m
//  Matchismo2013Fall
//
//  Created by pooh on 11/18/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLable;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[self createDeck]
                                                     inMode:self.gameModeSegmentedControl.selectedSegmentIndex];
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI {
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
        if (card.isChosen && !card.isMatched) {
            [chosenCards addObject:card];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.gameModeSegmentedControl.enabled = NO;
    
    if (self.game.lastActionResult.count > 1) {
        if ([self.game.lastActionResult[0] intValue] > 0) {
            // cards were matched
            NSRange range = {1, self.game.lastActionResult.count - 1};
            self.lastActionLable.text = [NSString stringWithFormat:@"Matched %@ for %d points!", [[self.game.lastActionResult subarrayWithRange:range] componentsJoinedByString:@" "], [self.game.lastActionResult[0] intValue]];
        } else if ([self.game.lastActionResult[0] intValue] < 0) {
            // cards were mismatched
            NSRange range = {1, self.game.lastActionResult.count - 1};
            self.lastActionLable.text = [NSString stringWithFormat:@"%@ don't match! %d points penalty!", [[self.game.lastActionResult subarrayWithRange:range] componentsJoinedByString:@" "], [self.game.lastActionResult[0] intValue]];
        }
    } else {
        // match was not performed
        if (chosenCards.count > 0) {
            self.lastActionLable.text = [NSString stringWithFormat:@"%@", [chosenCards componentsJoinedByString:@" "]];
        } else {
            self.lastActionLable.text = @"";
        }
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (IBAction)touchDealButton {
    self.game = nil;
    [self updateUI];
    self.gameModeSegmentedControl.enabled = YES;
    self.game = nil;
}


@end
