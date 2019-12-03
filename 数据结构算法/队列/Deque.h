//
//  Dueue.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Deque<ObjectType> : NSObject
/// 元素的数量
- (NSUInteger)size;

/// 是否为空
- (BOOL)isEmpty;

/// 清除所有元素
- (void)clear;

/// 从队头入队
/// @param element 元素
- (void)enQueueFront:(ObjectType)element;

/// 从队尾入队
/// @param element 元素
- (void)enQueueRear:(ObjectType)element;

/// 从队头出队
- (ObjectType)deQueueFront;

/// 从队尾出队
- (ObjectType)deQueueRear;

/// 查看队头元素
- (ObjectType)front;

/// 查看队尾元素
- (ObjectType)rear;
@end

NS_ASSUME_NONNULL_END
