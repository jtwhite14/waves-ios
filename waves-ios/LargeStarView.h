//
//  LargeStarView.h
//  waves-ios
//
//  Created by Charlie White on 1/9/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "StarView.h"

@protocol StarViewProtocol

-(void)ratingUpdated:(NSUInteger)currentRating;

@end

@interface LargeStarView : UIView

@property (nonatomic, retain) AMRatingControl *imagesRatingControl;
@property (nonatomic) NSUInteger currentRating;
@property (nonatomic, assign) id<StarViewProtocol>  delegate;


-(void) setStarRating:(int)rating;

@end
