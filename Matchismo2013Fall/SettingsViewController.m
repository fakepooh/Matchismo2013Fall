//
//  SettingsViewController.m
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 18.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"
#import "CardGameViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *costToChooseField;
@property (weak, nonatomic) IBOutlet UITextField *matchBonusField;
@property (weak, nonatomic) IBOutlet UITextField *mismatchPenaltyField;
@property (weak, nonatomic) IBOutlet UITextField *suitsMatchField;
@property (weak, nonatomic) IBOutlet UITextField *ranksMatch;
@property (weak, nonatomic) IBOutlet UITextField *setMatch;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldsCollection;

@property (strong, nonatomic) Settings *settings;
@end

@implementation SettingsViewController

- (Settings *)settings {
	if (!_settings)
		_settings = [[Settings alloc] init];
	return _settings;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	for (UITextField *textField in self.textFieldsCollection) {
		[textField setDelegate:self];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated {
	self.settings.costToChoose = [self.costToChooseField.text integerValue];
	self.settings.matchBonus = [self.matchBonusField.text integerValue];
	self.settings.mismatchPenalty = [self.mismatchPenaltyField.text integerValue];
	self.settings.suitsMatch = [self.suitsMatchField.text integerValue];
	self.settings.ranksMatch = [self.ranksMatch.text integerValue];
	self.settings.setMatch = [self.setMatch.text integerValue];
	
	[[NSUserDefaults standardUserDefaults] setObject:self.settings.settings.copy forKey:SettingsUserDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[super viewWillDisappear:animated];
}

- (void)updateUI {
	self.settings.settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SettingsUserDefaultsKey] mutableCopy];
	
	self.costToChooseField.text = [NSString stringWithFormat:@"%d", self.settings.costToChoose];
	self.matchBonusField.text = [NSString stringWithFormat:@"%d", self.settings.matchBonus];
	self.mismatchPenaltyField.text = [NSString stringWithFormat:@"%d", self.settings.mismatchPenalty];
	self.suitsMatchField.text = [NSString stringWithFormat:@"%d", self.settings.suitsMatch];
	self.ranksMatch.text = [NSString stringWithFormat:@"%d", self.settings.ranksMatch];
	self.setMatch.text = [NSString stringWithFormat:@"%d", self.settings.setMatch];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)resetToDefaults {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:SettingsUserDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self updateUI];
}

- (IBAction)settingChanged:(UITextField *)sender {
	if ((sender.text.integerValue > 0) || [sender.text isEqualToString:@"0"]) {
		// do nothing probably?
	} else {
		[sender becomeFirstResponder];
	}
}

@end
