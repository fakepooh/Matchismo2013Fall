//
//  HighscoreDictionary.h
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 18.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighscoreDictionary : NSObject
// use ONLY these properties to define highscore record!!!
@property (nonatomic) NSInteger gameId;
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, readonly) NSUInteger duration;

extern NSString *const HighscoresKeyGameId;
extern NSString *const HighscoresKeyScore;
extern NSString *const HighscoresKeyStartTime;
extern NSString *const HighscoresKeyEndTime;
extern NSString *const HighscoresKeyDuration;

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end
