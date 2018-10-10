//
//  TableViewController.m
//  DemoPresentation
//
//  Created by samuel on 2018/10/9.
//  Copyright © 2018 TD-tech. All rights reserved.
//

#import "TableViewController.h"
#import "Masonry.h"
#import "SemiModalPresentationController.h"
#import "AIMultiDelegate.h"

#ifndef RGBA//(r,g,b,a)
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#endif

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AIMultiDelegate *multiDelegate;
@end

@implementation TableViewController

static NSString * const reuseCellID = @"reuseCellID";

- (instancetype)init {
    self = [super init];
    if (self) {
        _multiDelegate = [[AIMultiDelegate alloc] init];
        [_multiDelegate addDelegate:self];
    }
    return self;
}

+ (void)presentModalInViewController:(UIViewController *)presentingController {
    TableViewController *presentedViewController = [[TableViewController alloc] init];
    SemiModalPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[SemiModalPresentationController alloc] initWithPresentedViewController:presentedViewController presentingViewController:presentingController];
    presentedViewController.transitioningDelegate = presentationController;
    [presentedViewController.multiDelegate addDelegate:presentationController];
    [presentingController presentViewController:presentedViewController animated:YES completion:NULL];
}

- (void)dealloc {
    [self.view removeGestureRecognizer:self.tableView.panGestureRecognizer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 0.75);
    self.view.backgroundColor = RGBA(19, 20, 26, 1);
    
    UIBezierPath *roundCorner = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = roundCorner.CGPath;
    self.view.layer.mask = maskLayer;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = (id)_multiDelegate;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellID];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(80, 0, 0, 0));
    }];
    
    [self.view addGestureRecognizer:self.tableView.panGestureRecognizer];
    
    [self setupTopView];
}

- (void)setupTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80)];
    topView.backgroundColor = [UIColor orangeColor]; //RGBA(19, 20, 26, 1);
    [self.view addSubview:topView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"close" forState:UIControlStateNormal];
    closeBtn.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [closeBtn addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)onClickClose {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.clipsToBounds = YES;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = RGBA(19, 20, 26, 1);
    cell.textLabel.text = @"I think that the technique I have described here is a pretty nice way to get the desired behavior, although there are a few hoops you have to jump through. Architecturally, there are some things that we might want to improve. It would be nice if we could contain everything about the bottom sheet in the BottomSheetContainerViewController – currently we need to do handle stuff in the table view controller itself. While we could refactor some things, it seems difficult however to make the table view controller completely ignorant of the fact that it’s used as a bottom sheet, since we have to hook into some scroll view delegate methods.";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"gesture begin");
//    if (self.tableView.contentOffset.y > 1) {
//        return NO;
//    }
//
//    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];
//    CGFloat multiplier = 1;
//    if ((translation.y * multiplier) <= 0) {
//        NSLog(@"translation up");
//        return NO;
//    }
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    NSLog(@"gesture simultaneously");
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"gesture require failure");
//    return YES;
//}

@end
