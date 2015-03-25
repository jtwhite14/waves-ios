//
//  WavesErrorClass.h
//  waves-ios
//
//  Created by Charlie White on 1/23/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface WavesErrorClass : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *code;

@end
