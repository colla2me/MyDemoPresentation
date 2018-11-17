//
//  MagicalRecord+Exception.h
//  DemoPresentation
//
//  Created by Samuel on 2018/11/2.
//  Copyright © 2018年 TD-tech. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>

@interface MagicalRecord (Exception)

+ (void)setupCoreDataStackWithStoreNamed:(NSString *)storeName exceptionBlock:(void(^)(NSException *))exceptionBlock;

@end
