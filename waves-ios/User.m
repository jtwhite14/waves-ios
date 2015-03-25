//
//  User.m
//  concierge-ios
//
//  Created by Charlie White on 12/11/14.
//  Copyright (c) 2014 Charlie White. All rights reserved.
//

#import "User.h"
#import "WavesAPIClient.h"
#import "CredentialStore.h"
#import <Overcoat/Overcoat.h>
#import <Overcoat/PromiseKit+Overcoat.h>

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"name": @"name",
             @"authToken": @"authentication_token",
             @"avatarUrl": @"avatar_url",
             @"waves": @"waves",
             @"sessions": @"sessions",
            };
}

+ (NSValueTransformer *)wavesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Wave.class];
}

+ (NSValueTransformer *)sessionsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:Session.class];
}


+ (void)createCurrentUser:(NSDictionary *)params withImage:(UIImage *)image withCompletion:(void (^)(User *, NSError *))completion {
    [[WavesAPIClient sharedClient] POST:@"registrations" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
            [formData appendPartWithFileData:imageData name:@"registration[avatar]" fileName:@"avatar.jpeg" mimeType:@"image/jpeg"];

        }}].then( ^ (OVCResponse *response) {
    User *user = response.result;
    [[CredentialStore sharedStore] setAuthToken:user.authToken];
    [[CredentialStore sharedStore] setUserID:user.identifier];
    [[CredentialStore sharedStore] setCurrentUser:user];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"user-created" object:self];
    if (completion) {
        completion(user, nil);
    }
    }).catch(^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    });
}

- (void)updateUser:(NSDictionary *)params withImage:(UIImage *)image withCompletion:(void (^)(User *user))completion{
    [[WavesAPIClient sharedClient] POST:@"users" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
            [formData appendPartWithFileData:imageData name:@"user[avatar]" fileName:@"avatar.jpeg" mimeType:@"image/jpeg"];
        }}].then( ^ (OVCResponse *response) {
        User *user = response.result;
        [[CredentialStore sharedStore] setCurrentUser:user];
        if (completion) {
            completion(user);
        }
    });
}

+ (void)login:(NSDictionary *)params withCompletion:(void (^)(User *, NSError *))completion {
    [[WavesAPIClient sharedClient] POST:@"logins" parameters:params].then( ^ (OVCResponse *response) {
        User *user = response.result;
        [[CredentialStore sharedStore] setAuthToken:user.authToken];
        [[CredentialStore sharedStore] setUserID:user.identifier];
        [[CredentialStore sharedStore] setCurrentUser:user];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user-logged-in" object:self];
        if (completion) {
            completion(user, nil);
        }
    }).catch(^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    });
}

+ (void)getCurrentUserWithCompletion:(void (^)(User *))completion {
    [[WavesAPIClient sharedClient] GET:@"users/me" parameters:nil].then( ^ (OVCResponse *response) {
        User *user = response.result;
        [[CredentialStore sharedStore] setCurrentUser:user];
        if (completion) {
            completion(user);
        }
    });
}






@end
