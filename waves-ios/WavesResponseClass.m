//
//  WavesResponseClass.m
//  waves-ios
//
//  Created by Charlie White on 1/16/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "WavesResponseClass.h"

@implementation WavesResponseClass

+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary {
     return [[JSONDictionary allKeys] firstObject];
}

@end
