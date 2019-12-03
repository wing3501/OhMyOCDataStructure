//
//  RBTree.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/29.
//  Copyright © 2019 styf. All rights reserved.
//

#import "RBTree.h"

static BOOL const RED = NO;
static BOOL const BLACK = YES;

@implementation RBNode

- (instancetype)initWithElement:(id)element parent:(nullable BinaryTreeNode *)parent {
    if (self == [super initWithElement:element parent:parent]) {
        self.color = RED;
    }
    return self;
}

- (NSString *)description {
    NSMutableString *str = [[NSMutableString alloc]initWithString:@""];
    if (self.color == RED) {
        [str appendString:@"R_"];
    }
    [str appendString:[self.element description]];
    return str;
}

@end

@implementation RBTree

/// 创建节点 子类重写
/// @param element 元素
/// @param parent 父节点
- (BinaryTreeNode *)createNode:(id)element parent:(BinaryTreeNode *)parent {
    return [RBNode nodeWithElement:element parent:parent];
}

/// 新添加节点之后的处理 子类重写
/// @param node 节点
- (void)afterAdd:(BinaryTreeNode *)node {
    BinaryTreeNode *parent = node.parent;
    
    // 添加的是根节点 或者 上溢到达了根节点
    if (parent == nil) {
        [self blackNode:node];
        return;
    }
    
    // 如果父节点是黑色，直接返回
    if ([self isBlack:parent]) return;
    
    // 叔父节点
    BinaryTreeNode *uncle = parent.sibling;
    // 祖父节点
    BinaryTreeNode *grand = [self redNode:parent.parent];
    if ([self isRed:uncle]) {// 叔父节点是红色【B树节点上溢】
        [self blackNode:parent];
        [self blackNode:uncle];
        // 把祖父节点当做是新添加的节点
        [self afterAdd:grand];
        return;
    }
    
    // 叔父节点不是红色
    if (parent.isLeftChild) {// L
        if (node.isLeftChild) {// LL
            [self blackNode:parent];
        }else{// LR
            [self blackNode:node];
            [self rotateLeft:parent];
        }
        [self rotateRight:grand];
    }else {// R
        if (node.isLeftChild) {// RL
            [self blackNode:node];
            [self rotateRight:parent];
        }else{// RR
            [self blackNode:parent];
        }
        [self rotateLeft:grand];
    }
}

/// 删除节点之后的处理 子类重写
/// @param node 节点
- (void)afterRemove:(BinaryTreeNode *)node {
    // 如果删除的节点是红色
    // 或者 用以取代删除节点的子节点是红色
    if ([self isRed:node]) {
        [self blackNode:node];
        return;
    }
    
    BinaryTreeNode *parent = node.parent;
    // 删除的是根节点
    if (parent == nil) return;
    // 删除的是黑色叶子节点【下溢】
    // 判断被删除的node是左还是右
    BOOL left = parent.left == nil || node.isLeftChild;
    BinaryTreeNode *sibling = left ? parent.right : parent.left;
    if (left) {// 被删除的节点在左边，兄弟节点在右边
        if ([self isRed:sibling]) {// 兄弟节点是红色
            [self blackNode:sibling];
            [self redNode:parent];
            [self rotateLeft:parent];
            // 更换兄弟
            sibling = parent.right;
        }
        
        // 兄弟节点必然是黑色
        if ([self isBlack:sibling.left] && [self isBlack:sibling.right]) {
            // 兄弟节点没有1个红色子节点，父节点要向下跟兄弟节点合并
            BOOL parentBlack = [self isBlack:parent];
            [self blackNode:parent];
            [self redNode:sibling];
            if (parentBlack) {
                [self afterRemove:parent];
            }
        } else {// 兄弟节点至少有1个红色子节点，向兄弟节点借元素
            // 兄弟节点的左边是黑色，兄弟要先旋转
            if ([self isBlack:sibling.right]) {
                [self rotateRight:sibling];
                sibling = parent.right;
            }
            
            [self colorNode:sibling color:[self colorOfNode:parent]];
            [self blackNode:sibling.right];
            [self blackNode:parent];
            [self rotateLeft:parent];
        }
    } else {// 被删除的节点在右边，兄弟节点在左边
        if ([self isRed:sibling]) {// 兄弟节点是红色
            [self blackNode:sibling];
            [self redNode:parent];
            [self rotateRight:parent];
            // 更换兄弟
            sibling = parent.left;
        }
        
        // 兄弟节点必然是黑色
        if ([self isBlack:sibling.left] && [self isBlack:sibling.right]) {
            // 兄弟节点没有1个红色子节点，父节点要向下跟兄弟节点合并
            BOOL parentBlack = [self isBlack:parent];
            [self blackNode:parent];
            [self redNode:sibling];
            if (parentBlack) {
                [self afterRemove:parent];
            }
        }else {// 兄弟节点至少有1个红色子节点，向兄弟节点借元素
            // 兄弟节点的左边是黑色，兄弟要先旋转
            if ([self isBlack:sibling.left]) {
                [self rotateLeft:sibling];
                sibling = parent.left;
            }
            
            [self colorNode:sibling color:[self colorOfNode:parent]];
            [self blackNode:sibling.left];
            [self blackNode:parent];
            [self rotateRight:parent];
        }
    }
}

/// 给节点染色
/// @param node 节点
/// @param color 颜色
- (BinaryTreeNode *)colorNode:(BinaryTreeNode *)node color:(BOOL)color {
    if (node == nil) return node;
    ((RBNode *)node).color = color;
    return node;
}

/// 把节点染成红色
/// @param node 节点
- (BinaryTreeNode *)redNode:(BinaryTreeNode *)node {
    return [self colorNode:node color:RED];
}

/// 把节点染成黑色
/// @param node 节点
- (BinaryTreeNode *)blackNode:(BinaryTreeNode *)node {
    return [self colorNode:node color:BLACK];
}

/// 返回给定节点的颜色
/// @param node 节点
- (BOOL)colorOfNode:(BinaryTreeNode *)node {
    return node == nil ? BLACK : ((RBNode *)node).color;
}

/// 节点是否是黑色
/// @param node 节点
- (BOOL)isBlack:(BinaryTreeNode *)node {
    return [self colorOfNode:node] == BLACK;
}

/// 节点是否是红色
/// @param node 节点
- (BOOL)isRed:(BinaryTreeNode *)node {
    return [self colorOfNode:node] == RED;
}

@end
