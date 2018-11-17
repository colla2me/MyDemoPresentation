//
//  FVScrollingStackViewController.m
//  DemoPresentation
//
//  Created by Samuel on 2018/11/1.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "FVScrollingStackViewController.h"

typedef NS_ENUM(NSUInteger, Position) {
    start,
    end,
    before,
    after
};

@interface FVScrollingStackViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *stackViewBackgroundView;
@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) NSMutableArray<NSLayoutConstraint *> *stackViewConstraints;
@property (nonatomic, copy) void(^viewDidLayoutSubviewsClosure)(void);

@end

@implementation FVScrollingStackViewController

- (void)scrollAnimate:(void(^)(void))animations completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:animations completion:completion];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.stackViewConstraints = [NSMutableArray array];
    [self UIDidLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.viewDidLayoutSubviewsClosure) {
        self.viewDidLayoutSubviewsClosure();
    }
}

- (void)UIDidLayout {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.stackViewBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackViewBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.stackViewBackgroundView];
    [self.scrollView addSubview:self.stackView];
    
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackViewBackgroundView.backgroundColor = [UIColor clearColor];
    
    NSDictionary<NSString *, UIView *> *views = @{@"scrollView": self.scrollView, @"stackViewBackgroundView": self.stackViewBackgroundView};
    
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    
    [self pinStackViewWithBorderWidth:0.5];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[stackViewBackgroundView]|" options:0 metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[stackViewBackgroundView(==scrollView)]|" options:0 metrics:nil views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (CGFloat)maxOffsetY {
    return self.scrollView.contentSize.height - self.scrollView.frame.size.height;
}

- (void)pinStackViewWithBorderWidth:(CGFloat)borderWidth {
    [self.scrollView removeConstraints:self.stackViewConstraints];
    [self.stackViewConstraints removeAllObjects];
    
    [self.stackViewConstraints addObject:[self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:borderWidth]];
    [self.stackViewConstraints addObject:[self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-borderWidth]];
    
    [self.stackViewConstraints addObject:[self.stackView.leftAnchor constraintEqualToAnchor:self.scrollView.leftAnchor constant:borderWidth]];
    [self.stackViewConstraints addObject:[self.stackView.rightAnchor constraintEqualToAnchor:self.scrollView.rightAnchor constant:-borderWidth]];
    
    [self.stackViewConstraints addObject:[self.stackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor constant:-borderWidth * 2]];
    
    for (NSLayoutConstraint *constraint in self.stackViewConstraints) {
        constraint.active = YES;
    }
}

- (void)addViewController:(UIViewController *)viewController {
    [self insertViewController:viewController edgeInsets:UIEdgeInsetsZero atIndex:self.childViewControllers.count];
}

- (void)addViewController:(UIViewController *)viewController edgeInsets:(UIEdgeInsets)edgeInsets {
    [self insertViewController:viewController edgeInsets:edgeInsets atIndex:self.childViewControllers.count];
}

- (void)insertViewController:(UIViewController *)viewController edgeInsets:(UIEdgeInsets)edgeInsets atIndex:(NSUInteger)index {
    index = MIN(index, MAX(self.childViewControllers.count, index));
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    
    if (UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero)) {
        UIView *childView = viewController.view;
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        childView.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:childView];
        
        NSLayoutConstraint *topConstraint = [childView.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:edgeInsets.top];
        NSLayoutConstraint *leadingConstraint = [childView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:edgeInsets.left];
        NSLayoutConstraint *bottomConstraint = [childView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor constant:edgeInsets.bottom];
        NSLayoutConstraint *trailingConstraint = [childView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:edgeInsets.right];
        NSArray<NSLayoutConstraint *> *constraints = @[topConstraint, leadingConstraint, bottomConstraint, trailingConstraint];
        
        [NSLayoutConstraint activateConstraints:constraints];
        [self.stackView insertArrangedSubview:containerView atIndex:index];
    } else {
        [self.stackView insertArrangedSubview:viewController.view atIndex:index];
    }
}

- (void)insertViewController:(UIViewController *)viewController afterViewController:(UIViewController *)afterViewController edgeInsets:(UIEdgeInsets)edgeInsets atIndex:(NSUInteger)index {
    NSInteger insertionIndex = [self arrangedViewOrContainerIndexForView:afterViewController.view];
    if (NSNotFound == insertionIndex) {
        insertionIndex = self.childViewControllers.count;
    } else {
        insertionIndex += 1;
    }
    [self insertViewController:viewController edgeInsets:edgeInsets atIndex:insertionIndex];
}

- (void)insertViewController:(UIViewController *)viewController beforeViewController:(UIViewController *)beforeViewController edgeInsets:(UIEdgeInsets)edgeInsets atIndex:(NSUInteger)index {
    NSInteger insertionIndex = [self arrangedViewOrContainerIndexForView:beforeViewController.view];
    if (NSNotFound == insertionIndex) {
        insertionIndex = self.childViewControllers.count;
    }
    [self insertViewController:viewController edgeInsets:edgeInsets atIndex:insertionIndex];
}

- (void)removeViewController:(UIViewController *)viewController {
    UIView *arrangedView = [self arrangedViewForController:viewController];
    if (!arrangedView) return;
    [self.stackView removeArrangedSubview:arrangedView];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
}

- (void)showViewController:(UIViewController *)viewController action:(void(^)(void))action {
    
}

- (void)hideViewController:(UIViewController *)viewController action:(void(^)(void))action {
    
}

- (void)scrollToView:(UIView *)aView completion:(void(^)(void))completion {
    [self scrollAnimate:^{
        
    } completion:^(BOOL isFinished) {
        if (isFinished) {
            completion();
        }
    }];
}

- (BOOL)isArrangedView:(UIView *)aView {
    return [self arrangedViewIndexForView:aView] != NSNotFound;
}

- (BOOL)isArrangedOrContainedView:(UIView *)aView {
    return [self arrangedViewOrContainerIndexForView:aView] != NSNotFound;
}

- (UIView *)arrangedViewForController:(UIViewController *)viewController {
    NSInteger index = [self arrangedViewOrContainerIndexForView:viewController.view];
    if (NSNotFound == index) {
        return nil;
    }
    return self.stackView.arrangedSubviews[index];
}

- (NSInteger)arrangedViewOrContainerIndexForView:(UIView *)aView {
    NSInteger index = [self arrangedViewIndexForView:aView];
    if (NSNotFound == index) {
        index = [self arrangedViewContainerIndexForView:aView];
    }
    return index;
}

- (NSInteger)arrangedViewIndexForView:(UIView *)aView {
    return [self.stackView.arrangedSubviews indexOfObject:aView];
}

- (NSInteger)arrangedViewContainerIndexForView:(UIView *)aView {
    UIView *containerView = nil;
    for (UIView *arrangedView in self.stackView.arrangedSubviews) {
        if ([arrangedView.subviews containsObject:arrangedView]) {
            containerView = arrangedView;
            break;
        }
    }
    if (!containerView) return NSNotFound;
    return [self.stackView.arrangedSubviews indexOfObject:containerView];
}

@end


























