//
//  Session.h
//  waves-ios
//
//  Created by Charlie White on 1/7/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "Wave.h"
#import "Observation.h"

@class Wave;
@class UIImage;

@interface Session : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, copy) NSDate *timestamp;
@property (nonatomic, copy) Observation *observation;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;


- (void) destroySessionWithCompletion:(void (^)(BOOL))completion;
+ (void) getSessionsForWave:(Wave *)wave completion:(void (^)(NSArray *))completion;
+ (void) uploadImageForSession:(UIImage *)image withCompletion:(void (^)(Session *))completion;
+ (void) finalizeSession:(NSDictionary *)params withSessionID:(NSString *)sessionID withCompletion:(void (^)(Session *))completion;

@end
