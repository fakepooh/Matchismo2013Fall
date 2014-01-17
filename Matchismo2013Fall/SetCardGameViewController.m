//
//  SetCardGameViewController.m
//  Matchismo2013Fall
//
//  Created by pooh on 1/14/14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (void)viewDidLoad {
    self.gameMode = 1; //Set Game
}

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *)card {
	NSMutableAttributedString *title = nil;
	
	if ([card isMemberOfClass:[SetCard class]]) {
		SetCard *setCard = (SetCard *)card;
		
		// symbol & number
		NSString *stringTitle = @"";
		for (int i = 0; i < setCard.number; i++) {
			stringTitle = [stringTitle stringByAppendingString:setCard.symbol];
		}
		
		// color
		UIColor *color = [[self setCardColors] valueForKey:setCard.color];
		
		// shading
		NSNumber *stroke = @0; // default = solid
		if ([setCard.shading isEqualToString:@"striped"]) { // actually transparent
			color = [color colorWithAlphaComponent:0.5];
		} else if ([setCard.shading isEqualToString:@"open"]) {
			stroke = @3;
		}
		
		// defining attributes
		NSDictionary *attributes = @{NSForegroundColorAttributeName : color, NSStrokeWidthAttributeName : stroke, NSStrokeColorAttributeName : color};
		
		// creating attributed string
		title = [[NSMutableAttributedString alloc] initWithString:stringTitle attributes:attributes];
	}
	
    return title;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"notchosensetcardfront"]; // change it
}

- (NSDictionary *)setCardColors {
	return [NSDictionary dictionaryWithObjects:@[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]]
									   forKeys:[SetCard validColors]];
}

@end
