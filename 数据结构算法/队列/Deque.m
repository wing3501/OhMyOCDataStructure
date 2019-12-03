//
//  Dueue.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import "Deque.h"
#import "CircleLinkedList.h"
@interface Deque<ObjectType>(){
    CircleLinkedList *list;
}
@end
@implementation Deque

- (instancetype)init
{
    self = [super init];
    if (self) {
        list = [[CircleLinkedList alloc]init];
    }
    return self;
}

/// 元素的数量
- (NSUInteger)size {
    return list.size;
}

/// 是否为空
- (BOOL)isEmpty {
    return list.size == 0;
}

/// 清除所有元素
- (void)clear {
    [list clear];
}

/// 从队头入队
/// @param element 元素
- (void)enQueueFront:(id)element {
    [list insertObject:element atIndex:0];
}

/// 从队尾入队
/// @param element 元素
- (void)enQueueRear:(id)element {
    [list addObject:element];
}

/// 从队头出队
- (id)deQueueFront {
    return [list removeObjectAtIndex:0];
}

/// 从队尾出队
- (id)deQueueRear {
    return [list removeObjectAtIndex:list.size - 1];
}

/// 查看队头元素
- (id)front {
    return [list objectAtIndex:0];
}

/// 查看队尾元素
- (id)rear {
    return [list objectAtIndex:list.size - 1];
}

- (NSString *)description {
    return list.description;
}
@end
