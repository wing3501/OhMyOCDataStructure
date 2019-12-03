//
//  BinarySearchTree.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/28.
//  Copyright © 2019 styf. All rights reserved.
//

#import "BinarySearchTree.h"
@interface BinarySearchTree()
/// 比较器
@property (nonatomic, copy) NSComparator comparator;
@end
@implementation BinarySearchTree
- (instancetype)initWithComparator:(NSComparator)comparator {
    self = [super init];
    if (self) {
        _comparator = comparator;
    }
    return self;
}

+ (instancetype)treeWithComparator:(NSComparator)comparator {
    return [[self alloc]initWithComparator:comparator];
}

- (void)elementNotNullCheck:(id)element {
    if (element == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"element must not be null" userInfo:nil];
    }
}

- (BinaryTreeNode *)node:(id)element {
    BinaryTreeNode *node = root;
    while (node != nil) {
        NSComparisonResult cmp = _comparator(element,node.element);
        if (cmp == NSOrderedSame) {
            return node;
        }else if (cmp == NSOrderedDescending) {
            node = node.right;
        }else{
            node = node.left;
        }
    }
    return nil;
}

- (void)add:(id)element {
    [self elementNotNullCheck:element];
    
    // 添加第一个节点
    if (root == nil) {
        root = [self createNode:element parent:nil];
        size++;
        
        // 新添加节点之后的处理
        [self afterAdd:root];
        return;
    }
            
    // 添加的不是第一个节点
    // 找到父节点
    BinaryTreeNode *parent = root;
    BinaryTreeNode *node = root;
    NSComparisonResult cmp = 0;
    do {
        cmp = _comparator(element, node.element);
        parent = node;
        if (cmp == NSOrderedDescending) {
            node = node.right;
        } else if (cmp == NSOrderedAscending) {
            node = node.left;
        } else { // 相等
            node.element = element;
            return;
        }
    } while (node != nil);
    
    // 看看插入到父节点的哪个位置
    BinaryTreeNode *newNode = [self createNode:element parent:parent];
    if (cmp == NSOrderedDescending) {
        parent.right = newNode;
    } else {
        parent.left = newNode;
    }
    size++;
    // 新添加节点之后的处理
    [self afterAdd:newNode];
}

- (BOOL)contains:(id)element {
    return [self node:element] != nil;
}

- (void)remove:(id)element {
    [self removeNode:[self node:element]];
}

- (void)removeNode:(BinaryTreeNode *)node {
    if (node == nil) return;
    
    size--;
    
    if ([node hasTwoChildren]) { // 度为2的节点
        // 找到后继节点
        BinaryTreeNode *s = [self successor:node];
        // 用后继节点的值覆盖度为2的节点的值
        node.element = s.element;
        // 删除后继节点
        node = s;
    }
    
    // 删除node节点（node的度必然是1或者0）
    BinaryTreeNode *replacement = node.left != nil ? node.left : node.right;
    
    if (replacement != nil) { // node是度为1的节点
        // 更改parent
        replacement.parent = node.parent;
        // 更改parent的left、right的指向
        if (node.parent == nil) { // node是度为1的节点并且是根节点
            root = replacement;
        } else if (node == node.parent.left) {
            node.parent.left = replacement;
        } else { // node == node.parent.right
            node.parent.right = replacement;
        }
        
        // 删除节点之后的处理
        [self afterRemove:node];
    } else if (node.parent == nil) { // node是叶子节点并且是根节点
        root = nil;
        
        // 删除节点之后的处理
        [self afterRemove:node];
    } else { // node是叶子节点，但不是根节点
        if (node == node.parent.left) {
            node.parent.left = nil;
        } else { // node == node.parent.right
            node.parent.right = nil;
        }
        
        // 删除节点之后的处理
        [self afterRemove:node];
    }
}

/// 新添加节点之后的处理 子类重写
/// @param node 节点
- (void)afterAdd:(BinaryTreeNode *)node {}

/// 删除节点之后的处理 子类重写
/// @param node 节点
- (void)afterRemove:(BinaryTreeNode *)node {}
@end
