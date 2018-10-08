//
//  FVSmsCodeView.h
//  FoodVan
//
//  Created by Samuel Cheung on 2018/7/21.
//  Copyright © 2018年 30days. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SmsCodeCompletion)(NSString *smsCode);

@interface FVSmsCodeView : UIView

@property (nonatomic, copy, readonly) NSString *smsCodeText;

@property (nonatomic, copy) SmsCodeCompletion completion;

@end
