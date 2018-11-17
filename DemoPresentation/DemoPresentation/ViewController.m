//
//  ViewController.m
//  DemoPresentation
//
//  Created by Samuel on 2018/9/19.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "CardCell.h"
#import "WalletLayout.h"
#import "MyCollectionView.h"
#import "TableViewController.h"
#import "SlideAnimatedTransitioning.h"
#import "BottomModalViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Person+CoreDataClass.h"
#import "StepSlider.h"

#ifndef HEXColor
#define HEXColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) MyCollectionView *collectionView;
@property (nonatomic, strong) NSArray *cellInfo;
@property (nonatomic, weak) UILabel *textLabel;
@end

@implementation ViewController

static NSString * const reuseIdentifier = @"CardCell";

- (IBAction)addAction:(id)sender {
//    self.smsCodeView
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.navigationController.delegate = self;
//    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"fmod: %f", fmod(8.625, 0.75));
    
//    [self createDataWithName:@"nicoal" age:22];
//    [self createDataWithName:@"bob" age:24];
//    [self createDataWithName:@"junier" age:25];

//    [self createDataWithName:@"marina" age:22];
//    [self createDataWithName:@"kotoko" age:21];
//    [self createDataWithName:@"yoshita" age:19];
    
//    [self updateData];
//    [self findData];
    [self buildStepSliderView];
}

- (void)buildStepSliderView {
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 150));
    }];
    
    StepSlider *slider = [[StepSlider alloc] init];
    slider.maxValue = 0.4;
    slider.minValue = 0.2;
    slider.trackHeight = 6;
    slider.numberStyle = NSNumberFormatterPercentStyle;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:slider];
    slider.backgroundColor = [UIColor yellowColor];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(50);
        make.width.mas_equalTo(200);
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor orangeColor];
    textLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:textLabel];
    self.textLabel = textLabel;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(slider);
        make.left.equalTo(slider.mas_right).offset(10);
    }];
}

- (void)sliderValueChanged:(StepSlider *)slider {
    NSLog(@"slider value is %.f", slider.value);
    self.textLabel.text = slider.decimal;
}

- (void)createDataWithName:(NSString *)name age:(int)age {
    Person *person = [Person MR_createEntity];
    person.name = name;
    person.job = @"engineer";
    person.age = age;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)findData {
    NSArray *persons = [Person MR_findAll];
//    NSArray *personSorted = [Person MR_findAllSortedBy:@"name" ascending:YES];
//    NSArray *personAgeEqual22 = [Person MR_findByAttribute:@"age" withValue:@26];
    for (Person * person in persons) {
        NSLog(@"%@  %@  %@  %@", person.name, person.job, @(person.age), @(person.sex));
    }
//    NSLog(@"%@  %@  %@  %@", person, personSorted, personAgeEqual20, personFirst);
//    Person *personFirst = [Person MR_findFirst];
//    NSLog(@"%@  %@  %@  %@", personFirst.name, personFirst.job, @(personFirst.age), @(personFirst.sex));
}

- (void)updateData {
    NSArray *personAgeEqual22 = [Person MR_findByAttribute:@"age" withValue:@22];
    Person *person = nil;
    NSEnumerator *keyEnumerator = [personAgeEqual22 objectEnumerator];
    NSArray *names = @[@"nishino", @"shirashi"];
    NSUInteger index = 0;
    while (person = [keyEnumerator nextObject]) {
        person.name = names[index];
        person.age = 24+index;
        index++;
    }
    
    for (Person * p in personAgeEqual22) {
        p.job = @"UI Design";
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)setupWalletLayout {
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
    
//    [TableViewController presentModalInViewController:self];
    BottomModalViewController *vc = [[BottomModalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    SlideAnimatedTransitioning *transitioning = [[SlideAnimatedTransitioning alloc] init];
    transitioning.fromType = SlideAnimatedTransitioningFromBottom;
    transitioning.operationType = operation;
    return transitioning;
}

@end
