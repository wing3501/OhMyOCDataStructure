//
//  CircleDueue.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/13.
//  Copyright © 2019 styf. All rights reserved.
//

#import "CircleDeque.h"
@interface CircleDeque(){
    NSMutableArray *elements;//数组
    NSUInteger front;//队头下标
    NSUInteger size;//有效元素个数
    NSNull *null;//占位元素
    NSUInteger currentCapacity;//当前容量
}
@end

@implementation CircleDeque

- (instancetype)init {
    self = [super init];
    if (self) {
        currentCapacity = 10;
        elements = [NSMutableArray arrayWithCapacity:currentCapacity];
        null = [NSNull null];
        for (NSUInteger i = 0; i < currentCapacity; i++) {
            [elements addObject:null];
        }
    }
    return self;
}

/// 元素的数量
- (NSUInteger)size {
    return size;
}

/// 是否为空
- (BOOL)isEmpty {
    return size == 0;
}

/// 清除所有元素
- (void)clear {
    for (NSUInteger i = 0; i < size; i++) {
        elements[i] = null;
    }
    front = 0;
    size = 0;
}

/// 从队头入队
/// @param element 元素
- (void)enQueueFront:(id)element {
    [self ensureCapacity:size + 1];
    front = [self index:-1];
    elements[front] = element;
    size++;
}

/// 从队尾入队
/// @param element 元素
- (void)enQueueRear:(id)element {
    [self ensureCapacity:size + 1];
    elements[[self index:size]] = element;
    size++;
}

/// 从队头出队
- (id)deQueueFront {
    id frontElement = elements[front];
    elements[front] = null;
    front = [self index:1];
    size--;
    return frontElement;
}

/// 从队尾出队
- (id)deQueueRear {
    NSUInteger rearIndex = [self index:size - 1];
    id rear = elements[rearIndex];
    elements[rearIndex] = null;
    size--;
    return rear;
}

/// 查看队头元素
- (id)front {
    return elements[front];
}

/// 查看队尾元素
- (id)rear {
    return elements[[self index:size - 1]];
}

/// 把下标转换成真实位置下标
/// @param index 下标
- (NSUInteger)index:(NSInteger)index {
    index += front;
    if (index < 0) {
        return index + currentCapacity;
    }
    return index - (index >= currentCapacity ? currentCapacity : 0);
}

/// 保证要有capacity的容量
/// @param capacity 容量
- (void)ensureCapacity:(NSUInteger)capacity {
    if (currentCapacity >= capacity) {
        return;
    }
    //扩容1.5倍
    NSUInteger newCapacity = currentCapacity + (currentCapacity >> 1);
    NSMutableArray *newElements = [NSMutableArray arrayWithCapacity:newCapacity];
    for (NSUInteger i = 0; i < newCapacity; i++) {
        [newElements addObject:null];
    }
    for (NSUInteger i = 0; i < size; i++) {
        newElements[i] = elements[[self index:i]];
    }
    elements = newElements;
    currentCapacity = newCapacity;
    // 重置front
    front = 0;
}

- (NSString *)description {
    return [elements description];
}
@end
