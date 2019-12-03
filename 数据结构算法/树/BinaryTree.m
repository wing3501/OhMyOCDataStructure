//
//  BinaryTree.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/22.
//  Copyright © 2019 styf. All rights reserved.
//

#import "BinaryTree.h"
#import "Queue.h"

@implementation BinaryTreeNode

- (instancetype)initWithElement:(id)element parent:(nullable BinaryTreeNode *)parent {
    if (self == [super init]) {
        self.element = element;
        self.parent = parent;
    }
    return self;
}

+ (instancetype)nodeWithElement:(id)element parent:(nullable BinaryTreeNode *)parent {
    return [[self alloc] initWithElement:element parent:parent];
}

/// 是否是叶子节点
- (BOOL)isLeaf {
    return self.left == nil && self.right == nil;
}

/// 是否有左右子树
- (BOOL)hasTwoChildren {
    return self.left != nil && self.right != nil;
}

/// 是否是父节点的左子树节点
- (BOOL)isLeftChild {
    return self.parent != nil && [self isEqual:self.parent.left];
}

/// 是否是父节点的右子树节点
- (BOOL)isRightChild {
    return self.parent != nil && [self isEqual:self.parent.right];
}

/// 返回叔父节点
- (BinaryTreeNode *)sibling {
    if ([self isLeftChild]) {
        return self.parent.right;
    }
    if ([self isRightChild]) {
        return self.parent.left;
    }
    return nil;
}

- (NSString *)description {
    NSString *parentString = @"null";
    if (self.parent != nil) {
        parentString = [self.parent.element description];
    }
    return [NSString stringWithFormat:@"%@_p(%@)",self.element,parentString];
}
@end

@implementation BinaryTree

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
    root = nil;
    size = 0;
}

/// 前序遍历
/// @param visitor 遍历回调
- (void)preorder:(Visitor *)visitor {
    if (visitor == nil) return;
    [self preorder:root visitor:visitor];
}

/// 前序遍历
/// @param node 当前节点
/// @param visitor 遍历回调
- (void)preorder:(BinaryTreeNode *)node visitor:(Visitor *)visitor {
    if (node == nil || visitor.stop) return;
    
    visitor.stop = visitor.visitorBlock(node.element);
    [self preorder:node.left visitor:visitor];
    [self preorder:node.right visitor:visitor];
}

/// 中序遍历
/// @param visitor 遍历回调
- (void)inorder:(Visitor *)visitor {
    if (visitor == nil) return;
    [self inorder:root visitor:visitor];
}

/// 中序遍历
/// @param node 当前节点
/// @param visitor 遍历回调
- (void)inorder:(BinaryTreeNode *)node visitor:(Visitor *)visitor {
    if (node == nil || visitor.stop) return;
    
    [self inorder:node.left visitor:visitor];
    if (visitor.stop) return;
    visitor.stop = visitor.visitorBlock(node.element);
    [self inorder:node.right visitor:visitor];
}

/// 后序遍历
/// @param visitor 遍历回调
- (void)postorder:(Visitor *)visitor {
    if (visitor == nil) return;
    [self postorder:root visitor:visitor];
}

/// 后序遍历
/// @param node 当前节点
/// @param visitor 遍历回调
- (void)postorder:(BinaryTreeNode *)node visitor:(Visitor *)visitor {
    if (node == nil || visitor.stop) return;
    
    [self postorder:node.left visitor:visitor];
    [self postorder:node.right visitor:visitor];
    if (visitor.stop) return;
    visitor.stop = visitor.visitorBlock(node.element);
}

/// 层序遍历
/// @param visitor 遍历回调
- (void)levelOrder:(Visitor *)visitor {
    if (root == nil || visitor == nil) return;
    
    Queue<BinaryTreeNode *> *queue = [[Queue alloc]init];
    [queue enQueue:root];
    
    while (!queue.isEmpty) {
        BinaryTreeNode *node = [queue deQueue];
        NSLog(@"%@[%@,%@]",node.element,node.left.element,node.right.element);
        if (visitor.visitorBlock(node.element)) return;
        
        if (node.left != nil) {
            [queue enQueue:node.left];
        }
        if (node.right != nil) {
            [queue enQueue:node.right];
        }
    }
}

/// 是否是完全二叉树
- (BOOL)isComplete {
    if (root == nil) {
        return NO;
    }
    Queue<BinaryTreeNode *> *queue = [[Queue alloc]init];
    [queue enQueue:root];
    
    BOOL leaf = NO;//之后的节点是否都是叶子节点
    while (!queue.isEmpty) {
        BinaryTreeNode *node = [queue deQueue];
        if (leaf && ![node isLeaf]) {
            return NO;
        }
        
        if (node.left != nil) {
            [queue enQueue:node.left];
        }else if (node.right != nil){
            //只有右子树节点
            return NO;
        }
        
        if (node.right != nil) {
            [queue enQueue:node.right];
        }else{
            //有左子树无右子树，那么之后的节点都是叶子节点
            leaf = YES;
        }
    }
    return YES;
}

/// 树的高度
- (NSUInteger)height {
    if (root == nil) {
        return 0;
    }
    NSUInteger height = 0;//树的高度
    NSUInteger levelSize = 1;//每一层元素的数量
    Queue<BinaryTreeNode *> *queue = [[Queue alloc]init];
    [queue enQueue:root];
    
    while (!queue.isEmpty) {
        BinaryTreeNode *node = [queue deQueue];
        levelSize--;
        if (node.left != nil) {
            [queue enQueue:node.left];
        }
        if (node.right != nil) {
            [queue enQueue:node.right];
        }
        
        if (levelSize == 0) {//意味着要访问下一层
            levelSize = queue.size;
            height++;
        }
    }
    return height;
}

/// 某个节点的高度
/// @param node 节点
- (NSUInteger)heightForNode:(BinaryTreeNode *)node {
    if (node == nil) {
        return 0;
    }
    return 1 + MAX([self heightForNode:node.left], [self heightForNode:node.right]);
}

/// 查找某个节点的前驱节点
/// @param node 节点
- (BinaryTreeNode *)predecessor:(BinaryTreeNode *)node {
    if (node == nil) {
        return nil;
    }
    // 前驱节点在左子树当中（left.right.right.right....）
    BinaryTreeNode *p = node.left;
    if (p != nil) {
        while (p.right != nil) {
            p = p.right;
        }
        return p;
    }
    
    // 从父节点、祖父节点中寻找前驱节点
    while (node.parent != nil && node == node.parent.left) {
        node = node.parent;
    }
    
    // node.parent == null
    // node == node.parent.right
    return node.parent;
}

/// 查找某个节点的后继节点
/// @param node 节点
- (BinaryTreeNode *)successor:(BinaryTreeNode *)node {
    if (node == nil) {
        return nil;
    }
    
    BinaryTreeNode *p = node.right;
    if (p != nil) {
        while (p.left != nil) {
            p = p.left;
        }
        return p;
    }
    
    // 从父节点、祖父节点中寻找前驱节点
    while (node.parent != nil && node == node.parent.right) {
        node = node.parent;
    }
    
    return node.parent;
}

/// 创建节点 子类重写
/// @param element 元素
/// @param parent 父节点
- (BinaryTreeNode *)createNode:(id)element parent:( BinaryTreeNode * _Nullable)parent {
    return [BinaryTreeNode nodeWithElement:element parent:parent];
}

#pragma mark - BinaryTreeInfo

/// 返回根节点
- (id)root {
    return root;
}

/// 返回给定节点的左节点
- (id)left:(id)node {
    return ((BinaryTreeNode *)node).left;
}

/// 返回给定节点的右节点
- (id)right:(id)node {
    return ((BinaryTreeNode *)node).right;
}

/// 节点的打印方式
- (NSString *)string:(id)node {
    return [node description];
}
@end
