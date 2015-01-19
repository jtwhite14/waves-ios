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

@end
