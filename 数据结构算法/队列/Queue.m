//
//  Queue.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import "Queue.h"
#import "CircleLinkedList.h"

@interface Queue<ObjectType>(){
    CircleLinkedList *list;
}
@end

@implementation Queue

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

/// 入队
/// @param element 元素
- (void)enQueue:(id)element {
    [list addObject:element];
}

/// 出队
- (id)deQueue {
    return [list removeObjectAtIndex:0];
}

/// 查看队头元素
- (id)front {
    return [list objectAtIndex:0];
}
@end
