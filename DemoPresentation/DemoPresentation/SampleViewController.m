//
//  CollectionViewController.m
//  SampleObjC
//
//  Created by samuel on 2018/9/23.
//  Copyright © 2018年 Samuel. All rights reserved.
//

#import "SampleViewController.h"
#import "SampleTagCell.h"
#import "SampleAlignedLayout.h"

@interface SampleViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray<NSString *> *tags;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedTags;
@property (nonatomic, strong) NSIndexPath *lastSelectedTagIndexPath;
@end

@implementation SampleViewController

static NSString * const reuseIdentifier = @"SampleTagCell";

- (instancetype)init {
    SampleAlignedLayout *layout = [[SampleAlignedLayout alloc] init];
    layout.itemSize = CGSizeMake(90, 30);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    return [self initWithCollectionViewLayout:layout];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _selectedTags = [NSMutableArray array];
        _tags = @[@"新手", @"瘦身餐", @"孕妇", @"无辣不欢", @"清淡", @"养生", @"儿童餐", @"快手菜", @"增肌", @"养颜", @"家常菜", @"素食", @"酸甜", @"下饭菜", @"网红菜", @"百无禁忌", @"卤味", @"早餐控", @"开胃菜", @"一人食", @"下酒菜", @"深夜厨房", @"懒人", @"宴客菜", @"浪漫时光", @"节日/节庆", @"民族特色", @"异国风味", @"新手1", @"瘦身餐1", @"孕妇1", @"无辣不欢1", @"清淡1", @"养生1", @"儿童餐1", @"快手菜1", @"增肌1", @"养颜1", @"家常菜1", @"素食1", @"酸甜1", @"下饭菜1", @"网红菜1", @"百无禁忌", @"卤味1", @"早餐控1", @"开胃菜1", @"一人食1", @"下酒菜1", @"深夜厨房", @"懒人1", @"宴客菜1", @"浪漫时光", @"节日/节庆", @"民族特色", @"异国风味"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[SampleTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SampleTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.tagLabel.text = _tags[indexPath.item];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL flag = self.selectedTags.count < 5;
    return flag;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tag = self.tags[indexPath.item];
    if (self.lastSelectedTagIndexPath && self.lastSelectedTagIndexPath == indexPath) {
        [collectionView deselectItemAtIndexPath:_lastSelectedTagIndexPath animated:NO];
        [_selectedTags removeObject:tag];
    }
    else {
        [self.selectedTags addObject:tag];
    }
    
    self.lastSelectedTagIndexPath = indexPath;
    NSLog(@"selectedtags: %@", self.selectedTags);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tag = self.tags[indexPath.item];
    [self.selectedTags removeObject:tag];
    self.lastSelectedTagIndexPath = nil;
}

@end
