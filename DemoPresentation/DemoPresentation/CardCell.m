//
//  CardCell.m
//  DemoPresentation
//
//  Created by Samuel on 2018/9/26.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "CardCell.h"
#import "CardLayoutAttributes.h"

@implementation CardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 10;
        self.contentView.clipsToBounds = YES;
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.frame = CGRectMake(40, 20, frame.size.width - 60, 40);
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    CardLayoutAttributes *cardLayoutAttributes = (CardLayoutAttributes *)layoutAttributes;
    self.layer.zPosition = cardLayoutAttributes.zIndex;
}

- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates {
    UIView *snapshotView = [[UIView alloc] initWithFrame:self.frame];
    UIView *snapshotOfContentView = [self.contentView snapshotViewAfterScreenUpdates:afterUpdates];
    if (snapshotOfContentView) {
        [snapshotView addSubview:snapshotOfContentView];
    }
    [self setupLayerForView:snapshotView];
    return snapshotView;
}

- (void)setupLayerForView:(UIView *)forView {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10];
    forView.layer.shadowPath = shadowPath.CGPath;
    forView.layer.masksToBounds = NO;
    forView.layer.shadowColor = [[UIColor blackColor] CGColor];
    forView.layer.shadowRadius = 2;
    forView.layer.shadowOpacity = 0.35;
    forView.layer.shadowOffset = CGSizeMake(0, 0);
    forView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    forView.layer.shouldRasterize = YES;
    forView.clipsToBounds = NO;
}

@end




























