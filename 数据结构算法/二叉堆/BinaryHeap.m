//
//  BinaryHeap.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/4.
//  Copyright © 2019 styf. All rights reserved.
//

#import "BinaryHeap.h"

@interface BinaryHeap(){
    NSMutableArray *elements;//数组
    NSUInteger size;//有效元素个数
    NSNull *null;//占位元素
    NSUInteger currentCapacity;//当前容量
}
/// 比较器
@property (nonatomic, copy) NSComparator comparator;

@end
@implementation BinaryHeap

- (instancetype)initWithElements:(NSMutableArray *)elements size:(NSUInteger)size comparator:(NSComparator)comparator {
    self = [super init];
    if (self) {
        if (elements == nil || elements.count == 0) {
            _comparator = comparator;
            currentCapacity = 10;
            self->elements = [NSMutableArray arrayWithCapacity:currentCapacity];
            null = [NSNull null];
            [self resetArray];
        }else {
            self->size = size;
            currentCapacity = MAX(size, 10);
            self->elements = [NSMutableArray arrayWithCapacity:currentCapacity];
            for (NSUInteger i = 0; i < size; i++) {
                self->elements[i] = elements[i];
            }
            [self heapify];
        }
    }
    return self;
}

+ (instancetype)heapWithElements:(nullable NSMutableArray *)elements size:(NSUInteger)size comparator:(NSComparator)comparator {
    return [[self alloc]initWithElements:elements size:size comparator:comparator];
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
    size = 0;
}

/// 添加元素
/// @param anObject 元素
- (void)addObject:(id)anObject {
    [self elementNotNullCheck:anObject];
    [self ensureCapacity:size + 1];
    elements[size++] = anObject;
    [self siftUp:size - 1];
    
    NSLog(@"---------------------\n %@",elements);
}

/// 获得堆顶元素
- (id)get {
    [self emptyCheck];
    return elements[0];
}

/// 删除堆顶元素
- (id)remove {
    [self emptyCheck];
    
    NSUInteger lastIndex = --size;
    id root = elements[0];
    elements[0] = elements[lastIndex];
    elements[lastIndex] = null;
    [self siftDown:0];
    return root;
}

/// 删除堆顶元素的同时插入一个新元素
/// @param anObject 元素
- (id)replaceObject:(id)anObject {
    [self elementNotNullCheck:anObject];
    
    id root = nil;
    if (size == 0) {
        elements[0] = anObject;
        size++;
    }else {
        root = elements[0];
        elements[0] = anObject;
        [self siftDown:0];
    }
    return root;
}

/// 让index位置的元素下滤
/// @param index 下标
- (void)siftDown:(NSUInteger)index {
    id element = elements[index];
    NSUInteger half = size >> 1;
    // 第一个叶子节点的索引 == 非叶子节点的数量
    // index < 第一个叶子节点的索引
    // 必须保证index位置是非叶子节点
    while (index < half) {
        // index的节点有2种情况
        // 1.只有左子节点
        // 2.同时有左右子节点
        
        // 默认为左子节点跟它进行比较
        NSUInteger childIndex = (index << 1) + 1;
        id child = elements[childIndex];
        
        // 右子节点
        NSUInteger rightIndex = childIndex + 1;
        
        // 选出左右子节点最大的那个
        if (rightIndex < size && self.comparator(elements[rightIndex], child) == NSOrderedDescending) {
            childIndex = rightIndex;
            child = elements[childIndex];
        }
        
        NSComparisonResult result = self.comparator(element,child);
        if (result == NSOrderedDescending || result == NSOrderedSame) {
            break;
        }
        
        // 将子节点存放到index位置
        elements[index] = child;
        // 重新设置index
        index = childIndex;
    }
    elements[index] = element;
}

/// 让index位置的元素上滤
/// @param index 下标
- (void)siftUp:(NSUInteger)index {
    id element = elements[index];
    while (index > 0) {
        NSUInteger parentIndex = (index - 1) >> 1;
        id parent = elements[parentIndex];
        NSComparisonResult result = self.comparator(element,parent);
        if (result == NSOrderedAscending || result == NSOrderedSame) {
            break;
        }
        // 将父元素存储在index位置
        elements[index] = parent;
        // 重新赋值index
        index = parentIndex;
    }
    elements[index] = element;
}

/// 批量建堆
- (void)heapify {
    // 自下而上的下滤
    for (NSUInteger i = (size >> 1) - 1; i >= 0; i--) {
        [self siftDown:i];
    }
}

/// 重置数组
- (void)resetArray {
    for (NSUInteger i = 0; i < currentCapacity; i++) {
        [elements addObject:null];
    }
}

- (void)elementNotNullCheck:(id)element {
    if (element == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"element must not be null" userInfo:nil];
    }
}

- (void)emptyCheck{
    if (size == 0) {
        @throw [NSException exceptionWithName:NSRangeException reason:@"Heap is empty" userInfo:nil];
    }
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
        newElements[i] = elements[i];
    }
    elements = newElements;
    currentCapacity = newCapacity;
}

#pragma mark - BinaryTreeInfo
/// 返回根节点
- (id)root {
    return @0;
}

/// 返回给定节点的左节点
- (id)left:(id)node {
    NSUInteger index = ([node integerValue] << 1) + 1;
    return index >= size ? nil : @(index);
}

/// 返回给定节点的右节点
- (id)right:(id)node {
    NSUInteger index = ([node integerValue] << 1) + 2;
    return index >= size ? nil : @(index);
}

/// 节点的打印方式
- (NSString *)string:(id)node {
    return [elements[((NSNumber *)node).integerValue] description];
}
@end
