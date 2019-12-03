//
//  SingleCircleLinkedList.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import "SingleCircleLinkedList.h"

@interface SingleCircleLinkedNode<ObjectType> : NSObject
/// 元素
@property (nonatomic, strong) ObjectType element;
/// 下一个节点
@property (nonatomic, strong) SingleCircleLinkedNode *next;

- (instancetype)initWithElement:(ObjectType)element next:(SingleCircleLinkedNode *)next;

+ (instancetype)nodeWithElement:(ObjectType)element next:(SingleCircleLinkedNode *)next;

@end

@implementation SingleCircleLinkedNode

- (instancetype)initWithElement:(id)element next:(SingleCircleLinkedNode *)next {
    if (self == [super init]) {
        self.element = element;
        self.next = next;
    }
    return self;
}

+ (instancetype)nodeWithElement:(id)element next:(SingleCircleLinkedNode *)next {
    return [[SingleCircleLinkedNode alloc]initWithElement:element next:next];
}

- (NSString *)description {
    NSMutableString *string = [[NSMutableString alloc]init];
    [string appendString:[self.element description]];
    [string appendString:@"_"];
    [string appendString:[self.next.element description]];
    return string;
}
@end

@interface SingleCircleLinkedList<ObjectType>(){
    NSUInteger size;//元素的数量
    SingleCircleLinkedNode<ObjectType> *first;
}
@end
@implementation SingleCircleLinkedList
/// 元素的数量
- (NSUInteger)size {
    return size;
}

/// 是否为空
- (BOOL)isEmpty {
    return size == 0;
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
}

/// 获取index位置的元素
/// @param index 下标
- (id)objectAtIndex:(NSUInteger)index {
    return [self nodeAtIndex:index].element;
}

/// 获取index位置的节点
/// @param index 下标
- (SingleCircleLinkedNode *)nodeAtIndex:(NSUInteger)index {
    [self rangeCheck:index];
    
    SingleCircleLinkedNode *node = first;
    for (NSUInteger i = 0; i < index; i++) {
        node = node.next;
    }
    return node;
}

/// 设置index位置的元素
/// @param anObject 元素
/// @param index 下标
- (id)setObject:(id)anObject atIndex:(NSUInteger)index {
    SingleCircleLinkedNode *node = [self nodeAtIndex:index];
    id old = node.element;
    node.element = anObject;
    return old;
}

/// 在index位置插入一个元素
/// @param anObject 元素
/// @param index 下标
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [self rangeCheckForAdd:index];
    
    if (index == 0) {
        SingleCircleLinkedNode *newFirst = [SingleCircleLinkedNode nodeWithElement:anObject next:first];
        SingleCircleLinkedNode *last = size == 0 ? newFirst : [self nodeAtIndex:size - 1];
        last.next = newFirst;
        first = newFirst;
    }else{
        SingleCircleLinkedNode *prev = [self nodeAtIndex:index - 1];
        prev.next = [SingleCircleLinkedNode nodeWithElement:anObject next:prev.next];
    }
    size++;
}

/// 删除index位置的元素
/// @param index 下标
- (id)removeObjectAtIndex:(NSUInteger)index {
    [self rangeCheck:index];
    
    SingleCircleLinkedNode *node = first;
    if (index == 0) {
        if (size == 1) {
            first = nil;
        }else{
            SingleCircleLinkedNode *last = [self nodeAtIndex:size - 1];
            first = first.next;
            last.next = first;
        }
    }else{
        SingleCircleLinkedNode *prev = [self nodeAtIndex:index - 1];
        node = prev.next;
        prev.next = node.next;
    }
    size--;
    return node.element;
}

/// 查看元素的索引
/// @param anObject 元素
- (NSUInteger)indexOfObject:(id)anObject {
    if (anObject == nil) {
        SingleCircleLinkedNode *node = first;
        for (NSUInteger i = 0; i < size; i++) {
            if (node.element == nil) {
                return i;
            }
            node = node.next;
        }
    }else{
        SingleCircleLinkedNode *node = first;
        for (NSUInteger i = 0; i < size; i++) {
            if ([node.element isEqual:anObject]) {
                return i;
            }
            node = node.next;
        }
    }
    return ELEMENT_NOT_FOUND;
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
    SingleCircleLinkedNode *node = first;
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
