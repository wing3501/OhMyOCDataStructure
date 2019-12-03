//
//  BinarySearchTree.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/28.
//  Copyright © 2019 styf. All rights reserved.
//

#import "BinaryTree.h"

NS_ASSUME_NONNULL_BEGIN

@interface BinarySearchTree<ObjectType> : BinaryTree<ObjectType>
+ (instancetype)treeWithComparator:(NSComparator)comparator;

/// 添加元素
/// @param element 元素
- (void)add:(ObjectType)element;

/// 删除元素
/// @param element 元素
- (void)remove:(ObjectType)element;

/// 新添加节点之后的处理 子类重写
/// @param node 节点
- (void)afterAdd:(BinaryTreeNode *)node;

/// 删除节点之后的处理 子类重写
/// @param node 节点
- (void)afterRemove:(BinaryTreeNode *)node;

/// 是否包含元素
/// @param element 元素
- (BOOL)contains:(ObjectType)element;
@end

NS_ASSUME_NONNULL_END
