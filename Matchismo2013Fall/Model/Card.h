//
//  Card.h
//  Matchismo2013Fall
//
//  Created by pooh on 11/19/13.
//  Copyright (c) 2013 Alex Palei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsSingleton.h"

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
