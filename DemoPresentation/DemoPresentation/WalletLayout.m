//
//  WalletLayout.m
//  DemoPresentation
//
//  Created by Samuel on 2018/9/26.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "WalletLayout.h"
#import "CardLayoutAttributes.h"

@interface WalletLayout ()

@property (nonatomic, assign) CGFloat cardHeadHeight;
@property (nonatomic, assign) CGFloat spaceAtBottom;
@property (nonatomic, assign) CGFloat scrollAreaTop;
@property (nonatomic, assign) CGFloat scrollAreaBottom;
@property (nonatomic, assign) CGFloat spaceAtTopForBackgroundView;
@property (nonatomic, assign) BOOL spaceAtTopShouldSnap;
@property (nonatomic, assign) BOOL scrollShouldSnapCardHead;
@property (nonatomic, assign) NSInteger collectionViewItemCount;
@property (nonatomic, assign) CGSize cardCollectionCellSize;
@property (nonatomic, strong) NSMutableArray<CardLayoutAttributes *> *cardCollectionViewLayoutAttributes;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *collectionViewDeletedIndexPaths;

@end

@implementation WalletLayout

- (UIEdgeInsets)contentInset {
    if (@available(iOS 11, *)) {
        return self.collectionView.adjustedContentInset;
    } else {
        return self.collectionView.contentInset;
    }
}

- (CGFloat)contentOffsetTop {
    return self.collectionView.contentOffset.y + self.contentInset.top;
}

- (CGFloat)contentInsetBottom {
    return self.contentInset.bottom;
}

- (CGSize)generateCellSize {
    CGFloat width = self.collectionView.frame.size.width - (self.contentInset.left + self.contentInset.right);
    CGFloat maxHeight = self.collectionView.frame.size.height - (10 * 5 - (self.contentInset.top + self.contentInsetBottom) - 2);
    return CGSizeMake(width, maxHeight);
}

- (NSMutableArray<CardLayoutAttributes *> *)generateCardCollectionViewLayoutAttributes {
    NSMutableArray<CardLayoutAttributes *> *cardLayoutAttributes = [NSMutableArray array];
    
//    NSInteger startIndex = (self.collectionView.contentOffset.y + self.contentInset.top - self.spaceAtTopForBackgroundView) / self.cardHeadHeight - 10;
//    NSInteger endBeforeIndex = (self.collectionView.contentOffset.y + self.collectionView.frame.size.height) / self.cardHeadHeight + 5;
//
//    if(startIndex < 0) {
//        startIndex = 0;
//    }
//
//    if(endBeforeIndex > self.collectionViewItemCount) {
//        endBeforeIndex = self.collectionViewItemCount;
//    }
    
    for (NSUInteger itemIndex = 0; itemIndex < _collectionViewItemCount; itemIndex++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
        CardLayoutAttributes *cardLayoutAttribute = [CardLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        cardLayoutAttribute.zIndex = itemIndex;
        
        CGRect currentFrame = CGRectMake(0, self.spaceAtTopForBackgroundView + self.cardHeadHeight * itemIndex, self.cardCollectionCellSize.width, self.cardCollectionCellSize.height);
        
        CGFloat stretchMultiplier = 1 + (itemIndex + 1) * -0.2;
        currentFrame.origin.y = currentFrame.origin.y + self.contentOffsetTop * stretchMultiplier;
        cardLayoutAttribute.frame = currentFrame;
        
        if (itemIndex < cardLayoutAttributes.count) {
            cardLayoutAttributes[itemIndex] = cardLayoutAttribute;
        } else {
            [cardLayoutAttributes addObject:cardLayoutAttribute];
        }
    }
    
    return cardLayoutAttributes;
}

- (CGSize)collectionViewContentSize {
    CGFloat contentHeight = self.cardHeadHeight * self.collectionViewItemCount + self.spaceAtTopForBackgroundView + self.spaceAtBottom;
    CGFloat contentWidth = CGRectGetWidth(self.collectionView.frame) - (self.contentInset.left + self.contentInset.right);
    return CGSizeMake(contentWidth, contentHeight);
}

- (void)prepareLayout {
    [super prepareLayout];
    self.spaceAtBottom = 120;
    self.cardHeadHeight = 80;
    self.scrollAreaTop = 120;
    self.scrollAreaBottom = 120;
    self.spaceAtTopShouldSnap = YES;
    self.scrollShouldSnapCardHead = NO;
    self.spaceAtTopForBackgroundView = 0;
    self.collectionViewDeletedIndexPaths = [NSMutableArray array];
    self.collectionViewItemCount = [self.collectionView numberOfItemsInSection:0];
    self.cardCollectionCellSize = [self generateCellSize];
    self.cardCollectionViewLayoutAttributes = [self generateCardCollectionViewLayoutAttributes];
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath; {
    return self.cardCollectionViewLayoutAttributes[indexPath.item];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *layout in self.cardCollectionViewLayoutAttributes) {
        if (CGRectIntersectsRect(layout.frame, rect)) {
            [attributes addObject:layout];
        }
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat proposedContentOffsetY = proposedContentOffset.y + self.contentInset.top;
    
    if(self.spaceAtTopShouldSnap && self.spaceAtTopForBackgroundView > 0) {
        
        if(proposedContentOffsetY > 0 && proposedContentOffsetY < self.spaceAtTopForBackgroundView) {
            
            CGFloat scrollToTopY = self.spaceAtTopForBackgroundView * 0.5;
            
            if(proposedContentOffsetY < scrollToTopY) {
                return CGPointMake(0, 0 - self.contentInset.top);
            } else {
                return CGPointMake(0, self.spaceAtTopForBackgroundView - self.contentInset.top);
            }
        }
    }
    
    if (self.scrollShouldSnapCardHead && proposedContentOffsetY > self.spaceAtTopForBackgroundView && self.collectionView.contentSize.height > CGRectGetHeight(self.collectionView.frame) + self.cardHeadHeight) {
        
        NSInteger startIndex = (proposedContentOffsetY - self.spaceAtTopForBackgroundView) / self.cardHeadHeight + 1;
        CGFloat positionToGoUp = self.cardHeadHeight * 0.5;
        CGFloat cardHeadPosition = fmod(proposedContentOffsetY - self.spaceAtTopForBackgroundView, self.cardHeadHeight);
        if(cardHeadPosition > positionToGoUp) {
            CGFloat targetY = (startIndex * self.cardHeadHeight) + (self.spaceAtTopForBackgroundView - self.contentInset.top);
            return CGPointMake(0, targetY);
        } else {
            CGFloat targetY = (startIndex * self.cardHeadHeight) - self.cardHeadHeight + (self.spaceAtTopForBackgroundView - self.contentInset.top);
            return CGPointMake(0, targetY);
        }
    }
    return proposedContentOffset;
}


- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    [self.collectionViewDeletedIndexPaths removeAllObjects];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionDelete: {
                if (updateItem.indexPathBeforeUpdate) {
                    [self.collectionViewDeletedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
                }
                break;
            }
            default:
                break;
        }
    }
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attrs = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    if ([self.collectionViewDeletedIndexPaths containsObject:itemIndexPath]) {
        attrs.alpha = 0.0;
        attrs.transform3D = CATransform3DScale(attrs.transform3D, 0.001, 0.001, 1);
    }
    return attrs;
}

@end





























