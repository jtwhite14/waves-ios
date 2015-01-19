//
//  Buoy.h
//  waves-ios
//
//  Created by Charlie White on 1/7/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "Observation.h"

@interface Buoy : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *buoyDescription;
@property (nonatomic, copy) NSString *stationId;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) Observation *currentObservation;


+ (void) getBuoys:(void (^)(NSArray *))completion;

@end
