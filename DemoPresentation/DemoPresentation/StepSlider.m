//
//  StepSlider.m
//  DemoPresentation
//
//  Created by Samuel on 2018/11/13.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "StepSlider.h"

@interface StepSlider ()

@property (nonatomic, strong) CAShapeLayer *sliderLayer;
@property (nonatomic, strong) CAShapeLayer *sliderValueLayer;
@property (nonatomic, strong) CAShapeLayer *thumbLayer;

//@property (nonatomic, strong) CATextLayer *labelTextLayer;
//@property (nonatomic, assign) CGSize labelTextSize;
@property (nonatomic, strong) NSNumberFormatter *decimalFormatter;

@end

const int HANDLE_TOUCH_AREA_EXPANSION = -16;

@implementation StepSlider

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

- (void)setTrackHeight:(CGFloat)trackHeight {
    _trackHeight = trackHeight;
    [self setNeedsLayout];
}

- (void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    self.sliderValueLayer.backgroundColor = trackColor.CGColor;
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

- (void)setNumberStyle:(NSNumberFormatterStyle)numberStyle {
    _numberStyle = numberStyle;
    self.decimalFormatter.numberStyle = numberStyle;
}

- (void)setValue:(float)value {
    if (value < self.minValue){
        value = self.minValue;
    }
    _value = value;
    [self refresh];
}

- (NSString *)decimal {
    return [self.decimalFormatter stringFromNumber:@(self.value)];
}

- (NSNumberFormatter *)decimalFormatter {
    if (!_decimalFormatter){
        _decimalFormatter = [[NSNumberFormatter alloc] init];
        _decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _decimalFormatter.maximumFractionDigits = 0;
    }
    return _decimalFormatter;
}

- (void)setup {
    _value = 0;
    _minValue = 0;
    _maxValue = 100;
    _enableStep = NO;
    _step = 0.1f;
    _trackHeight = 5;
    _thumbDiameter = 20;
    
    _trackColor = [UIColor orangeColor];
    _thumbTintColor = [UIColor greenColor];
    self.tintColor = [UIColor grayColor];
    
    _sliderLayer = [CAShapeLayer layer];
    _sliderLayer.backgroundColor = self.tintColor.CGColor;
    [self.layer addSublayer:_sliderLayer];
    
    _sliderValueLayer = [CAShapeLayer layer];
    _sliderValueLayer.backgroundColor = _trackColor.CGColor;
    [self.layer addSublayer:_sliderValueLayer];
    
    _thumbLayer = [CAShapeLayer layer];
    _thumbLayer.cornerRadius = _thumbDiameter * 0.5;
    _thumbLayer.backgroundColor = _thumbTintColor.CGColor;
    _thumbLayer.contentsScale = [UIScreen mainScreen].scale;
    _thumbLayer.frame = CGRectMake(0, 0, _thumbDiameter, _thumbDiameter);
    [self.layer addSublayer:_thumbLayer];
    
//    self.labelTextLayer = [CATextLayer layer];
//    self.labelTextLayer.alignmentMode = kCAAlignmentCenter;
//    self.labelTextLayer.fontSize = 12;
//    self.labelTextLayer.contentsScale = [UIScreen mainScreen].scale;
//    self.labelTextLayer.foregroundColor = self.trackColor.CGColor;
//    self.labelTextLayer.frame = CGRectMake(0, 0, LABEL_TEXT_SIZE_WIDTH, LABEL_TEXT_SIZE_HEIGHT);
//    [self.layer addSublayer:self.labelTextLayer];
    
    [self refresh];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 34);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect currentFrame = self.frame;
    float leftPadding = self.thumbDiameter * 0.5;
    float yMiddle = (currentFrame.size.height - self.trackHeight) * 0.5;
    float trackWidth = currentFrame.size.width - self.thumbDiameter;
    self.sliderLayer.frame = CGRectMake(leftPadding, yMiddle, trackWidth, self.trackHeight);
    self.sliderLayer.cornerRadius = self.trackHeight * 0.5;
    
    self.sliderValueLayer.cornerRadius = self.trackHeight * 0.5;

    [self updateThumbPositions];
}

- (void)updateThumbPositions {
    CGPoint thumbCenter = CGPointMake([self getXPositionAlongLineForValue:self.value], CGRectGetMidY(self.sliderLayer.frame));
    self.thumbLayer.position = thumbCenter;
    
    self.sliderValueLayer.frame = CGRectMake(CGRectGetMinX(self.sliderLayer.frame), CGRectGetMinY(self.sliderLayer.frame), self.thumbLayer.position.x, self.trackHeight);
}

- (float)getXPositionAlongLineForValue:(float)value {
    float percentage = [self getPercentageAlongLineForValue:value];
    float maxMinDif = CGRectGetMaxX(self.sliderLayer.frame) - CGRectGetMinX(self.sliderLayer.frame);
    float offset = percentage * maxMinDif;
    return CGRectGetMinX(self.sliderLayer.frame) + offset;
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
    self.sliderLayer.backgroundColor = color;
    self.thumbLayer.backgroundColor = color;
    [CATransaction commit];
}

#pragma mark - Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint gesturePressLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(CGRectInset(self.thumbLayer.frame, HANDLE_TOUCH_AREA_EXPANSION, HANDLE_TOUCH_AREA_EXPANSION), gesturePressLocation))
    {
//        float distanceFromThumb = [self distanceBetweenPoint:gesturePressLocation andPoint:[self getCentreOfRect:self.thumbLayer.frame]];
        [self animateHandle:self.thumbLayer withSelection:YES];
        return YES;
    } else {
        return NO;
    }
}

- (void)refresh {
//    float minimum = self.minValue, maximum = self.maxValue;
//    if (self.enableStep && self.step >= 0.0f){
//        minimum = roundf(self.minValue / self.step) * self.step;
//        maximum = roundf(self.maxValue / self.step) * self.step;
//    }
    
//    float diff = maximum - minimum;

//    if (minimum < self.minValue){
//        minimum = self.minValue;
//    }
//    if (maximum > self.maxValue){
//        maximum = self.maxValue;
//    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    [self updateThumbPositions];
    [CATransaction commit];

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:self];
    float percentage = ((location.x - CGRectGetMinX(self.sliderLayer.frame)) - self.thumbDiameter * 0.5) / (CGRectGetMaxX(self.sliderLayer.frame) - CGRectGetMinX(self.sliderLayer.frame));
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

#pragma mark - Calculating nearest handle to point

- (float)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (CGPoint)getCentreOfRect:(CGRect)rect
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

@end
