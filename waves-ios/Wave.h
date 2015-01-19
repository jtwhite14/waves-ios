//
//  Wave.h
//  waves-ios
//
//  Created by Charlie White on 1/7/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "Buoy.h"
#import "Session.h"

@interface Wave : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, copy) NSString *titlePhotoUrl;
@property (nonatomic, copy) NSString *mapPhotoUrl;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) Buoy *buoy;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSNumber *sessionsCount;
@property (nonatomic, copy) NSArray *sessions;


+ (void) getWaves:(void (^)(NSArray *))completion;
+ (void) getClosestWaves:(NSDictionary *)params withCompletion:(void (^)(NSArray *))completion;

+ (void) createWave:(NSDictionary *)params withCompletion:(void (^)(Wave *))completion;

@end
