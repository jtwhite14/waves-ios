//
//  Session.m
//  waves-ios
//
//  Created by Charlie White on 1/7/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "Session.h"
#import "WavesAPIClient.h"
#import <Overcoat/Overcoat.h>
#import <Overcoat/PromiseKit+Overcoat.h>

@implementation Session

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier": @"id",
             @"notes": @"notes",
             @"rating": @"rating",
             @"timestamp": @"timestamp",
             @"photoUrl": @"photo_url",
             @"observation": @"observation",
             };
}

+ (NSValueTransformer *)observationJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Observation.class];
}

+ (NSValueTransformer *)timestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

#pragma mark - MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"Session";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{};
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"identifier"];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey {
    return @{
             @"observation": [Observation class],
             @"wave": [Wave class]
             };
}

+ (void) getSessionsForWave:(NSString *)waveIdentifier completion:(void (^)(NSArray *))completion {
    [[WavesAPIClient sharedClient] GET:[NSString stringWithFormat:@"waves/%@/sessions", waveIdentifier] parameters:nil].then( ^ (OVCResponse *response) {
        if (completion) {
            completion(response.result);
        }
    });
}

+ (void)createSession:(NSDictionary *)params withCompletion:(void (^)(Session *))completion {
    [[WavesAPIClient sharedClient] POST:@"sessions" parameters:params].then( ^ (OVCResponse *response) {
        if (completion) {
            completion(response.result);
        }
    });
}

+ (void)uploadImageForSession:(UIImage *)image withSessionID:(NSString *)sessionID withCompletion:(void (^)(Session *))completion {
    
    [[WavesAPIClient sharedClient] POST:[NSString stringWithFormat:@"sessions/%@/upload", sessionID] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
        [formData appendPartWithFileData:imageData name:@"session[session_photo]" fileName:@"session_photo.jpeg" mimeType:@"image/jpeg"];
    }].then( ^ (OVCResponse *response) {
        Session *session = response.result;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"session-photo-uploaded" object:nil userInfo:@{ @"identifer" : session.identifier }];
        if (completion) {
            completion(session);
        }
    });
}

+ (void)uploadImage:(NSDictionary *)params withSessionID:(NSString *)sessionID withCompletion:(void (^)(Session *))completion {

    NSDictionary *newParams = @{ @"session_photo" : params };
    
    [[WavesAPIClient sharedClient] POST:[NSString stringWithFormat:@"sessions/%@/upload", sessionID] parameters:newParams].then( ^ (OVCResponse *response) {
        if (completion) {
            completion(response.result);
        }
    });
}


+ (void)finalizeSession:(NSDictionary *)params withSessionID:(NSString *)sessionID withCompletion:(void (^)(Session *))completion {
    [[WavesAPIClient sharedClient] PUT:[NSString stringWithFormat:@"sessions/%@", sessionID] parameters:params].then( ^ (OVCResponse *response) {
        if (completion) {
            completion(response.result);
        }
    });
}

+ (void) destroySession:(NSString*)identifier WithCompletion:(void (^)(BOOL))completion; {
    [[WavesAPIClient sharedClient] DELETE:[NSString stringWithFormat:@"sessions/%@", identifier] parameters:nil].then(^ (OVCResponse *response) {
        if (completion) {
            completion(YES);
        }
    });
}

@end
