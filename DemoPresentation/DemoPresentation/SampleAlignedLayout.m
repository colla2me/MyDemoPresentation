//
//  SampleAlignedLayout.m
//  SampleObjC
//
//  Created by samuel on 2018/10/11.
//  Copyright © 2018 Samuel. All rights reserved.
//

#import "SampleAlignedLayout.h"

@interface SampleAlignedLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *alignedLayoutAttributes;

@end

@implementation SampleAlignedLayout

- (void)prepareLayout {
    [super prepareLayout];
    NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    _alignedLayoutAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGSize itemSize = self.itemSize;
    CGFloat lineSpacing = self.minimumLineSpacing;
    CGFloat itemSpacing = self.minimumInteritemSpacing;
    CGFloat centerX = CGRectGetMidX(self.collectionView.frame);
    
    UICollectionViewLayoutAttributes *beforeAttr = nil;
    for (NSUInteger item = 0; item < itemCount; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGRect frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
        
        NSUInteger group = item / 5;
        
        switch (item % 5) {
            case 0:
                frame.origin.x = centerX - itemSize.width - itemSpacing * 0.5;
                frame.origin.y = group * (itemSize.height + lineSpacing) * 2;
                break;
                
            case 1:
                frame.origin.x = centerX + itemSpacing * 0.5;
                frame.origin.y = CGRectGetMinY(beforeAttr.frame);
                break;
                
            case 2:
                frame.origin.x = centerX - itemSize.width * 0.5;
                frame.origin.y = CGRectGetMaxY(beforeAttr.frame) + lineSpacing;
                break;
                
            case 3: {
                frame.origin.x = centerX - itemSize.width * 0.5;
                frame.origin.y = CGRectGetMinY(beforeAttr.frame);
                CGRect rect = beforeAttr.frame;
                rect.origin.x = CGRectGetMinX(frame) - itemSpacing - itemSize.width;
                beforeAttr.frame = rect;
                break;
            }
                
            case 4:
                frame.origin.x = CGRectGetMaxX(beforeAttr.frame) + itemSpacing;
                frame.origin.y = CGRectGetMinY(beforeAttr.frame);;
                break;
            default:
                break;
        }
        attr.frame = frame;
        beforeAttr = attr;
        [_alignedLayoutAttributes addObject:attr];
    }
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath; {
    return self.alignedLayoutAttributes[indexPath.item];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *layout in self.alignedLayoutAttributes) {
        if (CGRectIntersectsRect(layout.frame, rect)) {
            [attributes addObject:layout];
        }
    }
    return attributes.copy;
}

- (UIEdgeInsets)contentInset {
    if (@available(iOS 11, *)) {
        return self.collectionView.adjustedContentInset;
    } else {
        return self.collectionView.contentInset;
    }
}

- (CGSize)collectionViewContentSize {
    UIEdgeInsets sectionInset = self.sectionInset;
    UIEdgeInsets contentInset = self.contentInset;
    UICollectionViewLayoutAttributes *attr = self.alignedLayoutAttributes.lastObject;
    CGFloat contentHeight = CGRectGetMaxY(attr.frame) + sectionInset.top + sectionInset.bottom + contentInset.top + contentInset.bottom;
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), contentHeight);
}

@end
