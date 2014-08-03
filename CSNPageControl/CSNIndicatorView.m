//
//  CSNIndicatorView.m
//  CSNPageControlDemo
//
//  Created by griffin_stewie on 2014/07/24.
//  Copyright (c) 2014 cyan-stivy.net. All rights reserved.
//

#import "CSNIndicatorView.h"

@implementation CSNIndicatorView

- (void)setCurrentIndicatorImage:(UIImage *)currentIndicatorImage
{
    _currentIndicatorImage = currentIndicatorImage;
    self.highlightedImage = [currentIndicatorImage resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3) resizingMode:UIImageResizingModeStretch];
}

- (void)setIndicatorImage:(UIImage *)indicatorImage
{
    _indicatorImage = indicatorImage;
    self.image = [indicatorImage resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3) resizingMode:UIImageResizingModeStretch];
}

@end
