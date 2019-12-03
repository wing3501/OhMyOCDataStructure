//
//  AVLTree.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/28.
//  Copyright © 2019 styf. All rights reserved.
//

#import "AVLTree.h"

@implementation AVLNode

- (instancetype)initWithElement:(id)element parent:(nullable BinaryTreeNode *)parent {
    if (self == [super init]) {
        self.element = element;
        self.parent = parent;
        self.height = 1;
    }
    return self;
}

/// 计算平衡因子
- (NSInteger)balanceFactor {
    NSInteger leftHeight = self.left == nil ? 0 : ((AVLNode *)(self.left)).height;
    NSInteger rightHeight = self.right == nil ? 0 : ((AVLNode *)(self.right)).height;
    return leftHeight - rightHeight;
}

/// 更新高度
- (void)updateHeight {
    NSInteger leftHeight = self.left == nil ? 0 : ((AVLNode *)(self.left)).height;
    NSInteger rightHeight = self.right == nil ? 0 : ((AVLNode *)(self.right)).height;
    _height = 1 + MAX(leftHeight, rightHeight);
}

/// 返回更高的子节点
- (BinaryTreeNode *)tallerChild {
    NSInteger leftHeight = self.left == nil ? 0 : ((AVLNode *)(self.left)).height;
    NSInteger rightHeight = self.right == nil ? 0 : ((AVLNode *)(self.right)).height;
    if (leftHeight > rightHeight) return self.left;
    if (leftHeight < rightHeight) return self.right;
    return [self isLeftChild] ? self.left : self.right;
}

- (NSString *)description {
    NSString *parentString = @"null";
    if (self.parent != nil) {
        parentString = [self.parent.element description];
    }
    return [NSString stringWithFormat:@"%@_p(%@)_h(%ld)",self.element,parentString,(long)_height];
}

@end

@implementation AVLTree

/// 创建节点 子类重写
/// @param element 元素
/// @param parent 父节点
- (BinaryTreeNode *)createNode:(id)element parent:(BinaryTreeNode *)parent {
    return [AVLNode nodeWithElement:element parent:parent];
}

/// 新添加节点之后的处理 子类重写
/// @param node 节点
- (void)afterAdd:(BinaryTreeNode *)node {
    NSLog(@"===========>%@",node.element);
    node = node.parent;
    while (node != nil) {
        if ([self isBalanced:node]) {
            // 更新高度
            [self updateHeight:node];
        }else{
            // 恢复平衡
            [self rebalance:node];
            // 整棵树恢复平衡
            break;
        }
        node = node.parent;
    }
}

/// 删除节点之后的处理 子类重写
/// @param node 节点
- (void)afterRemove:(BinaryTreeNode *)node {
    node = node.parent;
    while (node != nil) {
        if ([self isBalanced:node]) {
            // 更新高度
            [self updateHeight:node];
        }else{
            // 恢复平衡
            [self rebalance:node];
            // 整棵树恢复平衡
        }
        node = node.parent;
    }
}

/// 节点是否平衡
/// @param node 节点
- (BOOL)isBalanced:(BinaryTreeNode *)node {
    return labs([(AVLNode *)node balanceFactor]) <= 1;
}

/// 更新节点高度
/// @param node 节点
- (void)updateHeight:(BinaryTreeNode *)node {
    [(AVLNode *)node updateHeight];
}


/**
 * 恢复平衡
 * @param grand 高度最低的那个不平衡节点
 */
- (void)rebalance:(BinaryTreeNode *)grand {
    AVLNode *parent = (AVLNode *)[((AVLNode *)grand) tallerChild];
    AVLNode *node = (AVLNode *)[((AVLNode *)parent) tallerChild];
    if ([parent isLeftChild]) { // L
        if ([node isLeftChild]) { // LL
            [self rotate:grand b:node c:node.right d:parent e:parent.right f:grand];
        } else { // LR
            [self rotate:grand b:parent c:node.left d:node e:parent.right f:grand];
        }
    } else { // R
        if ([node isLeftChild]) { // RL
            [self rotate:grand b:grand c:node.left d:node e:node.right f:parent];
        } else { // RR
            [self rotate:grand b:grand c:parent.left d:parent e:node.left f:node];
        }
    }
}

- (void)rotate:(BinaryTreeNode *)r b:(BinaryTreeNode *)b  c:(BinaryTreeNode *)c  d:(BinaryTreeNode *)d e:(BinaryTreeNode *)e f:(BinaryTreeNode *)f{
    // 让d成为这棵子树的根节点
    d.parent = r.parent;
    if ([r isLeftChild]) {
        r.parent.left = d;
    } else if ([r isRightChild]) {
        r.parent.right = d;
    } else {
        root = d;
    }
    
    //b-c
    b.right = c;
    if (c != nil) {
        c.parent = b;
    }
    [self updateHeight:b];
    
    // e-f
    f.left = e;
    if (e != nil) {
        e.parent = f;
    }
    [self updateHeight:f];
    
    // b-d-f
    d.left = b;
    d.right = f;
    b.parent = d;
    f.parent = d;
    [self updateHeight:d];
}





/// 恢复平衡
/// @param grand 高度最低的那个不平衡节点
- (void)rebalance2:(BinaryTreeNode *)grand {
    AVLNode *parent = (AVLNode *)[((AVLNode *)grand) tallerChild];
    AVLNode *node = (AVLNode *)[((AVLNode *)parent) tallerChild];
    if ([parent isLeftChild]) { // L
        if ([node isLeftChild]) { // LL
            [self rotateRight:grand];
        } else { // LR
            [self rotateLeft:parent];
            [self rotateRight:grand];
        }
    } else { // R
        if ([node isLeftChild]) { // RL
            [self rotateRight:parent];
            [self rotateLeft:grand];
        } else { // RR
            [self rotateLeft:grand];
        }
    }
}

/// 左旋转
/// @param grand 节点
- (void)rotateLeft:(BinaryTreeNode *)grand {
    BinaryTreeNode *parent = grand.right;
    BinaryTreeNode *child = parent.left;
    grand.right = child;
    parent.left = grand;
    [self afterRotate:grand parent:parent child:child];
}

/// 右旋转
/// @param grand 节点
- (void)rotateRight:(BinaryTreeNode *)grand {
    BinaryTreeNode *parent = grand.left;
    BinaryTreeNode *child = parent.right;
    grand.left = child;
    parent.right = grand;
    [self afterRotate:grand parent:parent child:child];
}

/// 旋转后的操作
/// @param grand 祖父节点
/// @param parent 父节点
/// @param child 子节点
- (void)afterRotate:(BinaryTreeNode *)grand parent:(BinaryTreeNode *)parent child:(BinaryTreeNode *)child {
    // 让parent称为子树的根节点
    parent.parent = grand.parent;
    if ([grand isLeftChild]) {
        grand.parent.left = parent;
    } else if ([grand isRightChild]) {
        grand.parent.right = parent;
    } else { // grand是root节点
        root = parent;
    }
    
    // 更新child的parent
    if (child != nil) {
        child.parent = grand;
    }
    
    // 更新grand的parent
    grand.parent = parent;
    
    // 更新高度
    [self updateHeight:grand];
    [self updateHeight:parent];
}
@end
