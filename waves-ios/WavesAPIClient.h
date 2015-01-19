//
//  ConciergeAPIClient.h
//  concierge-ios
//
//  Created by Charlie White on 10/22/14.
//  Copyright (c) 2014 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Overcoat/PromiseKit+Overcoat.h>

@interface WavesAPIClient : OVCHTTPSessionManager

+ (instancetype)sharedClient;

@end
