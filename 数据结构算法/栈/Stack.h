//
//  Stack.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/9.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Stack<ObjectType> : NSObject

/// 清除所有元素
- (void)clear;

/// 元素的数量
- (NSUInteger)size;

/// 是否为空
- (BOOL)isEmpty;

/// 入栈
/// @param anObject 元素
- (void)push:(ObjectType)anObject;

/// 出栈
- (ObjectType)pop;

/// 查看栈顶元素
- (ObjectType)top;
@end

NS_ASSUME_NONNULL_END
