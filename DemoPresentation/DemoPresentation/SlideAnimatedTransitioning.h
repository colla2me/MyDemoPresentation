//
//  SlideAnimatedTransitioning.h
//  FoodVan
//
//  Created by Samuel Cheung on 2018/6/21.
//  Copyright © 2018年 30days. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SlideAnimatedTransitioningFrom) {
    SlideAnimatedTransitioningFromLeft,
    SlideAnimatedTransitioningFromRight,
    SlideAnimatedTransitioningFromBottom
};

@interface SlideAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) enum UINavigationControllerOperation operationType;
@property (nonatomic, assign) enum SlideAnimatedTransitioningFrom fromType;

@end

