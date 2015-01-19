//
//  StarView.m
//  waves-ios
//
//  Created by Charlie White on 1/8/15.
//  Copyright (c) 2015 Charlie White. All rights reserved.
//

#import "StarView.h"


@implementation StarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImage *dot, *star;
        dot = [UIImage imageNamed:@"star-halfsize-grey"];
        star = [UIImage imageNamed:@"star-halfsize-blue"];
        self.imagesRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                                              emptyImage:dot
                                                                              solidImage:star
                                                                            andMaxRating:5];
        
        [self.imagesRatingControl setStarSpacing:2];
        [self.imagesRatingControl setStarWidthAndHeight:16];
        
        [self addSubview:self.imagesRatingControl];

    }
    return self;
}

-(void) setStarRating:(int)rating {
    [self.imagesRatingControl setRating:rating];
}

@end
