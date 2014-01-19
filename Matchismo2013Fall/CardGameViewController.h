//
//  CardGameViewController.h
//  Matchismo2013Fall
//
//  Created by pooh on 11/18/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardGameViewController : UIViewController
/*! 0 - Playing card game, 1 - Set game
 */
@property (nonatomic) NSInteger gameMode;
extern NSString *const HighscoresUserDefaultsKey;
@end
