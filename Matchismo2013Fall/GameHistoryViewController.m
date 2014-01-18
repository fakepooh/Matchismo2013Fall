//
//  GameHistoryViewController.m
//  Matchismo2013Fall
//
//  Created by pooh on 1/11/14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *gameHistoryTextView;
@end

@implementation GameHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
	self.gameHistoryTextView.text = @"";
	for (id string in self.gameHistoryToShow) {
		if ([string isKindOfClass:[NSAttributedString class]]) {
			[self.gameHistoryTextView.textStorage appendAttributedString:string];
			[self.gameHistoryTextView.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
		}
	}
}

@end
