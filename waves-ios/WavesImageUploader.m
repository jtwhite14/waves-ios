//
//  WavesImageUploader.m
//  waves-ios
//
//  Created by Charlie White on 1/21/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "WavesImageUploader.h"

@implementation WavesImageUploader

+ (instancetype)sharedClient {
    static WavesImageUploader *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[WavesImageUploader alloc] init];
    });
    
    return _sharedClient;
}

-(void)uploadImage:(UIImage *)image withCompletion:(void (^)(NSDictionary *successResult))completion {
   
    NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
    
    
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    [cloudinary.config setValue:@"waves" forKey:@"cloud_name"];
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:nil];
    
    
    [uploader unsignedUpload:imageData uploadPreset:@"yj6oodb3" options:nil withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
        if (successResult) {
            if (completion) {
                completion(successResult);
            }
        }
        
    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
    }];

}


@end




