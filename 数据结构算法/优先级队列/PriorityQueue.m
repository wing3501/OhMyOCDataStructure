//
//  PriorityQueue.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/5.
//  Copyright © 2019 styf. All rights reserved.
//

#import "PriorityQueue.h"
#import "BinaryHeap.h"
@interface PriorityQueue(){
    BinaryHeap *heap;
}
@end
@implementation PriorityQueue

- (instancetype)initWithComparator:(NSComparator)comparator {
    self = [super init];
    if (self) {
        heap = [BinaryHeap heapWithElements:nil comparator:comparator];
    }
    return self;
}

+ (instancetype)queueWithComparator:(NSComparator)comparator {
    return [[self alloc]initWithComparator:comparator];
}

/// 元素的数量
- (NSUInteger)size {
    return heap.size;
}

/// 是否为空
- (BOOL)isEmpty {
    return heap.isEmpty;
}

/// 清除所有元素
- (void)clear {
    [heap clear];
}

/// 入队
/// @param element 元素
- (void)enQueue:(id)element {
    [heap addObject:element];
}

/// 出队
- (id)deQueue {
    return [heap remove];
}

/// 查看队头元素
- (id)front {
    return [heap get];
}
@end
