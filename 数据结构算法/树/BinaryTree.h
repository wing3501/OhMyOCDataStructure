//
//  BinaryTree.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/22.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryTreeInfo.h"
#import "Visitor.h"
NS_ASSUME_NONNULL_BEGIN

@interface BinaryTreeNode<ObjectType> : NSObject
/// 元素
@property (nonatomic, strong) ObjectType element;
/// 左子树节点
@property (nonatomic, strong, nullable) BinaryTreeNode<ObjectType> *left;
/// 右子树节点
@property (nonatomic, strong, nullable) BinaryTreeNode<ObjectType> *right;
/// 父节点
@property (nonatomic, strong, nullable) BinaryTreeNode<ObjectType> *parent;

- (instancetype)initWithElement:(ObjectType)element parent:(nullable BinaryTreeNode<ObjectType> *)parent;

+ (instancetype)nodeWithElement:(ObjectType)element parent:(nullable BinaryTreeNode<ObjectType> *)parent;

/// 是否是叶子节点
- (BOOL)isLeaf;

/// 是否有左右子树
- (BOOL)hasTwoChildren;

/// 是否是父节点的左子树节点
- (BOOL)isLeftChild;

/// 是否是父节点的右子树节点
- (BOOL)isRightChild;

/// 返回叔父节点
- (BinaryTreeNode *)sibling;
@end
@interface BinaryTree<ObjectType> : NSObject<BinaryTreeInfo> {
    BinaryTreeNode<ObjectType> *root;//根节点
    NSUInteger size;//元素的数量
}

/// 元素的数量
- (NSUInteger)size;

/// 是否为空
- (BOOL)isEmpty;

/// 清除所有元素
- (void)clear;

/// 前序遍历
/// @param visitor 遍历回调
- (void)preorder:(Visitor *)visitor;

/// 中序遍历
/// @param visitor 遍历回调
- (void)inorder:(Visitor *)visitor;

/// 后序遍历
/// @param visitor 遍历回调
- (void)postorder:(Visitor *)visitor;

/// 层序遍历
/// @param visitor 遍历回调
- (void)levelOrder:(Visitor *)visitor;

/// 是否是完全二叉树
- (BOOL)isComplete;

/// 树的高度
- (NSUInteger)height;

/// 查找某个节点的前驱节点
/// @param node 节点
- (BinaryTreeNode *)predecessor:(BinaryTreeNode *)node;

/// 查找某个节点的后继节点
/// @param node 节点
- (BinaryTreeNode *)successor:(BinaryTreeNode *)node;

/// 创建节点 子类重写
/// @param element 元素
/// @param parent 父节点
- (BinaryTreeNode *)createNode:(ObjectType)element parent:(BinaryTreeNode * _Nullable)parent;
@end

NS_ASSUME_NONNULL_END
