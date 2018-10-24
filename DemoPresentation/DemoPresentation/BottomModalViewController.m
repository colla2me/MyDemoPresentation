//
//  BottomModalViewController.m
//  DemoPresentation
//
//  Created by Samuel on 2018/10/15.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "BottomModalViewController.h"
#import "Masonry.h"
#import "SlideAnimatedTransitioning.h"

#ifndef RGBA//(r,g,b,a)
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#endif

@interface BottomModalViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BottomModalViewController

static NSString * const reuseCellID = @"reuseCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) * .25, CGRectGetWidth(self.view.frame), 80)];
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
    
    UIBezierPath *roundCorner = [UIBezierPath bezierPathWithRoundedRect:topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = topView.bounds;
    maskLayer.path = roundCorner.CGPath;
    topView.layer.mask = maskLayer;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseCellID];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    [self.view addGestureRecognizer:self.tableView.panGestureRecognizer];
}

- (void)onClickClose {
    [self.navigationController popViewControllerAnimated:YES];
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
    BottomModalViewController *vc = [[BottomModalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
