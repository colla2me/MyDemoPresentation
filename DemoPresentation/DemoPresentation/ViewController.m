//
//  ViewController.m
//  DemoPresentation
//
//  Created by Samuel on 2018/9/19.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "ViewController.h"
#import "CardCell.h"
#import "WalletLayout.h"
#import "MyCollectionView.h"
#import "TableViewController.h"

#ifndef HEXColor
#define HEXColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) MyCollectionView *collectionView;
@property (nonatomic, strong) NSArray *cellInfo;
@end

@implementation ViewController

static NSString * const reuseIdentifier = @"CardCell";

- (IBAction)addAction:(id)sender {
//    self.smsCodeView
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";

    self.cellInfo = @[@{@"text": @"会员信息", @"color": HEXColor(0xfcc630)}, @{@"text": @"实体店铺", @"color": HEXColor(0xf8a032)}, @{@"text": @"我的奖品", @"color": HEXColor(0xf58b33)}, @{@"text": @"邀请好友", @"color": HEXColor(0xf47435)}, @{@"text": @"系统设置", @"color": [UIColor redColor]}, @{@"text": @"积分商城", @"color": [UIColor greenColor]}, @{@"text": @"每日生鲜", @"color": [UIColor magentaColor]}, @{@"text": @"配送到家", @"color": [UIColor yellowColor]}];
    [self.collectionView reloadData];
    
    CGRect frame = CGRectMake(CGRectGetMidX(self.view.frame) - 30, 30 + CGRectGetMaxY(self.navigationController.navigationBar.frame), 60, 60);
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:frame];
    avatarView.backgroundColor = [UIColor purpleColor];
    avatarView.userInteractionEnabled = YES;
    avatarView.layer.cornerRadius = 30;
    [self.view addSubview:avatarView];
    [avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvatar)]];

    CGRect rect = CGRectMake(CGRectGetMidX(self.view.frame) - 100, CGRectGetMaxY(avatarView.frame) + 8, 200, 20);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:rect];
    textLabel.text = @"XXXX昵称";
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];

    CGRect rect1 = CGRectMake(CGRectGetMidX(self.view.frame) * 0.5 - 50, CGRectGetMaxY(textLabel.frame) + 8, 100, 40);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:rect1];
    btn.layer.borderColor = [UIColor greenColor].CGColor;
    btn.layer.borderWidth = 1;
    [btn setTitle:@"关注 100" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    CGRect rect2 = CGRectMake(CGRectGetMidX(self.view.frame) * 1.5 - 50, CGRectGetMaxY(textLabel.frame) + 8, 100, 40);
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:rect2];
    btn2.layer.borderColor = [UIColor greenColor].CGColor;
    btn2.layer.borderWidth = 1;
    [btn2 setTitle:@"粉丝 99" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn2 addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    WalletLayout *layout = [[WalletLayout alloc] init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 200);
    self.collectionView = [[MyCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.userInteractionEnabled = YES;
    //    self.collectionView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.avatarView = avatarView;
    self.collectionView.followBtn = btn;
    self.collectionView.fanBtn = btn2;
    [self.collectionView registerClass:[CardCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    
//    NSLog(@"fmod: %f", fmod(8.625, 0.75));
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)onTapAvatar {
    NSLog(@"avtarView did Tapped !!!!");
}

- (void)onClickBtn:(UIButton *)sender {
    NSLog(@"btn-%@ did Clicked !!!!", [sender titleForState:UIControlStateNormal]);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.cellInfo count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.cellInfo[indexPath.item][@"text"];
    cell.contentView.backgroundColor = self.cellInfo[indexPath.item][@"color"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WalletLayout *layout = (WalletLayout *)collectionView.collectionViewLayout;
    [layout revealCardAtIndex:indexPath.item];
    
    [TableViewController presentModalInViewController:self];
}

@end
