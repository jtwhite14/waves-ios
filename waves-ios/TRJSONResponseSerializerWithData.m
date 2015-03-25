//
//  TRJSONResponseSerializerWithData.m
//  Triage-ios
//
//  Created by Charlie White on 10/18/13.
//  Copyright (c) 2013 Charlie White. All rights reserved.
//

#import "TRJSONResponseSerializerWithData.h"



@implementation TRJSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (*error != nil) {
            NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
            userInfo[JSONResponseSerializerWithDataKey] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *errorMessages = responseJSON[@"errors"];
            if (errorMessages && errorMessages.count) {
                userInfo[NSLocalizedDescriptionKey] = [errorMessages firstObject];
            }
            NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
            (*error) = newError;
        }
        
        return (nil);
    }
   
    return [super responseObjectForResponse:response data:data error:error];
}


@end
