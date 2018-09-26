//
//  CardLayoutAttributes.m
//  DemoPresentation
//
//  Created by Samuel on 2018/9/26.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "CardLayoutAttributes.h"

@implementation CardLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
    CardLayoutAttributes *attribute = [super copyWithZone:zone];
    attribute.isRevealed = _isRevealed;
    return attribute;
}

@end
