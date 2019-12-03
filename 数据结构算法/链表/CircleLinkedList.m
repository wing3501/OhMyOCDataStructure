//
//  CircleLinkedList.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import "CircleLinkedList.h"
@interface CircleLinkedNode<ObjectType> : NSObject
/// 元素
@property (nonatomic, strong) ObjectType element;
/// 上一个节点
@property (nonatomic, strong) CircleLinkedNode *prev;
/// 下一个节点
@property (nonatomic, strong) CircleLinkedNode *next;

- (instancetype)initWithElement:(ObjectType)element prev:(CircleLinkedNode *)prev  next:(CircleLinkedNode *)next;

+ (instancetype)nodeWithElement:(ObjectType)element prev:(CircleLinkedNode *)prev  next:(CircleLinkedNode *)next;

@end

@implementation CircleLinkedNode

- (instancetype)initWithElement:(id)element prev:(CircleLinkedNode *)prev next:(CircleLinkedNode *)next {
    if (self == [super init]) {
        self.element = element;
        self.prev = prev;
        self.next = next;
    }
    return self;
}

+ (instancetype)nodeWithElement:(id)element prev:(CircleLinkedNode *)prev next:(CircleLinkedNode *)next {
    return [[CircleLinkedNode alloc]initWithElement:element prev:prev next:next];
}

- (NSString *)description {
    NSMutableString *string = [[NSMutableString alloc]init];
    [string appendString:[self.prev.element description]];
    [string appendString:@"_"];
    [string appendString:[self.element description]];
    [string appendString:@"_"];
    [string appendString:[self.next.element description]];
    return string;
}
@end

@interface CircleLinkedList<ObjectType>(){
    NSUInteger size;//元素的数量
    CircleLinkedNode<ObjectType> *first;//首节点
    CircleLinkedNode<ObjectType> *last;//尾节点
    CircleLinkedNode<ObjectType> *current;//当前节点
}
@end
@implementation CircleLinkedList

/// 重置当前节点
- (void)reset {
    current = first;
}

/// 元素的数量
- (NSUInteger)size {
    return size;
}

/// 是否为空
- (BOOL)isEmpty {
    return size == 0;
}

/// 前进到下一个节点
- (id)next {
    if (current == nil) {
        return nil;
    }
    current = current.next;
    return current.element;
}

/// 删除当前节点
- (id)remove {
    if (current == nil) {
        return nil;
    }
    CircleLinkedNode *next = current.next;
    id element = [self removeNode:current];
    if (size == 0) {
        current = nil;
    }else{
        current = next;
    }
    return element;
}

/// 删除index位置的元素
/// @param index 下标
- (id)removeObjectAtIndex:(NSUInteger)index {
    [self rangeCheck:index];
    return [self removeNode:[self nodeAtIndex:index]];
}

/// 删除节点
/// @param node 节点
- (id)removeNode:(CircleLinkedNode *)node {
    if (size == 1) {
        //只有一个节点
        first = nil;
        last = nil;
    }else{
        CircleLinkedNode *prev = node.prev;
        CircleLinkedNode *next = node.next;
        prev.next = next;
        next.prev = prev;
        
        if (node == first) {
            //删除的是首节点
            first = next;
        }
        if (node == last) {
            //删除的是尾节点
            last = prev;
        }
    }
    size--;
    return node.element;
}

/// 查看元素的索引
/// @param anObject 元素
- (NSUInteger)indexOfObject:(id)anObject {
    if (anObject == nil) {
        CircleLinkedNode *node = first;
        for (NSUInteger i = 0; i < size; i++) {
            if (node.element == nil) {
                return i;
            }
            node = node.next;
        }
    }else{
        CircleLinkedNode *node = first;
        for (NSUInteger i = 0; i < size; i++) {
            if ([node.element isEqual:anObject]) {
                return i;
            }
            node = node.next;
        }
    }
    return ELEMENT_NOT_FOUND;
}

/// 获取index位置的节点
/// @param index 下标
- (CircleLinkedNode *)nodeAtIndex:(NSUInteger)index {
    [self rangeCheck:index];
    //从头节点或者尾节点开始查找
    if (index < (size >> 1)) {
        CircleLinkedNode *node = first;
        for (NSUInteger i = 0; i < index; i++) {
            node = node.next;
        }
        return node;
    }else{
        CircleLinkedNode *node = last;
        for (NSUInteger i = size - 1; i > index; i--) {
            node = node.prev;
        }
        return node;
    }
}

/// 是否包含某个元素
/// @param anObject 元素
- (BOOL)containsObject:(id)anObject {
    return [self indexOfObject:anObject];
}

/// 添加元素到尾部
/// @param anObject 元素
- (void)addObject:(id)anObject {
    [self insertObject:anObject atIndex:size];
}

/// 清除所有元素
- (void)clear {
    size = 0;
    first = nil;
    last = nil;
    current = nil;
}

/// 获取index位置的元素
/// @param index 下标
- (id)objectAtIndex:(NSUInteger)index {
    return [self nodeAtIndex:index].element;
}

/// 设置index位置的元素
/// @param anObject 元素
/// @param index 下标
- (id)setObject:(id)anObject atIndex:(NSUInteger)index {
    CircleLinkedNode *node = [self nodeAtIndex:index];
    id old = node.element;
    node.element = anObject;
    return old;
}

/// 在index位置插入一个元素
/// @param anObject 元素
/// @param index 下标
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [self rangeCheckForAdd:index];
    // size == 0
    // index == 0
    if (index == size) {
        //往最后面添加元素
        CircleLinkedNode *oldLast = last;
        last = [CircleLinkedNode nodeWithElement:anObject prev:last next:first];
        if (oldLast == nil) {
            //这是链表添加的第一个元素
            first = last;
            first.next = last;
            first.prev = last;
        }else{
            oldLast.next = last;
            first.prev = last;
        }
    }else{
        CircleLinkedNode *next = [self nodeAtIndex:index];
        CircleLinkedNode *prev = next.prev;
        CircleLinkedNode *node = [CircleLinkedNode nodeWithElement:anObject prev:prev next:next];
        next.prev = node;
        prev.next = node;
        if (next == first) {// index == 0
            first = node;
        }
    }
    size++;
}

/// 下标越界
/// @param index 下标
- (void)outOfBounds:(NSUInteger)index {
    @throw [NSException exceptionWithName:NSRangeException reason:[NSString stringWithFormat:@"out Of Bounds,Index:%ld,Size:%ld",index,size] userInfo:nil];
}

/// 检查是否越界
/// @param index 下标
- (void)rangeCheck:(NSUInteger)index {
    if (index < 0 || index > size) {
        [self outOfBounds:index];
    }
}

/// 添加时检查是否越界
/// @param index 下标
- (void)rangeCheckForAdd:(NSUInteger)index {
    if (index < 0 || index > size) {
        [self outOfBounds:index];
    }
}

- (NSString *)description {
    NSMutableString *string = [[NSMutableString alloc]init];
    [string appendFormat:@"size=%ld,[",size];
    CircleLinkedNode *node = first;
    for (NSUInteger i = 0; i < size; i++) {
        if (i != 0) {
            [string appendString:@","];
        }
        [string appendString:[node.element description]];
        node = node.next;
    }
    [string appendString:@"]"];
    return string;
}
@end
