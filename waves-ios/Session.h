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
#import <UIKit/UIKit.h>

@class Wave;

@interface Session : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSString *photoUrl;
@property (nonatomic, copy) NSDate *timestamp;
@property (nonatomic, copy) Observation *observation;
@property (nonatomic, copy) Wave *wave;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;


+ (void) destroySession:(NSString*)identifier WithCompletion:(void (^)(BOOL))completion;
+ (void) getSessionsForWave:(NSString *)waveIdentifier completion:(void (^)(NSArray *))completion;
+ (void) createSession:(NSDictionary *)params withCompletion:(void (^)(Session *))completion;
+ (void) uploadImageForSession:(UIImage *)image withSessionID:(NSString *)sessionID withCompletion:(void (^)(Session *))completion;
+ (void) finalizeSession:(NSDictionary *)params withSessionID:(NSString *)sessionID withCompletion:(void (^)(Session *))completion;
+ (void)uploadImage:(NSDictionary *)params withSessionID:(NSString *)sessionID withCompletion:(void (^)(Session *))completion;

@end
