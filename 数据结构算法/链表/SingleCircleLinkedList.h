//
//  SingleCircleLinkedList.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "List.h"
NS_ASSUME_NONNULL_BEGIN

@interface SingleCircleLinkedList<ObjectType> : NSObject
/// 元素的数量
- (NSUInteger)size;

/// 是否为空
- (BOOL)isEmpty;

/// 是否包含某个元素
/// @param anObject 元素
- (BOOL)containsObject:(ObjectType)anObject;

/// 添加元素到尾部
/// @param anObject 元素
- (void)addObject:(ObjectType)anObject;

/// 清除所有元素
- (void)clear;

/// 获取index位置的元素
/// @param index 下标
- (ObjectType)objectAtIndex:(NSUInteger)index;

/// 设置index位置的元素
/// @param anObject 元素
/// @param index 下标
- (ObjectType)setObject:(ObjectType)anObject atIndex:(NSUInteger)index;

/// 在index位置插入一个元素
/// @param anObject 元素
/// @param index 下标
- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

/// 删除index位置的元素
/// @param index 下标
- (ObjectType)removeObjectAtIndex:(NSUInteger)index;

/// 查看元素的索引
/// @param anObject 元素
- (NSUInteger)indexOfObject:(ObjectType)anObject;
@end

NS_ASSUME_NONNULL_END
