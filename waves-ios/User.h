//
//  User.h
//  concierge-ios
//
//  Created by Charlie White on 12/11/14.
//  Copyright (c) 2014 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "Wave.h"
#import "Session.h"

@interface User : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSArray *waves;
@property (nonatomic, copy) NSArray *sessions;

+ (void)login:(NSDictionary *)params withCompletion:(void (^)(User *, NSError *))completion;
+ (void)getCurrentUserWithCompletion:(void (^)(User *))completion;
+ (void)createCurrentUser:(NSDictionary *)params withImage:(UIImage *)image withCompletion:(void (^)(User *, NSError *))completion;
- (void)updateUser:(NSDictionary *)params withImage:(UIImage *)image withCompletion:(void (^)(User *user))completion;
@end
