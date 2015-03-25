//
//  LocationClient.m
//  waves-ios
//
//  Created by Charlie White on 1/14/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "LocationClient.h"


@implementation LocationClient

@synthesize locationManager, currentLocation;

+ (instancetype)sharedClient {
    static LocationClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[LocationClient alloc] init];
    });
    
    return _sharedClient;
}

- (id) init {
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager requestWhenInUseAuthorization];

    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = manager.location.coordinate;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"location-updated" object:self];
}

-(BOOL)currentLocationIsValid {
    return (CLLocationCoordinate2DIsValid(self.currentLocation));
}

@end
