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
#import "TRJSONResponseSerializerWithData.h"
#import "WavesErrorClass.h"

NSString * const kConciergeBaseURL = @"https://secret-refuge-5780.herokuapp.com/api/v1";
//NSString * const kConciergeBaseURL = @"http://localhost:3000/api/v1";

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
        //self.responseSerializer = [TRJSONResponseSerializerWithData serializer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenChanged:)
                                                     name:@"token-changed"
                                                   object:nil];
    }
    return self;
}

- (void)setupResponseSerializer {
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:[self.baseURL path]
                                                  modelClassesByPath:[[self class] modelClassesByResourcePath]];
    
    OVCURLMatcher *responseClassMatcher = nil;
    if ([[self class] responseClassesByResourcePath]) {
        // Check if all the classes used in responseClassesByResourcePath are
        // subclasses of OVCResponse
        [[[self class] responseClassesByResourcePath] enumerateKeysAndObjectsUsingBlock:^(NSString *path,
                                                                                          Class responseClass,
                                                                                          BOOL *stop) {
            NSParameterAssert([responseClass isSubclassOfClass:[OVCResponse class]]);
        }];
        
        responseClassMatcher = [[OVCURLMatcher alloc] initWithBasePath:[self.baseURL path]
                                                    modelClassesByPath:[[self class] responseClassesByResourcePath]];
    }
    self.responseSerializer = [TRJSONResponseSerializerWithData serializerWithURLMatcher:matcher
                                                           responseClassURLMatcher:responseClassMatcher
                                                              managedObjectContext:self.backgroundContext
                                                                     responseClass:[[self class] responseClass]
                                                                   errorModelClass:[[self class] errorModelClass]];
}

+ (Class)responseClass {
    return [WavesResponseClass class];
}

//+ (Class)errorModelClass {
//    return [WavesErrorClass class];
//}

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
