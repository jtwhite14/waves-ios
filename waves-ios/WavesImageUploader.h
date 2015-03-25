//
//  WavesImageUploader.h
//  waves-ios
//
//  Created by Charlie White on 1/21/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudinary/Cloudinary.h"
#import <UIKit/UIKit.h>

@interface WavesImageUploader : NSObject

@property (nonatomic, copy) CLCloudinary *cloudinary;

+ (instancetype)sharedClient;
-(void)uploadImage:(UIImage *)image withCompletion:(void (^)(NSDictionary *successResult))completion;
@end
