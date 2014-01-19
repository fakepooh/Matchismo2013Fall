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
@end

@implementation HighscoresViewController

- (void)viewDidAppear:(BOOL)animated {
	self.highscoresTextView.text = @"";
	
	id array = [[NSUserDefaults standardUserDefaults] arrayForKey:HighscoresUserDefaultsKey];
	if (array) {
		HighscoresArray *highscoresArray = [[HighscoresArray alloc] init];
		highscoresArray.arrayOfDictionaries = array;
		
		[highscoresArray orderByScore];
		for (HighscoreDictionary *record in highscoresArray.arrayOfHighscoreDictionaries) {
			[[self.highscoresTextView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:record.gameId ? @"Set game: " : @"Playing card game: "]];
			[[self.highscoresTextView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d points! ", record.score]]];
			[[self.highscoresTextView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Game started at %@ and lasted for %d seconds.\n", [NSDateFormatter localizedStringFromDate:record.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle], record.duration]]];
		}
		
		HighscoreDictionary *record = highscoresArray.arrayOfHighscoreDictionaries[0];
		NSRange range = [self.highscoresTextView.text rangeOfString:[NSString stringWithFormat:@"%d", record.score]];
		[self.highscoresTextView.textStorage addAttribute:NSForegroundColorAttributeName
													value:[UIColor redColor]
													range:range];
		
		[highscoresArray orderByDuration];
		record = highscoresArray.arrayOfHighscoreDictionaries[0];
		range = [self.highscoresTextView.text rangeOfString:[NSString stringWithFormat:@"%d seconds", record.duration]];
		[self.highscoresTextView.textStorage addAttribute:NSForegroundColorAttributeName
													value:[UIColor redColor]
													range:range];
	}
}

- (IBAction)clearHighscores {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:HighscoresUserDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self viewDidAppear:NO];
}

@end
