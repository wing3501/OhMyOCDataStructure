//
//  BBST.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/29.
//  Copyright © 2019 styf. All rights reserved.
//

#import "BinarySearchTree.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBST : BinarySearchTree
/// 左旋转
/// @param grand 节点
- (void)rotateLeft:(BinaryTreeNode *)grand;

/// 右旋转
/// @param grand 节点
- (void)rotateRight:(BinaryTreeNode *)grand;

/// 旋转后的操作
/// @param grand 祖父节点
/// @param parent 父节点
/// @param child 子节点
- (void)afterRotate:(BinaryTreeNode *)grand parent:(BinaryTreeNode *)parent child:(BinaryTreeNode *)child;
@end

NS_ASSUME_NONNULL_END
