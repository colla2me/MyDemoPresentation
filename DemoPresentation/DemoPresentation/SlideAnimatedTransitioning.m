//
//  SlideAnimatedTransitioning.m
//  FoodVan
//
//  Created by Samuel Cheung on 2018/6/21.
//  Copyright © 2018年 30days. All rights reserved.
//

#import "SlideAnimatedTransitioning.h"

@implementation SlideAnimatedTransitioning

- (instancetype) init {
    if ((self = [super init])) {
        _fromType = SlideAnimatedTransitioningFromRight;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.26;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    switch (self.operationType) {
        case UINavigationControllerOperationPush:
            [self pushTransitionFrom:fromVC to:toVC withContext:transitionContext];
            break;
            
        case UINavigationControllerOperationPop:
            [self popTransitionFrom:fromVC to:toVC withContext:transitionContext];
            break;
            
        default: {
            CGRect endFrame = [transitionContext containerView].bounds;
            toVC.view.frame = endFrame;
            [transitionContext completeTransition:YES];
            break;
        }
    }
}

- (void)pushTransitionFrom:(UIViewController *)fromVC to:(UIViewController *)toVC withContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView],
    *fromView = fromVC.view,
    *toView = toVC.view,
    *snapshot = nil;
    
    CGRect fullFrame = [transitionContext initialFrameForViewController:fromVC];
    CGFloat width = fullFrame.size.width;
    CGFloat height = fullFrame.size.height;
    CGRect offscreenLeft = fullFrame;
    
    switch (self.fromType) {
        case SlideAnimatedTransitioningFromLeft: {
            offscreenLeft.origin.x = width;
            
            CGRect offscreenRight = toView.frame;
            offscreenRight.origin.x = -width;
            toView.frame = offscreenRight;
            break;
        }
        case SlideAnimatedTransitioningFromRight: {
            offscreenLeft.origin.x = -width / 3;
            
            CGRect offscreenRight = toView.frame;
            offscreenRight.origin.x = width;
            toView.frame = offscreenRight;
            break;
        }
        case SlideAnimatedTransitioningFromBottom: {
            CGRect offscreenRight = toView.frame;
            offscreenRight.origin.y = height;
            toView.frame = offscreenRight;
            
            snapshot = [fromView snapshotViewAfterScreenUpdates:NO];
            snapshot.tag = 1000;
            snapshot.alpha = 0;
            [toView addSubview:snapshot];
            [toView sendSubviewToBack:snapshot];
            break;
        }
        default:
            break;
    }
    
    [containerView addSubview:toView];
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseIn;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:options animations:^{
        snapshot.alpha = 1;
        toView.frame = fromView.frame;
        fromView.frame = offscreenLeft;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        // when cancelling or completing the animation, ios simulator seems to sometimes flash black backgrounds during the animation. on devices, this doesn't seem to happen though.
        // containerView.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)popTransitionFrom:(UIViewController *)fromVC to:(UIViewController *)toVC withContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView],
    *fromView = fromVC.view,
    *toView = toVC.view;
    
    CGRect fullFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offScreen = fullFrame;
    
    switch (self.fromType) {
        case SlideAnimatedTransitioningFromLeft:
            offScreen.origin.x = -offScreen.size.width;
            break;
        case SlideAnimatedTransitioningFromRight:
            offScreen.origin.x = offScreen.size.width;
            break;
        case SlideAnimatedTransitioningFromBottom: {
            UIView *snapshot = [fromView viewWithTag:1000];
            [snapshot removeFromSuperview];
            offScreen.origin.y = offScreen.size.height;
            break;
        }
        default:
            break;
    }
    
    [containerView insertSubview:toView belowSubview:fromView];
    
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseOut;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:options animations:^{
        
        fromView.frame = offScreen;
        if (SlideAnimatedTransitioningFromLeft == self.fromType) {
            toView.frame = containerView.bounds;
        }
    } completion:^(BOOL finished) {
        toView.layer.opacity = 1.0;
        fromView.layer.shadowOpacity = 0;
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
