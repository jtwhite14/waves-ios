//
//  CredentialStore.m
//  concierge-ios
//
//  Created by Charlie White on 12/11/14.
//  Copyright (c) 2014 Charlie White. All rights reserved.
//

#import "CredentialStore.h"
#import "SSKeychain.h"


#define SERVICE_NAME @"Charlie-AuthClient"
#define AUTH_TOKEN_KEY @"auth_token"
#define USER_ID @"user_id"

@implementation CredentialStore


+ (instancetype)sharedStore {
    static CredentialStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[CredentialStore alloc] init];
        
    });
    
    return _sharedStore;
}

-(void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"current-user-changed" object:self];
}

- (NSString *)authToken {
    return [self secureValueForKey:AUTH_TOKEN_KEY];
}

- (void)setAuthToken:(NSString *)authToken {
    [SSKeychain setAccessibilityType:kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly];
    [self setSecureValue:authToken forKey:AUTH_TOKEN_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"token-changed" object:self];
}

- (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
}

- (void)setUserID:(NSString *)userID
{
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLoggedIn {
    return [self authToken] != nil && [self userID] != nil;
}

-(void)logout {
    [self setAuthToken:nil];
    [self setUserID:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"user-logged-out" object:self];
}

- (NSString *)secureValueForKey:(NSString *)key {
    NSError *error = nil;
    NSString *result = [SSKeychain passwordForService:SERVICE_NAME account:key error:&error];
    
    if ([error code] == errSecItemNotFound) {
        NSLog(@"Password not found");
    } else if (error != nil) {
        NSLog(@"Some other error occurred: %@", [error localizedDescription]);
    }
    
    return result;
}

- (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value) {
        [SSKeychain setPassword:value
                     forService:SERVICE_NAME
                        account:key];
    } else {
        [SSKeychain deletePasswordForService:SERVICE_NAME account:key];
    }
}


@end
