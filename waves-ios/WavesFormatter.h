//
//  WavesFormatter.h
//  waves-ios
//
//  Created by Charlie White on 1/23/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WavesFormatter : NSObject

+ (instancetype)sharedClient;

- (NSDateFormatter *)dateFormatter;
- (NSDateFormatter *)timeFormatter;
- (NSNumberFormatter *)numberFormatter;

@end
