//
//  MyCollectionView.h
//  DemoPresentation
//
//  Created by samuel on 2018/10/9.
//  Copyright © 2018 TD-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionView : UICollectionView

@property (nonatomic, weak) UIImageView *avatarView;
@property (nonatomic, weak) UIButton *followBtn;
@property (nonatomic, weak) UIButton *fanBtn;

@end

NS_ASSUME_NONNULL_END
