//
//  WavesFormatter.m
//  waves-ios
//
//  Created by Charlie White on 1/23/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "WavesFormatter.h"

@implementation WavesFormatter

+ (instancetype)sharedClient {
    static WavesFormatter *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[WavesFormatter alloc] init];
    });
    
    return _sharedClient;
}

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    return dateFormatter;
}


- (NSDateFormatter *)timeFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    return dateFormatter;
}


- (NSNumberFormatter *)numberFormatter {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.maximumFractionDigits = 1;
    return numberFormatter;
}


@end
