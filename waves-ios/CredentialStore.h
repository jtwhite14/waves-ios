//
//  CredentialStore.h
//  concierge-ios
//
//  Created by Charlie White on 12/11/14.
//  Copyright (c) 2014 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface CredentialStore : NSObject

@property (nonatomic, copy) User *currentUser;

- (void)setAuthToken:(NSString *)authToken;
- (BOOL)isLoggedIn;
- (NSString *)authToken;
- (void)setUserID:(NSString *)userID;
- (NSString *)userID;
-(void)logout;

+ (instancetype)sharedStore;
- (void)listenForUserChanges;

@end
