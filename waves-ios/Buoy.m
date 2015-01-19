//
//  Buoy.m
//  waves-ios
//
//  Created by Charlie White on 1/7/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "Buoy.h"
#import "WavesBackgroundAPIClient.h"
#import <Overcoat/Overcoat.h>
#import <Overcoat/PromiseKit+Overcoat.h>

@implementation Buoy

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"title": @"title",
             @"buoyDescription": @"description",
             @"longitude": @"longitude",
             @"latitude": @"latitude",
             @"stationId": @"station_id",
             @"currentObservation": @"current_observation",
             };
}

+ (NSValueTransformer *)currentObservationJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Observation.class];
}


+ (void) getBuoys:(void (^)(NSArray *))completion {
    [[WavesBackgroundAPIClient sharedClient] GET:@"buoys" parameters:nil].then( ^ (OVCResponse *response) {
        if (completion) {
            completion(response.result);
        }
    });
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"Buoy";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{};
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"identifier"];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey {
    return @{
             @"currentObservation": [Observation class],
            };
}


@end
