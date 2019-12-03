//
//  BBST.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/29.
//  Copyright © 2019 styf. All rights reserved.
//

#import "BBST.h"

@implementation BBST
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
    
    // e-f
    f.left = e;
    if (e != nil) {
        e.parent = f;
    }
    
    // b-d-f
    d.left = b;
    d.right = f;
    b.parent = d;
    f.parent = d;
}
@end
