//
//  MagicalRecord+Exception.m
//  DemoPresentation
//
//  Created by Samuel on 2018/11/2.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import "MagicalRecord+Exception.h"

@implementation MagicalRecord (Exception)

+ (void)setupCoreDataStackWithStoreNamed:(NSString *)storeName exceptionBlock:(void(^)(NSException *))exceptionBlock {
    @try {
        [MagicalRecord setupCoreDataStackWithStoreNamed:storeName];
    }
    @catch (NSException *exception) {
        exceptionBlock(exception);
    }
}

@end
