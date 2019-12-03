//
//  CircleQueue.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleQueue<ObjectType> : NSObject
/// 元素的数量
- (NSUInteger)size;

/// 是否为空
- (BOOL)isEmpty;

/// 清除所有元素
- (void)clear;

/// 入队
/// @param element 元素
- (void)enQueue:(ObjectType)element;

/// 出队
- (ObjectType)deQueue;

/// 查看队头元素
- (ObjectType)front;
@end

NS_ASSUME_NONNULL_END
