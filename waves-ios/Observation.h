//
//  Observation.h
//  waves-ios
//
//  Created by Charlie White on 1/7/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface Observation : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSDate *timestamp;
@property (nonatomic, copy) NSNumber *waveHeight;
@property (nonatomic, copy) NSNumber *swellHeight;
@property (nonatomic, copy) NSNumber *swellPeriod;
@property (nonatomic, copy) NSNumber *windWaveHeight;
@property (nonatomic, copy) NSNumber *windWavePeriod;
@property (nonatomic, copy) NSString *swellDirection;
@property (nonatomic, copy) NSString *steepness;
@property (nonatomic, copy) NSNumber *averageWavePeriod;
@property (nonatomic, copy) NSNumber *meanWaveDirection;


@property (nonatomic, copy) NSNumber *windSpeed;
@property (nonatomic, copy) NSNumber *windGusts;
@property (nonatomic, copy) NSString *windDirection;
@property (nonatomic, copy) NSNumber *meanWindDirection;
@property (nonatomic, copy) NSNumber *airTemp;
@property (nonatomic, copy) NSNumber *waterTemp;
@property (nonatomic, copy) NSDate *logTideTimestamp;
@property (nonatomic, copy) NSNumber *logTideValue;
@property (nonatomic, copy) NSNumber *firstLowValue;
@property (nonatomic, copy) NSDate *firstLowTimestamp;
@property (nonatomic, copy) NSNumber *secondLowValue;
@property (nonatomic, copy) NSDate *secondLowTimestamp;
@property (nonatomic, copy) NSNumber *firstHighValue;
@property (nonatomic, copy) NSDate *firstHighTimestamp;
@property (nonatomic, copy) NSNumber *secondHighValue;
@property (nonatomic, copy) NSDate *secondHighTimestamp;

@end