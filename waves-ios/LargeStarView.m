//
//  LargeStarView.m
//  waves-ios
//
//  Created by Charlie White on 1/9/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "LargeStarView.h"

@implementation LargeStarView


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImage *dot, *star;
        dot = [UIImage imageNamed:@"edit-star-grey"];
        star = [UIImage imageNamed:@"edit-star-blue"];
        self.imagesRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                                  emptyImage:dot
                                                                  solidImage:star
                                                                andMaxRating:5];
        
        [self.imagesRatingControl setStarSpacing:10];
        [self.imagesRatingControl setStarWidthAndHeight:28];
        
         LargeStarView __weak *weakself = self;
        
        // Define block to handle events
        self.imagesRatingControl.editingChangedBlock = ^(NSUInteger rating)
        {
            weakself.currentRating  = rating;
            [weakself.delegate ratingUpdated:rating];
        };
        
        self.imagesRatingControl.editingDidEndBlock = ^(NSUInteger rating)
        {
            weakself.currentRating = rating;
            [weakself.delegate ratingUpdated:rating];
        };
        
        [self addSubview:self.imagesRatingControl];
        
    }
    return self;
}

-(void) setStarRating:(int)rating {
    [self.imagesRatingControl setRating:rating];
}

@end
