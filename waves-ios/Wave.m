//
//  Wave.m
//  waves-ios
//
//  Created by Charlie White on 1/7/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "Wave.h"
#import "WavesAPIClient.h"
#import <Overcoat/Overcoat.h>
#import <Overcoat/PromiseKit+Overcoat.h>

@implementation Wave

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"slug": @"slug",
             @"buoy": @"buoy",
             @"titlePhotoUrl" : @"title_photo_url",
             @"mapPhotoUrl" : @"map_photo_url",
             @"sessions": @"sessions",
             @"latitude": @"latitude",
             @"longitude": @"longitude",
             @"distance" : @"distance",
             @"sessionsCount" : @"sessions_count"
            };
}

+ (NSValueTransformer *)buoyJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Buoy.class];
}

+ (NSValueTransformer *)sessionsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Session.class];
}

+ (void) getWaves:(void (^)(NSArray *))completion {
    [[WavesAPIClient sharedClient] GET:@"waves" parameters:nil].then( ^ (OVCResponse *response) {
        if (completion) {
             completion(response.result);
        }
    });
}


+ (void) getClosestWaves:(NSDictionary *)params withCompletion:(void (^)(NSArray *))completion {
    [[WavesAPIClient sharedClient] GET:@"waves" parameters:params].then( ^ (OVCResponse *response) {
        if (completion) {
            completion(response.result);
        }
    });
}



+ (void) createWave:(NSDictionary *)params withCompletion:(void (^)(Wave *))completion {
    [[WavesAPIClient sharedClient] POST:@"waves" parameters:params].then( ^ (OVCResponse *response) {
        if (completion) {
            completion(response.result);
        }
    });
}

@end