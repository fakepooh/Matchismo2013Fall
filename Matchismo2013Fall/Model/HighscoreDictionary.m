//
//  HighscoreDictionary.m
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 18.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "HighscoreDictionary.h"

@implementation HighscoreDictionary

- (NSMutableDictionary *)dictionary {
	return _dictionary ? _dictionary : (_dictionary = [[NSMutableDictionary alloc] init]);
}

NSString *const HighscoresKeyGameId = @"gameId";
NSString *const HighscoresKeyScore = @"score";
NSString *const HighscoresKeyStartTime = @"startTime";
NSString *const HighscoresKeyEndTime = @"endTime";
NSString *const HighscoresKeyDuration = @"duration";

- (void)setGameId:(NSInteger)gameId {
	[self.dictionary setObject:[NSNumber numberWithInteger:gameId] forKey:HighscoresKeyGameId];
}

- (NSInteger)gameId {
	return [[self.dictionary objectForKey:HighscoresKeyGameId] integerValue];
}

- (void)setScore:(NSInteger)score {
	[self.dictionary setObject:[NSNumber numberWithInteger:score] forKey:HighscoresKeyScore];
}

- (NSInteger)score {
	return [[self.dictionary objectForKey:HighscoresKeyScore] integerValue];
}

- (void)setStartTime:(NSDate *)startTime {
	[self.dictionary setObject:startTime forKey:HighscoresKeyStartTime];
}

- (NSDate *)startTime {
	return [self.dictionary objectForKey:HighscoresKeyStartTime];
}

- (void)setEndTime:(NSDate *)endTime {
	if (endTime) {
		[self.dictionary setObject:endTime forKey:HighscoresKeyEndTime];
		[self.dictionary setObject:[NSNumber numberWithInt:abs([self.endTime timeIntervalSinceDate:self.startTime])]
							forKey:HighscoresKeyDuration];
	} else
		[self.dictionary removeObjectForKey:HighscoresKeyEndTime];
}

- (NSDate *)endTime {
	return [self.dictionary objectForKey:HighscoresKeyEndTime];
}

- (NSUInteger)duration {
	return [[self.dictionary objectForKey:HighscoresKeyDuration] integerValue];
}

- (BOOL)isEqual:(id)object {
	BOOL result;
	
	if ([object isKindOfClass:[HighscoreDictionary class]]) {
		HighscoreDictionary *record = object;
		result = [self.startTime isEqualToDate:record.startTime];
	} else {
		result = [super isEqual:object];
	}
	
	return result;
}

@end
