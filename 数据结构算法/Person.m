//
//  Person.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/5.
//  Copyright © 2019 styf. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)name boneBreak:(NSUInteger)boneBreak
{
    self = [super init];
    if (self) {
        _name = name;
        _boneBreak = boneBreak;
    }
    return self;
}

+ (instancetype)personWithName:(NSString *)name boneBreak:(NSUInteger)boneBreak {
    return [[self alloc]initWithName:name boneBreak:boneBreak];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Person [name=%@,boneBreak=%ld]", _name,_boneBreak];
}
@end
