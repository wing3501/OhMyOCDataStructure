//
//  BinaryHeap.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/4.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryTreeInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface BinaryHeap<ObjectType> : NSObject<BinaryTreeInfo>

+ (instancetype)heapWithElements:(nullable NSMutableArray *)elements comparator:(NSComparator)comparator;

/// 元素的数量
- (NSUInteger)size;

/// 是否为空
- (BOOL)isEmpty;

/// 清除所有元素
- (void)clear;

/// 添加元素
/// @param anObject 元素
- (void)addObject:(ObjectType)anObject;

/// 获得堆顶元素
- (ObjectType)get;

/// 删除堆顶元素
- (ObjectType)remove;

/// 删除堆顶元素的同时插入一个新元素
/// @param anObject 元素
- (ObjectType)replaceObject:(ObjectType)anObject;
@end

NS_ASSUME_NONNULL_END
