//
//  VerticalSlider.m
//  DemoPresentation
//
//  Created by Samuel on 2018/11/17.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "ScaleSlider.h"

@interface ScaleSlider ()
@property (nonatomic, assign) int scale; // defaults: 10
@property (nonatomic, strong) CAShapeLayer *scaleLayer;
@property (nonatomic, strong) CAShapeLayer *sliderLayer;
@property (nonatomic, strong) CAShapeLayer *thumbLayer;
@end

const int HANDLE_TOUCH_AREA_SCALE = -20;

@implementation ScaleSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setMinValue:(float)minValue {
    _minValue = minValue;
    _value = minValue;
}

- (void)setThumbDiameter:(CGFloat)thumbDiameter {
    _thumbDiameter = thumbDiameter;
    self.thumbLayer.cornerRadius = thumbDiameter * 0.5;
    self.thumbLayer.frame = CGRectMake(0, 0, thumbDiameter, thumbDiameter);
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    _thumbTintColor = thumbTintColor;
    self.thumbLayer.backgroundColor = thumbTintColor.CGColor;
}

- (void)setValue:(float)value {
    if (value < self.minValue){
        value = self.minValue;
    }
    
    if (_value == value) return;
    _value = value;
    [self refresh];
}

- (void)setup {
    _value = 0;
    _minValue = 0;
    _maxValue = 100;
    _enableStep = YES;
    _scale = 10;
    _thumbDiameter = 16;
    
    _thumbTintColor = [UIColor orangeColor];
    self.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    _scaleLayer = [CAShapeLayer layer];
    _scaleLayer.backgroundColor = self.tintColor.CGColor;
    [self.layer addSublayer:_scaleLayer];
    
    _sliderLayer = [CAShapeLayer layer];
    _sliderLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_sliderLayer];
    
    for (int i = 0; i < _scale; i++) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.backgroundColor = [UIColor whiteColor].CGColor;
        float width = _thumbDiameter * 0.6;
        if (0 == i || _scale == i + 1) {
            width = _thumbDiameter * 0.4;
        }
        layer.frame = CGRectMake(0, 0, width, 1);;
        [_sliderLayer addSublayer:layer];
    }
    
    _thumbLayer = [CAShapeLayer layer];
    _thumbLayer.cornerRadius = _thumbDiameter * 0.5;
    _thumbLayer.backgroundColor = _thumbTintColor.CGColor;
    _thumbLayer.contentsScale = [UIScreen mainScreen].scale;
    _thumbLayer.frame = CGRectMake(0, 0, _thumbDiameter, _thumbDiameter);
    [self.layer addSublayer:_thumbLayer];
    
    [self refresh];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(30, UIViewNoIntrinsicMetric);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect currentFrame = self.frame;
    self.scaleLayer.frame = self.bounds;
    self.scaleLayer.cornerRadius = CGRectGetWidth(currentFrame) * 0.5;
    
    float inset = (currentFrame.size.width - self.thumbDiameter) * 0.5;
    float paddingTop = inset + self.thumbDiameter * 0.5;
    float trackHeight = currentFrame.size.height - paddingTop * 2;
    float trackWidth = self.thumbDiameter;
    
    self.sliderLayer.frame = CGRectMake(inset, paddingTop, trackWidth, trackHeight);
    
    float margin = trackHeight / (_scale - 1);
    int i = 0;
    for (CALayer *layer in _sliderLayer.sublayers) {
        layer.position = CGPointMake(trackWidth * 0.5, margin * i);
        i += 1;
    }
    [self updateThumbPositions];
}

- (void)updateThumbPositions {
    CGPoint thumbCenter = CGPointMake(CGRectGetMidX(self.sliderLayer.frame), [self getYPositionAlongLineForValue:self.value]);
    
    self.thumbLayer.position = thumbCenter;
}

- (float)getYPositionAlongLineForValue:(float)value {
    float percentage = [self getPercentageAlongLineForValue:value];
    float maxMinDif = CGRectGetMaxY(self.sliderLayer.frame) - CGRectGetMinY(self.sliderLayer.frame);
    float offset = percentage * maxMinDif;
    return CGRectGetMinY(self.sliderLayer.frame) + offset;
}

- (float)getPercentageAlongLineForValue:(float) value {
    if (self.minValue == self.maxValue){
        return 0;
    }
    
    float maxMinDif = self.maxValue - self.minValue;
    float valueSubtracted = value - self.minValue;
    return valueSubtracted / maxMinDif;
}

- (void)tintColorDidChange {
    CGColorRef color = self.tintColor.CGColor;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
    self.scaleLayer.backgroundColor = color;
    [CATransaction commit];
}

#pragma mark - Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint gesturePressLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(CGRectInset(self.thumbLayer.frame, HANDLE_TOUCH_AREA_SCALE, HANDLE_TOUCH_AREA_SCALE), gesturePressLocation))
    {
        [self animateHandle:self.thumbLayer withSelection:YES];
        return YES;
    } else {
        return NO;
    }
}

- (void)refresh {
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    [self updateThumbPositions];
    [CATransaction commit];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    float inset = CGRectGetMinY(self.sliderLayer.frame);
    float length = CGRectGetMaxY(self.sliderLayer.frame) - CGRectGetMinY(self.sliderLayer.frame);
    
    float yPos = (location.y - inset * 2);
    
    if (_enableStep) {
        float step = length / _scale;
        yPos = yPos - fmod(yPos, step);
    }
    
    float percentage = yPos / length;
    //multiply that percentage by self.maxValue to get the new selected minimum value
    float selectedValue = percentage * (self.maxValue - self.minValue) + self.minValue;
    

    if (selectedValue < self.maxValue){
        self.value = selectedValue;
    }
    else {
        self.value = self.maxValue;
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self animateHandle:self.thumbLayer withSelection:NO];
}

#pragma mark - Animation
- (void)animateHandle:(CALayer*)handle withSelection:(BOOL)selected {
    if (selected){
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.24];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
        handle.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        [CATransaction setCompletionBlock:^{}];
        [CATransaction commit];
    } else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.24];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
        handle.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
}

@end
