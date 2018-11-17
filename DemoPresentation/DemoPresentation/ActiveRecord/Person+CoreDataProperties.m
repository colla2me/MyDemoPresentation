//
//  Person+CoreDataProperties.m
//  DemoPresentation
//
//  Created by Samuel on 2018/11/2.
//  Copyright © 2018年 TD-tech. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Person"];
}

@dynamic name;
@dynamic job;
@dynamic age;
@dynamic sex;

@end
