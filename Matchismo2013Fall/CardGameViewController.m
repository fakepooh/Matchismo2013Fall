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
#include "HighscoresArray.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *actionsHistory;
@property (nonatomic) BOOL gameStarted;
@property (strong, nonatomic) HighscoreDictionary *highscoreRecord;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActionLable;
@end

@implementation CardGameViewController

NSString *const HighscoresUserDefaultsKey = @"Highscores";
NSString *const SettingsUserDefaultsKey = @"Settings";

- (HighscoreDictionary *)highscoreRecord {
	if (!_highscoreRecord) {
		_highscoreRecord = [[HighscoreDictionary alloc] init];
	}
	return _highscoreRecord;
}

- (void)setGameMode:(NSInteger)gameMode {
	_gameMode = gameMode;
	[self updateUI];
}

- (CardMatchingGame *)game {
    if (!_game)
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[self createDeck]
													 inMode:self.gameMode];
    return _game;
}

- (NSMutableArray *)actionsHistory {
    if (!_actionsHistory)
        _actionsHistory = [[NSMutableArray alloc] init];
    
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
	
	// Playing card game is started with this event (if it's first one after game finish)
	if (!self.gameStarted && !self.gameMode) {
		self.gameStarted = YES;
		self.highscoreRecord.startTime = [NSDate date];
		self.highscoreRecord.gameId = self.gameMode;
	}
	self.highscoreRecord.score = self.game.score;
}

- (void)updateUI {
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
        if (card.isChosen && !card.isMatched) {
            [chosenCards addObject:card];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
	NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
    if (self.game.lastActionResult.count > 1) {
        if ([self.game.lastActionResult[0] intValue] > 0) {
            // cards were matched
            NSRange range = {1, self.game.lastActionResult.count - 1};
			attributedText = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
			[attributedText appendAttributedString:[self describeCardsArray:[self.game.lastActionResult subarrayWithRange:range]]];
			[attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points!", [self.game.lastActionResult[0] intValue]]]];
			
        } else if ([self.game.lastActionResult[0] intValue] < 0) {
            // cards were mismatched
            NSRange range = {1, self.game.lastActionResult.count - 1};
			attributedText = [[self describeCardsArray:[self.game.lastActionResult subarrayWithRange:range]] mutableCopy];
			[attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d points penalty!", [self.game.lastActionResult[0] intValue]]]];
			
        }
    } else {
        // match was not performed
        if (chosenCards.count > 0) {
            attributedText = [[self describeCardsArray:chosenCards] mutableCopy];
        }
    }
	
	if (attributedText) {
		self.lastActionLable.attributedText = attributedText;
		
		if (![attributedText.string isEqualToString:@""]) {
			[self.actionsHistory addObject:attributedText];
		}
	}
}

- (NSAttributedString *)describeCardsArray:(NSArray *)cards {
	return nil;
}

- (NSAttributedString *)titleForCard:(Card *)card {
    return [[NSAttributedString alloc] initWithString:card.isChosen ? card.contents : @""];
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (IBAction)touchDealButton {
    self.game = nil;
    self.actionsHistory = nil;
    [self updateUI];
    
	// Any game is finished with this event
	if (self.gameStarted) {
		self.highscoreRecord.endTime = [NSDate date];
		HighscoresArray *highscoresArray = [self getHighscores];
		[highscoresArray addObject:self.highscoreRecord];
		[self setHighscores:highscoresArray];
		self.gameStarted = NO;
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[SettingsSingleton sharedSettingsSingleton].settings.settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SettingsUserDefaultsKey] mutableCopy];
	// Any game can be resumed with this event (except the very first one). If gameStarted is YES reload HighscoresArray and look through it with indexOfObject:, remove the result from array and continue
	// Set game is started with this event (if it's the very first one)
	if (self.gameStarted) {
		HighscoresArray *highscoresArray = [self getHighscores];
		[highscoresArray.arrayOfDictionaries removeObjectAtIndex:[highscoresArray.arrayOfHighscoreDictionaries indexOfObject:self.highscoreRecord]];
		[self setHighscores:highscoresArray];
		self.highscoreRecord.endTime = nil;
	} else if (self.gameMode == 1) {
		self.gameStarted = YES;
		self.highscoreRecord.startTime = [NSDate date];
		self.highscoreRecord.gameId = self.gameMode;
		self.highscoreRecord.score = 0;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	// Any game is either paused or finished with this event (cannot predict)
	// Leave the gameStarted at YES
	if (self.gameStarted) {
		self.highscoreRecord.endTime = [NSDate date];
		HighscoresArray *highscoresArray = [self getHighscores];
		[highscoresArray addObject:self.highscoreRecord];
		[self setHighscores:highscoresArray];
	}
}

- (HighscoresArray *)getHighscores {
	HighscoresArray *highscoresArray = [[HighscoresArray alloc] init];
	
	NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:HighscoresUserDefaultsKey];
	if (array)
		highscoresArray.arrayOfDictionaries = [array mutableCopy];
	
	return highscoresArray;
}

- (void)setHighscores:(HighscoresArray *)table {
	[[NSUserDefaults standardUserDefaults] setObject:table.arrayOfDictionaries forKey:HighscoresUserDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
