//
//  ListSet.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/2.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Visitor.h"
NS_ASSUME_NONNULL_BEGIN

@interface ListSet<ObjectType> : NSObject
/// 元素的数量
- (NSUInteger)size;

/// 是否为空
- (BOOL)isEmpty;

/// 清除所有元素
- (void)clear;

/// 是否包含某个元素
/// @param anObject 元素
- (BOOL)containsObject:(ObjectType)anObject;

/// 添加元素
/// @param anObject 元素
- (void)addObject:(ObjectType)anObject;

/// 删除元素
/// @param anObject 元素
- (void)removeObject:(ObjectType)anObject;

/// 遍历
/// @param visitor 遍历回调
- (void)traversal:(Visitor *)visitor;
@end

NS_ASSUME_NONNULL_END
