//
//  HighscoresViewController.m
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 18.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "HighscoresViewController.h"
#import "HighscoresArray.h"
#import "CardGameViewController.h"

@interface HighscoresViewController ()
@property (weak, nonatomic) IBOutlet UITextView *highscoresTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortOrderControl;
@end

@implementation HighscoresViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.highscoresTextView.text = @"";
	
	id array = [[NSUserDefaults standardUserDefaults] arrayForKey:HighscoresUserDefaultsKey];
	if (array) {
		HighscoresArray *highscoresArray = [[HighscoresArray alloc] init];
		highscoresArray.arrayOfDictionaries = array;
		
		switch (self.sortOrderControl.selectedSegmentIndex) {
			case 0:
				//topScoreRange = [self orderAndGetTopScoreRange:highscoresArray];
				[highscoresArray orderByScore];
				break;
			case 1:
				[highscoresArray orderChronologically];
				break;
			case 2:
				//shortestGameRange = [self orderAndGetShortestRange:highscoresArray];
				[highscoresArray orderByDuration];
				break;
			default:
				break;
		}
		
		for (HighscoreDictionary *record in highscoresArray.arrayOfHighscoreDictionaries) {
			[[self.highscoresTextView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:record.gameId ? @"Set game: " : @"Playing card game: "]];
			[[self.highscoresTextView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d points! ", record.score]]];
			[[self.highscoresTextView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Game started at %@ and lasted for %d seconds.\n", [NSDateFormatter localizedStringFromDate:record.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle], record.duration]]];
		}
		
		NSRange shortestGameRange = [self orderAndGetShortestRange:highscoresArray];
		NSRange topScoreRange = [self orderAndGetTopScoreRange:highscoresArray];
		
		[self.highscoresTextView.textStorage addAttribute:NSForegroundColorAttributeName
													value:[UIColor redColor]
													range:topScoreRange];
		
		[self.highscoresTextView.textStorage addAttribute:NSForegroundColorAttributeName
													value:[UIColor redColor]
													range:shortestGameRange];
	}
}

- (NSRange)orderAndGetTopScoreRange:(HighscoresArray *)array {
	[array orderByScore];
	HighscoreDictionary *record = array.arrayOfHighscoreDictionaries[0];
	NSRange range = [self.highscoresTextView.text rangeOfString:[NSString stringWithFormat:@" %d points", record.score]];
	
	return range;
}

- (NSRange)orderAndGetShortestRange:(HighscoresArray *)array {
	[array orderByDuration];
	HighscoreDictionary *record = array.arrayOfHighscoreDictionaries[0];
	NSRange range = [self.highscoresTextView.text rangeOfString:[NSString stringWithFormat:@" %d seconds", record.duration]];
	
	return range;
}

- (IBAction)clearHighscores {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:HighscoresUserDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self viewDidAppear:NO];
}

- (IBAction)sortOrderChanged {
	[self viewDidAppear:NO];
}

@end
