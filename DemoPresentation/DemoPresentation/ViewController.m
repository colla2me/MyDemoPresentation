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

#ifndef HEXColor
#define HEXColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *cellInfo;
@end

@implementation ViewController

static NSString * const reuseIdentifier = @"CardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    WalletLayout *layout = [[WalletLayout alloc] init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 200);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[CardCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    self.cellInfo = @[@{@"text": @"会员信息", @"color": HEXColor(0xfcc630)}, @{@"text": @"实体店铺", @"color": HEXColor(0xf8a032)}, @{@"text": @"我的奖品", @"color": HEXColor(0xf58b33)}, @{@"text": @"邀请好友", @"color": HEXColor(0xf47435)}, @{@"text": @"系统设置", @"color": [UIColor redColor]}, @{@"text": @"积分商城", @"color": [UIColor greenColor]}, @{@"text": @"每日生鲜", @"color": [UIColor magentaColor]}, @{@"text": @"配送到家", @"color": [UIColor yellowColor]}];
    [self.collectionView reloadData];
    
    CGRect frame = CGRectMake(CGRectGetMidX(self.view.frame) - 30, 30 + CGRectGetMaxY(self.navigationController.navigationBar.frame), 60, 60);
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:frame];
    avatarView.backgroundColor = [UIColor purpleColor];
    avatarView.layer.cornerRadius = 30;
    [self.view addSubview:avatarView];
    
    CGRect rect = CGRectMake(CGRectGetMidX(self.view.frame) - 100, CGRectGetMaxY(avatarView.frame) + 8, 200, 20);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:rect];
    textLabel.text = @"XXXX昵称";
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textLabel];
    
    NSLog(@"fmod: %f", fmod(8.625, 0.75));
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
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
    NSLog(@"indexPath at: %ld", indexPath.item);
}

@end
