//
//  SemiModalPresentationController.m
//  FoodVan
//
//  Created by Samuel Cheung on 2018/7/18.
//  Copyright © 2018年 30days. All rights reserved.
//

#import "SemiModalPresentationController.h"

@interface SemiModalPresentationController () <UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionTransition;
@property (nonatomic, assign) CGFloat percent;
@end

static const NSTimeInterval modalTransitionDuration = 0.3f;
static const CGFloat threshold = 0.2;

@implementation SemiModalPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)presentationTransitionWillBegin {
    [self.containerView addSubview:self.dimmingView];
    [self.dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    
    self.dimmingView.alpha = 0.f;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 1.0;
    } completion:NULL];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (completed == NO) {
        self.dimmingView = nil;
    }
}

- (void)dismissalTransitionWillBegin {
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [_dimmingView removeFromSuperview];
        _dimmingView = nil;
    }
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController) {
        return ((UIViewController*)container).preferredContentSize;
    } else {
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGSize containerViewSize = self.containerView.bounds.size;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewSize];
    CGFloat y = containerViewSize.height - presentedViewContentSize.height;
    return CGRectMake(0, y, containerViewSize.width, presentedViewContentSize.height);
}

- (void)dimmingViewTapped:(UITapGestureRecognizer *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

//- (void)onPanGesture:(UIPanGestureRecognizer *)pan {
//    CGPoint translation = [pan translationInView:pan.view];
//    CGFloat dragDistance = CGRectGetHeight(pan.view.frame);
//    CGFloat percent = translation.y / dragDistance;
//    NSLog(@"percent: %.2f", percent);
//    switch (pan.state) {
//        case UIGestureRecognizerStateBegan:
//        {
//            self.interactionTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
//            if (percent > 0) {
//                [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
//            }
//        }
//            break;
//        case UIGestureRecognizerStateChanged:
//        {
//            percent = fmax(percent, 0.0);
//            percent = fmin(percent, 1.0);
//            [self.interactionTransition updateInteractiveTransition:percent];
//        }
//            break;
//        case UIGestureRecognizerStateEnded:
//        {
//            if (percent > threshold) {
//                [self.interactionTransition finishInteractiveTransition];
//            } else {
//                [self.interactionTransition cancelInteractiveTransition];
//            }
//            self.interactionTransition = nil;
//        }
//            break;
//        default:
//            [self.interactionTransition cancelInteractiveTransition];
//            self.interactionTransition = nil;
//            break;
//    }
//}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    //返回设定的时间
    if ([transitionContext isAnimated]) {
        return modalTransitionDuration;
    } else {
        return 0;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //是 presenting 或 dismiss 动画
    BOOL isPresenting = (fromViewController == self.presentingViewController);

    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    [containerView addSubview:toView];
    
    if (isPresenting) {
        //出现动画
        toViewInitialFrame.origin = CGPointMake(0, CGRectGetMaxY(containerView.bounds));
        toViewInitialFrame.size = toViewFinalFrame.size;
        toView.frame = toViewInitialFrame;
    } else {
        //结束动画
        fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (isPresenting) {
            toView.frame = toViewFinalFrame;
        } else {
            fromView.frame = fromViewFinalFrame;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return self;
}

//返回 self 作为 animator
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

//返回 self  作为 animator
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactionTransition;
}

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _dimmingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _dimmingView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!scrollView.isDecelerating && scrollView.contentOffset.y <= 0) {
        self.interactionTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"DidEndDragging");
    if (_percent > threshold) {
        [self.interactionTransition finishInteractiveTransition];
    } else {
        [self.interactionTransition cancelInteractiveTransition];
    }
    self.interactionTransition = nil;
    self.percent = 0.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:self.presentedViewController.view];

    if (_interactionTransition && translation.y > 0) {
        CGFloat dragDistance = CGRectGetHeight(self.presentedViewController.view.frame);
        _percent = translation.y / dragDistance;
        _percent = fmax(_percent, 0.0);
        _percent = fmin(_percent, 1.0);
        [self.interactionTransition updateInteractiveTransition:_percent];
        [scrollView setContentOffset:CGPointZero];
    }
    
    NSLog(@"translation: %.2f, contentOffset: %.2f", translation.y, scrollView.contentOffset.y);
}

@end
