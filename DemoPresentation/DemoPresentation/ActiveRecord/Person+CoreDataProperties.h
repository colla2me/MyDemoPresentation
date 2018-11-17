//
//  Person+CoreDataProperties.h
//  DemoPresentation
//
//  Created by Samuel on 2018/11/2.
//  Copyright © 2018年 TD-tech. All rights reserved.
//
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *job;
@property (nonatomic) int16_t age;
@property (nonatomic) BOOL sex;

@end

NS_ASSUME_NONNULL_END
