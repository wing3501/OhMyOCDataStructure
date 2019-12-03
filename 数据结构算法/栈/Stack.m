//
//  Stack.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import "Stack.h"
@interface Stack<ObjectType>(){
    NSMutableArray<ObjectType> *array;/// 数组
}
@end
@implementation Stack

- (instancetype)init {
    self = [super init];
    if (self) {
        array = @[].mutableCopy;
    }
    return self;
}

/// 清除所有元素
- (void)clear {
    [array removeAllObjects];
}

/// 元素的数量
- (NSUInteger)size {
    return array.count;
}

/// 是否为空
- (BOOL)isEmpty {
    return array.count == 0;
}

/// 入栈
/// @param anObject 元素
- (void)push:(id)anObject {
    [array addObject:anObject];
}

/// 出栈
- (id)pop {
    id object = [array objectAtIndex:array.count - 1];
    [array removeObject:object];
    return object;
}

/// 查看栈顶元素
- (id)top {
    return [array objectAtIndex:array.count - 1];
}
@end
