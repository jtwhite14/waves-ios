//
//  Observation.m
//  waves-ios
//
//  Created by Charlie White on 1/7/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "Observation.h"
#import <Overcoat/Overcoat.h>
#import <Overcoat/PromiseKit+Overcoat.h>

@implementation Observation

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"timestamp": @"timestamp",
             @"waveHeight": @"wave_height",
             @"swellHeight": @"swell_height",
             @"swellPeriod": @"swell_period",
             @"windWaveHeight": @"wind_wave_height",
             @"windWavePeriod": @"wind_wave_period",
             @"swellDirection": @"swell_direction",
             @"steepness": @"steepness",
             @"averageWavePeriod": @"average_wave_period",
             @"meanWaveDirection": @"mean_wave_direction",
             @"windSpeed" : @"wind_speed",
             @"windGusts" : @"wind_gusts",
             @"windDirection" : @"wind_direction",
             @"meanWindDirection" : @"mean_wind_direction",
             @"airTemp" : @"air_temp",
             @"waterTemp" : @"water_temp",
             @"logTideTimestamp" : @"log_tide_timestamp",
             @"logTideValue" : @"log_tide_value",
             @"firstLowValue" : @"first_low_value",
             @"firstLowTimestamp" : @"first_low_timestamp",
             @"secondLowValue" : @"second_low_value",
             @"secondLowTimestamp" : @"second_low_timestamp",
             @"firstHighValue" : @"first_high_value",
             @"firstHighTimestamp" : @"first_high_timestamp",
             @"secondHighValue" : @"second_high_value",
             @"secondHighTimestamp" : @"second_high_timestamp"
             };
}

+ (NSValueTransformer *)timestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)logTideTimestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)firstLowTimestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)secondLowTimestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)firstHighTimestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)secondHighTimestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"Observation";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{};
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"identifier"];
}

@end
