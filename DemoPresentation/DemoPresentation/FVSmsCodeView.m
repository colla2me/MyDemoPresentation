//
//  FVSmsCodeView.m
//  FoodVan
//
//  Created by Samuel Cheung on 2018/7/21.
//  Copyright © 2018年 30days. All rights reserved.
//

#import "FVSmsCodeView.h"
#import "FVTextField.h"
#import "Masonry.h"

@interface FVSmsCodeView () <FVTextFieldDelegate>
@property (copy, nonatomic) NSArray<FVTextField *> *textFields;
@end

@implementation FVSmsCodeView

static const NSUInteger FVTagBase = 1000;

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
    self.backgroundColor = [UIColor whiteColor];

    NSMutableArray<FVTextField *> *array = [NSMutableArray arrayWithCapacity:6];
    for (int i = 0; i < 6; i++) {
        FVTextField *textField = [[FVTextField alloc] init];
        textField.selected = (0 == i);
        textField.smsDelegate = self;
        textField.tag = FVTagBase + i;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [array addObject:textField];
    }
    
    self.textFields = [array copy];
    
    UIStackView *codeStack = [[UIStackView alloc] initWithArrangedSubviews:self.textFields];
    codeStack.spacing = 15;
    codeStack.axis = UILayoutConstraintAxisHorizontal;
    codeStack.distribution = UIStackViewDistributionEqualSpacing;
    codeStack.alignment = UIStackViewAlignmentCenter;
    [self addSubview:codeStack];
    [codeStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.textFields[0] becomeFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)sender {
    NSInteger index = sender.tag - FVTagBase;
    NSString *code = sender.text;
    if (code && code.length > 1) {
        code = [code substringFromIndex:code.length - 1];
        sender.text = code;
    }

    if (self.completion) {
        NSString *smsCode = self.smsCodeText;
        if (smsCode.length == 6) {
            self.completion(smsCode);
            [sender resignFirstResponder];
        }
    }
    
    if (index == 5) return;
    
    if (code && code.length == 1) {
        FVTextField *textField = self.textFields[index + 1];
        textField.selected = YES;
        [textField becomeFirstResponder];
    }
}

- (NSString *)smsCodeText {
    NSString *smsCodes = @"";
    for (UITextView *textField in self.textFields) {
        NSString *code = textField.text;
        if (code.length == 0) {
            smsCodes = @"";
            break;
        }
        smsCodes = [smsCodes stringByAppendingString:code];
    }
    return smsCodes;
}

#pragma mark - FVTextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger index = textField.tag - FVTagBase;
    if (textField.text.length > 0 && index < 5) return NO;
    return YES;
}

- (void)textFieldDeleteBackward:(UITextField *)textField {
    NSInteger index = textField.tag - FVTagBase;
    if (index == 0) {
        return;
    }
    
    if (textField.text.length > 0) {
        textField.text = nil;
        return;
    }
    
    textField.text = nil;
    textField.selected = NO;
    FVTextField *lastField = self.textFields[index - 1];
    lastField.text = nil;
    lastField.selected = YES;
    [lastField becomeFirstResponder];
}

@end
