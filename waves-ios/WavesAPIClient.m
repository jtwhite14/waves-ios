//
//  ConciergeAPIClient.m
//  concierge-ios
//
//  Created by Charlie White on 10/22/14.
//  Copyright (c) 2014 Charlie White. All rights reserved.
//

#import "WavesAPIClient.h"
#import "User.h"
#import "Wave.h"
#import "Session.h"
#import "Buoy.h"
#import "Observation.h"
#import "CredentialStore.h"
#import "AppDelegate.h"
#import "WavesResponseClass.h"

NSString * const kConciergeBaseURL = @"https://secret-refuge-5780.herokuapp.com/api/v1";
//NSString * const kConciergeBaseURL = @"http://cwhite.local:3000/api/v1";

@implementation WavesAPIClient

+ (instancetype)sharedClient {
    static WavesAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *urlString = kConciergeBaseURL;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        _sharedClient = [[WavesAPIClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]
                         managedObjectContext:delegate.managedObjectContext sessionConfiguration:nil
                         ];
        
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)context sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super initWithBaseURL:url managedObjectContext:context sessionConfiguration:configuration];
    if (self) {

        [self setAuthTokenHeader];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenChanged:)
                                                     name:@"token-changed"
                                                   object:nil];
    }
    return self;
}

+ (Class)responseClass {
    return [WavesResponseClass class];
}

- (void)setAuthTokenHeader {
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    [self.requestSerializer setValue:authToken forHTTPHeaderField:@"authorization"];
}

- (void)tokenChanged:(NSNotification *)notification {
    [self setAuthTokenHeader];
}



#pragma mark - OVCHTTPSessionManager

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"logins": [User class],
             @"registrations": [User class],
             @"users": [User class],
             @"users/*": [User class],
             @"waves": [Wave class],
             @"waves/*": [Wave class],
             @"waves/*/sessions": [Session class],
             @"sessions": [Session class],
             @"sessions/*": [Session class],
             @"buoys": [Buoy class],
             @"buoys/*": [Buoy class],
             @"buoys/*/observations": [Observation class],
             @"buoys/*/observations/*": [Observation class],
            };
}

@end
