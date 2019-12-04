//
//  Key.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/4.
//  Copyright © 2019 styf. All rights reserved.
//

#import "Key.h"

@implementation Key

- (instancetype)initWithValue:(NSInteger)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

+ (instancetype)keyWithValue:(NSInteger)value {
    return [[self alloc]initWithValue:value];
}

- (NSUInteger)hash {
    return _value / 10;
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (object == nil || ![object isKindOfClass:self.class]) {
        return NO;
    }
    return ((Key *)object).value == self.value;
}

- (NSComparisonResult)compare:(Key *)other {
    if (self.value > other.value) {
        return NSOrderedDescending;
    }else if (self.value < other.value) {
        return NSOrderedAscending;
    }else{
        return NSOrderedSame;
    }
}
@end
