//
//  CardGameViewController.m
//  Matchismo2013Fall
//
//  Created by pooh on 11/18/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameHistoryViewController.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *actionsHistory;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLable;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[self createDeck]];
    return _game;
}

- (NSMutableArray *)actionsHistory {
    if (!_actionsHistory)
        _actionsHistory = @[@""].mutableCopy;
    
    return _actionsHistory;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Show Game History"]) {
        if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
            GameHistoryViewController *ghvc = (GameHistoryViewController *)segue.destinationViewController;
            ghvc.gameHistoryToShow = self.actionsHistory;
        }
    }
}

- (Deck *)createDeck {
    return nil;
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
    
    self.lastActionLable.alpha = 1;
    
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
    self.actionsHistory = nil;
    [self updateUI];
    self.game = nil;
}

@end
