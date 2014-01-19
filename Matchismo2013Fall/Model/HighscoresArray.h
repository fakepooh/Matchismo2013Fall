//
//  HighscoresArray.h
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 18.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighscoreDictionary.h"

@interface HighscoresArray : NSObject
// use ONLY addObject: method to add records!!!
- (void)addObject:(HighscoreDictionary *)anObject;

@property (nonatomic, strong) NSMutableArray *arrayOfDictionaries;
@property (nonatomic, strong, readonly) NSArray *arrayOfHighscoreDictionaries;

- (void)orderByScore;
- (void)orderByDuration;
- (void)orderChronologically;

@end
