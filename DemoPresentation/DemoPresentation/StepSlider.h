//
//  StepSlider.h
//  DemoPresentation
//
//  Created by Samuel on 2018/11/13.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepSlider : UIControl

@property (nonatomic, copy, readonly) NSString *decimal;

@property (nonatomic, assign) float value;
@property (nonatomic, assign) float step;
@property (nonatomic, assign) float minValue; // defaults: 0
@property (nonatomic, assign) float maxValue; // defaults: 100
@property (nonatomic, assign) BOOL enableStep;
@property (nonatomic, assign) NSNumberFormatterStyle numberStyle;

@property (nonatomic, assign) CGFloat thumbDiameter;
@property (nonatomic, assign) CGFloat trackHeight;
@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *thumbTintColor;

@end
