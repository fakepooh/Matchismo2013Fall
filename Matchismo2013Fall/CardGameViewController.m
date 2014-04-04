//
//  CardGameViewController.m
//  Matchismo2013Fall
//
//  Created by pooh on 11/18/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "HighscoresArray.h"
#import "CardView.h"
#import "Grid.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) BOOL gameStarted;
@property (strong, nonatomic) HighscoreDictionary *highscoreRecord;

@property (weak, nonatomic) IBOutlet UIView *canvas;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
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
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cards.count
                                                  usingDeck:[self createDeck]
													 inMode:self.gameMode];
    return _game;
}

- (Deck *)createDeck {
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender {
//    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
//    [self.game chooseCardAtIndex:chosenButtonIndex];
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
//    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    
    for (CardView *cardView in self.cards) {
        NSUInteger cardIndex = [self.cards indexOfObject:cardView];
        Card *card = [self.game cardAtIndex:cardIndex];
//        [cardView setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
//        [cardView setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        if (card.isMatched)
            [cardView removeFromSuperview];
        
//        if (card.isChosen && !card.isMatched) {
//            [chosenCards addObject:card];
//        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
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
    [self initialDeal];
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

- (HighscoresArray *)getHighscores {
	HighscoresArray *highscoresArray = nil;
	
	NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:HighscoresUserDefaultsKey];
	if (array) {
        highscoresArray = [[HighscoresArray alloc] init];
		highscoresArray.arrayOfDictionaries = [array mutableCopy];
    }
	
	return highscoresArray;
}

- (void)setHighscores:(HighscoresArray *)table {
	[[NSUserDefaults standardUserDefaults] setObject:table.arrayOfDictionaries forKey:HighscoresUserDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)cards {
    if (!_cards)
        _cards = [[NSMutableArray alloc] init];
    return _cards;
}

#pragma mark - Initialization

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[SettingsSingleton sharedSettingsSingleton].settings.settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SettingsUserDefaultsKey] mutableCopy];
	// Any game can be resumed with this event (except the very first one). If gameStarted is YES reload HighscoresArray and look through it with indexOfObject:, remove the result from array and continue
	// Set game is started with this event (if it's the very first one)
	if (self.gameStarted) {
		HighscoresArray *highscoresArray = [self getHighscores];
        if (highscoresArray) {
            NSUInteger index = [highscoresArray.arrayOfHighscoreDictionaries indexOfObject:self.highscoreRecord];
            if (index != NSNotFound)
                [highscoresArray.arrayOfDictionaries removeObjectAtIndex:index];
            [self setHighscores:highscoresArray];
        }
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
        if (!highscoresArray)
            highscoresArray = [[HighscoresArray alloc] init];
		[highscoresArray addObject:self.highscoreRecord];
		[self setHighscores:highscoresArray];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialDeal];
}

- (void)initialDeal {
    Grid *grid = [[Grid alloc] init];
    grid.cellAspectRatio = 0.75;
    grid.size = self.canvas.bounds.size;
    grid.minimumNumberOfCells = 1;
    
    for (CardView* cardView in self.cards) {
        [cardView removeFromSuperview];
    }
    [self.cards removeAllObjects];
    
    for (NSUInteger row = 0; row < grid.rowCount; row ++) {
        for (NSUInteger column = 0; column < grid.columnCount; column ++) {
            CardView *cardView = [self generateCardViewWithFrame:[grid frameOfCellAtRow:row inColumn:column]];
            [self.canvas addSubview:cardView];
            [self.cards addObject:cardView];
            [cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView
                                                                                     action:@selector(pinch:)]];
            [cardView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:cardView
                                                                                     action:@selector(swipeOrTap:)]];
            [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:cardView
                                                                                     action:@selector(swipeOrTap:)]];
        }
    }
}

- (CardView *)generateCardViewWithFrame:(CGRect)frame {
    CardView *cardView = [[CardView alloc] initWithFrame:frame];
    
    return cardView;
}

@end
