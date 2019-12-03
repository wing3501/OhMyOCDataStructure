//
//  ListSet.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/2.
//  Copyright © 2019 styf. All rights reserved.
//

#import "ListSet.h"
#import "CircleLinkedList.h"
@interface ListSet(){
    //链表
    CircleLinkedList *list;
}
@end

@implementation ListSet

- (instancetype)init {
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
    return list.isEmpty;
}

/// 清除所有元素
- (void)clear {
    [list clear];
}

/// 是否包含某个元素
/// @param anObject 元素
- (BOOL)containsObject:(id)anObject {
    return [list containsObject:anObject];
}

/// 添加元素
/// @param anObject 元素
- (void)addObject:(id)anObject {
    NSInteger index = [list indexOfObject:anObject];
    if (index != ELEMENT_NOT_FOUND) {// 存在就覆盖
        [list setObject:anObject atIndex:index];
    }else{
        [list addObject:anObject];
    }
}

/// 删除元素
/// @param anObject 元素
- (void)removeObject:(id)anObject {
    NSInteger index = [list indexOfObject:anObject];
    if (index != ELEMENT_NOT_FOUND) {
        [list removeObjectAtIndex:index];
    }
}

/// 遍历
/// @param visitor 遍历回调
- (void)traversal:(Visitor *)visitor {
    if (visitor == nil) return;
    NSUInteger size = list.size;
    for (NSUInteger i = 0; i < size; i++) {
        if (visitor.visitorBlock([list objectAtIndex:i])) {
            return;
        }
    }
}
@end
