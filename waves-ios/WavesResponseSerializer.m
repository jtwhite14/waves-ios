//
//  WavesResponseSerializer.m
//  waves-ios
//
//  Created by Charlie White on 1/16/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "WavesResponseSerializer.h"

@implementation WavesResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSError *serializationError = nil;
    id JSONObject = [super responseObjectForResponse:response data:data error:&serializationError];
    
    return [super responseObjectForResponse:response data:data error:error];
}



@end
