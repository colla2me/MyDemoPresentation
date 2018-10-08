//
//  FVTextField.m
//  FoodVan
//
//  Created by Samuel Cheung on 2018/7/21.
//  Copyright © 2018年 30days. All rights reserved.
//

#import "FVTextField.h"

#ifndef RGBA//(r,g,b,a)
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]
#endif

@implementation FVTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 1;
    self.backgroundColor = [UIColor whiteColor];
    self.borderStyle = UITextBorderStyleNone;
    self.keyboardType = UIKeyboardTypePhonePad;
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = RGBA(102, 102, 102, 1);
    self.tintColor = RGBA(255, 117, 24, 1);
    self.font = [UIFont systemFontOfSize:17];
    self.background = nil;
    self.disabledBackground = nil;
}

- (void)deleteBackward {
    if (_smsDelegate && [_smsDelegate respondsToSelector:@selector(textFieldDeleteBackward:)]) {
        [_smsDelegate textFieldDeleteBackward:self];
    }
    [super deleteBackward];
}

- (void)setSelected:(BOOL)selected {
    self.enabled = selected;
    if (selected) {
        self.layer.borderColor = RGBA(255, 117, 24, 1).CGColor;
    } else {
        self.layer.borderColor = RGBA(216, 216, 216, 1).CGColor;
    }
    [super setSelected:selected];
}

- (void)setSmsDelegate:(id<FVTextFieldDelegate>)smsDelegate {
    _smsDelegate = smsDelegate;
    self.delegate = smsDelegate;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(30, 40);
}

@end
