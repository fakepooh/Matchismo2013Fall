//
//  HighscoresArray.m
//  Matchismo2013Fall
//
//  Created by Aliaksandr Palei on 18.01.14.
//  Copyright (c) 2014 Alex Palei. All rights reserved.
//

#import "HighscoresArray.h"

@implementation HighscoresArray

- (NSMutableArray *)arrayOfDictionaries {
	if (!_arrayOfDictionaries) {
		_arrayOfDictionaries = [[NSMutableArray alloc] init];
	}
	
	return  _arrayOfDictionaries;
}

- (NSArray *)arrayOfHighscoreDictionaries {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.arrayOfDictionaries.count];
	
	for (NSMutableDictionary *dictionary in self.arrayOfDictionaries) {
		HighscoreDictionary *record = [[HighscoreDictionary alloc] init];
		record.dictionary = dictionary;
		[array addObject:record];
	}
	
	return array;
}

- (void)addObject:(HighscoreDictionary *)anObject {
	if ([anObject isKindOfClass:[HighscoreDictionary class]])
		[self.arrayOfDictionaries addObject:anObject.dictionary];
	else
		[NSException raise:NSInvalidArgumentException
					format:@"Only HighscoreDictionary class instances allowed in HighscoresArray class!"];
}

- (void)orderByScore {
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:HighscoresKeyScore ascending:NO];
	self.arrayOfDictionaries = [[self.arrayOfDictionaries sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
}

- (void)orderByDuration {
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:HighscoresKeyDuration ascending:YES];
	self.arrayOfDictionaries = [[self.arrayOfDictionaries sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
}

- (void)orderChronologically {
	
}

@end
