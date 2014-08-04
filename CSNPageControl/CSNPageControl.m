//
//  CSNPageControl.m
//  CSNPageControlDemo
//
//  Created by griffin_stewie on 2014/07/18.
//  Copyright (c) 2014 cyan-stivy.net. All rights reserved.
//

#import "CSNPageControl.h"
#import "CSNIndicatorView.h"

UIKIT_STATIC_INLINE CGRect CSNCGRectHorizontalAlignmentCenter(CGRect baseRect, CGRect targetRect) {
    targetRect.origin.x = roundf((CGRectGetWidth(baseRect) - CGRectGetWidth(targetRect)) / 2);
    targetRect.origin.x += baseRect.origin.x;
    return targetRect;
}

UIKIT_STATIC_INLINE CGRect CSNCGRectVerticalAlignmentCenter(CGRect baseRect, CGRect targetRect) {
    targetRect.origin.y = roundf((CGRectGetHeight(baseRect) - CGRectGetHeight(targetRect)) / 2);
    targetRect.origin.y += baseRect.origin.y;
    return targetRect;
}

UIKIT_STATIC_INLINE CGRect CSNCGRectCenter(CGRect baseRect, CGRect targetRect) {
    targetRect = CSNCGRectHorizontalAlignmentCenter(baseRect, targetRect);
    targetRect = CSNCGRectVerticalAlignmentCenter(baseRect, targetRect);
    return targetRect;
}

static CGFloat kDotSize = 7.0f;
static CGFloat kSideMargin = 9.0f;
static CGFloat kExpandWidth = 20.0f;

typedef NS_ENUM(NSUInteger, CSNPageControlAnimationDirection) {
    CSNPageControlAnimationDirectionLeft,
    CSNPageControlAnimationDirectionRight,
};

UIColor *CSNRandomColor()
{
    CGFloat r = (arc4random() % 255) / 255.0;
    CGFloat g = (arc4random() % 255) / 255.0;
    CGFloat b = (arc4random() % 255) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@interface CSNPageControl ( )
@property (nonatomic, strong) UIView *indicatorBaseView;
@property (nonatomic, strong) NSMutableArray *indicators;
@property (nonatomic, strong) UIImage *currentIndicatorImage;
@property (nonatomic, strong) UIImage *defaultIndicatorImage;
@end


@implementation CSNPageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = 1;
    }

    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    if (_numberOfPages != numberOfPages) {
        _numberOfPages = numberOfPages;

        if (_currentIndicatorImage == nil) {
            self.currentIndicatorImage = [self dotImageWithSize:CGSizeMake(kDotSize, kDotSize) fillColor:[UIColor whiteColor]];
        }

        if (_defaultIndicatorImage == nil) {
            self.defaultIndicatorImage = [self dotImageWithSize:CGSizeMake(kDotSize, kDotSize) fillColor:[UIColor lightGrayColor]];
        }
        
        [self updatePageIndicatorWithPages:_numberOfPages];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [self setCurrentPage:currentPage animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated
{
    NSInteger page = _currentPage;
    if (_currentPage != currentPage) {
        if (0 <= currentPage && currentPage <= self.numberOfPages) {
            _currentPage = currentPage;
            [self updatePageIndicatorWithDiff:page - _currentPage animated:animated];
        }
    }
}

- (void)updateCurrentPageDisplay
{
    //TODO: Impl
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    //TODO: Impl
    return CGSizeZero;
}

- (UIImage *)dotImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor
{
    CGSize imageSize = size;
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);

    CGContextTranslateCTM(context, 0.0, imageSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context,
                                   fillColor.CGColor);
    CGContextAddArc(context, CGRectGetMidX(imageRect), CGRectGetMidY(imageRect), CGRectGetMidX(imageRect) - 0.5, 0, 2*M_PI, 0);
    CGContextFillPath(context);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.indicatorBaseView.frame;
    self.indicatorBaseView.frame = CSNCGRectCenter(self.bounds, frame);
}

#pragma mark - Internal

- (UIView *)indicatorBaseView
{
    if (_indicatorBaseView == nil) {
        _indicatorBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _indicatorBaseView.backgroundColor = [UIColor clearColor];
        _indicatorBaseView.userInteractionEnabled = NO;
    }
    
    return _indicatorBaseView;
}

- (CSNIndicatorView *)indicatorView
{
    CSNIndicatorView *view = [[CSNIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.defaultIndicatorImage.size.width, self.defaultIndicatorImage.size.height)];
    view.indicatorImage = self.defaultIndicatorImage;
    view.currentIndicatorImage = self.currentIndicatorImage;
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGSize)currentIndicatorSize
{
    CGSize size = [self defaultIndicatorSize];
    size.width += kExpandWidth;
    return size;
}

- (CGSize)defaultIndicatorSize
{
    return CGSizeMake(kDotSize, kDotSize);
}

- (CGRect)calculatedIndicatorBaseViewFrameWithNumberOfPages:(NSInteger)numberOfPages
{
    CGRect frame = CGRectZero;
    frame.size = [self currentIndicatorSize];
    frame.size.width += kSideMargin;
    for (NSInteger i = 0; i < numberOfPages - 1; i++) {
        frame.size.width += [self defaultIndicatorSize].width + kSideMargin;
    }
    frame.size.width -= kSideMargin;
    return frame;
}

- (void)modifyAsCurrentIndicatorShape:(CSNIndicatorView *)indicatorView direction:(CSNPageControlAnimationDirection)direction animated:(BOOL)animated
{
    if (indicatorView == nil) {
        return ;
    }

    indicatorView.highlighted = YES;
    
    void(^changeFrame)() = ^ {
        CGRect frame = indicatorView.frame;
        frame.size = [self currentIndicatorSize];
        if (direction == CSNPageControlAnimationDirectionLeft) {
            frame.origin.x -= kExpandWidth;
        }
        indicatorView.frame = frame;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:changeFrame completion:NULL];
    } else {
        changeFrame();
    }
}

- (void)modifyAsDeselctedIndicatorShape:(CSNIndicatorView *)indicatorView direction:(CSNPageControlAnimationDirection)direction animated:(BOOL)animated
{
    if (indicatorView == nil) {
        return ;
    }

    indicatorView.highlighted = NO;

    void(^changeFrame)() = ^ {
        CGRect frame = indicatorView.frame;
        frame.size = [self defaultIndicatorSize];
        if (direction == CSNPageControlAnimationDirectionRight) {
            frame.origin.x += kExpandWidth;
        }
        indicatorView.frame = frame;
    };

    if (animated) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:changeFrame completion:NULL];
    } else {
        changeFrame();
    }
}

- (void)updatePageIndicatorWithPages:(NSInteger)numberOfPages
{
    for (UIView *v in self.indicators) {
        [v removeFromSuperview];
    }
    self.indicators = nil;
    self.indicators = [NSMutableArray array];
    
    self.indicatorBaseView.frame = [self calculatedIndicatorBaseViewFrameWithNumberOfPages:numberOfPages];
    
    CSNIndicatorView *prevView = nil;
    for (NSUInteger i = 0; i < numberOfPages; i++) {
        CSNIndicatorView *view = [self indicatorView];
        if (i + 1 == self.currentPage) {
            CGRect f = CGRectZero;
            f.size = [self currentIndicatorSize];
            f.origin.x += CGRectGetMaxX(prevView.frame);
            view.frame = f;
            view.highlighted = YES;
        } else {
            CGRect f = CGRectZero;
            f.size = [self defaultIndicatorSize];
            f.origin.x += CGRectGetMaxX(prevView.frame) + kSideMargin;
            view.frame = f;
            view.highlighted = NO;
        }

        prevView = view;
        [self.indicators addObject:view];
        [self.indicatorBaseView addSubview:view];
    }
    
    [self addSubview:self.indicatorBaseView];
}

- (void)updatePageIndicatorWithDiff:(NSInteger)diff animated:(BOOL)animated
{
    NSInteger currentPageIndex = (self.currentPage - 1);

    CSNIndicatorView *toBeCurrentIndicator = [self.indicators objectAtIndex:currentPageIndex];

    CSNIndicatorView *leftSideOfCurrentIndicator = nil;
    if (self.currentPage != 1) {
        leftSideOfCurrentIndicator = [self.indicators objectAtIndex:currentPageIndex - 1];
    }

    CSNIndicatorView *rightSideOfCurrentIndicator = nil;
    if (self.numberOfPages != self.currentPage) {
        rightSideOfCurrentIndicator = [self.indicators objectAtIndex:currentPageIndex + 1];
    }


    if (diff > 0) {
        // to left
//        NSLog(@"%s %@", __PRETTY_FUNCTION__, @"Left animation");
        [self modifyAsCurrentIndicatorShape:toBeCurrentIndicator direction:CSNPageControlAnimationDirectionRight animated:animated];
        [self modifyAsDeselctedIndicatorShape:rightSideOfCurrentIndicator direction:CSNPageControlAnimationDirectionRight animated:animated];
    } else {
        // to right
//        NSLog(@"%s %@", __PRETTY_FUNCTION__, @"Right animation");
        [self modifyAsCurrentIndicatorShape:toBeCurrentIndicator direction:CSNPageControlAnimationDirectionLeft animated:animated];
        [self modifyAsDeselctedIndicatorShape:leftSideOfCurrentIndicator direction:CSNPageControlAnimationDirectionLeft animated:animated];
    }
}

#pragma mark - Touch

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL result = [super beginTrackingWithTouch:touch withEvent:event];
    return result;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    BOOL result = [super continueTrackingWithTouch:touch withEvent:event];
    return result;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
    CGPoint point = [touch locationInView:self];

//    NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(point));

    if (CGRectContainsPoint(self.bounds, point)) {
//        NSLog(@"%s %@", __PRETTY_FUNCTION__, @"Inside");

        CGRect sliceRect     = CGRectNull; /// this would be left rectangle.
        CGRect remainderRect = CGRectNull; /// this would be right rectangle.

        CGRectDivide(self.bounds, &sliceRect, &remainderRect, CGRectGetMidX(self.bounds), CGRectMinXEdge);

        if (CGRectContainsPoint(sliceRect, point)) {
            // left side
//            NSLog(@"%s %@", __PRETTY_FUNCTION__, @"Left");

            if (self.currentPage != 1) {
                [self setCurrentPage:self.currentPage - 1 animated:YES];
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }

        } else if (CGRectContainsPoint(remainderRect, point)) {
            // right side
//            NSLog(@"%s %@", __PRETTY_FUNCTION__, @"Right");

            if (self.numberOfPages != self.currentPage) {
                [self setCurrentPage:self.currentPage + 1 animated:YES];
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    return [super cancelTrackingWithEvent:event];
}


@end
