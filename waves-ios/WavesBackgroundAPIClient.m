//
//  WavesBackgroundAPIClient.m
//  waves-ios
//
//  Created by Charlie White on 1/16/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "WavesBackgroundAPIClient.h"

@implementation WavesBackgroundAPIClient

- (id)initWithBaseURL:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)context sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url managedObjectContext:context sessionConfiguration:configuration];
    if (self) {
        
        self.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

@end
