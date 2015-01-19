//
//  StarView.h
//  waves-ios
//
//  Created by Charlie White on 1/8/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMRatingControl/AMRatingControl.h>

@interface StarView : UIView

@property (nonatomic, retain) AMRatingControl *imagesRatingControl;

-(void) setStarRating:(int)rating;

@end
