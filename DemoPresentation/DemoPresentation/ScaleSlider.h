//
//  VerticalSlider.h
//  DemoPresentation
//
//  Created by Samuel on 2018/11/17.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScaleSlider : UIControl

@property (nonatomic, assign) float value;
@property (nonatomic, assign) float minValue; // defaults: 0
@property (nonatomic, assign) float maxValue; // defaults: 100

@property (nonatomic, assign) BOOL enableStep; // defaults: NO
@property (nonatomic, assign) CGFloat thumbDiameter;
@property (nonatomic, strong) UIColor *thumbTintColor;

@end
