//
//  LocationClient.h
//  waves-ios
//
//  Created by Charlie White on 1/14/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationClient : NSObject <CLLocationManagerDelegate>

@property (nonatomic, copy) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D currentLocation;

+ (instancetype)sharedClient;

@end
