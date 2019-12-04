//
//  LinkedHashMap.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/4.
//  Copyright © 2019 styf. All rights reserved.
//

#import "LinkedHashMap.h"

@interface LinkedNode ()
/// 上一个节点
@property (nonatomic, strong) LinkedNode *prev;
/// 下一个节点
@property (nonatomic, strong) LinkedNode *next;
@end

@implementation LinkedNode

@end

@interface LinkedHashMap ()
/// 第一个节点
@property (nonatomic, strong) LinkedNode *first;
/// 最后一个节点
@property (nonatomic, strong) LinkedNode *last;
@end
@implementation LinkedHashMap

/// 清除所有元素
- (void)clear {
    [super clear];
    _first = nil;
    _last = nil;
}

/// 是否包含某个value
/// @param value value
- (BOOL)containsValue:(nullable id)value {
    LinkedNode *node = _first;
    while (node != nil) {
        if ([value isEqual:node.value] || (value == nil && node.value == nil)) {
            return YES;
        }
        node = node.next;
    }
    return NO;
}

/// 删除后处理 主要是处理链表的线
/// @param willNode 将要删除的节点
/// @param removedNode 真正被删除的节点
- (void)afterRemoveWithWillNode:(HashMapNode *)willNode removedNode:(HashMapNode *)removedNode {
    LinkedNode *node1 = (LinkedNode *)willNode;
    LinkedNode *node2 = (LinkedNode *)removedNode;
    
    if (node1 != node2) {
        // 交换linkedWillNode和linkedRemovedNode在链表中的位置
        // 交换prev
        LinkedNode *tmp = node1.prev;
        node1.prev = node2.prev;
        node2.prev = tmp;
        if (node1.prev == nil) {
            _first = node1;
        } else {
            node1.prev.next = node1;
        }
        if (node2.prev == nil) {
            _first = node2;
        } else {
            node2.prev.next = node2;
        }
        
        // 交换next
        tmp = node1.next;
        node1.next = node2.next;
        node2.next = tmp;
        if (node1.next == nil) {
            _last = node1;
        }else {
            node1.next.prev = node1;
        }
        if (node2.next == nil) {
            _last = node2;
        }else {
            node2.next.prev = node2;
        }
    }
    
    LinkedNode *prev = node2.prev;
    LinkedNode *next = node2.next;
    if (prev == nil) {
        _first = next;
    }else {
        prev.next = next;
    }
    
    if (next == nil) {
        _last = prev;
    }else {
        next.prev = prev;
    }
}

/// 遍历
/// @param visitorBlock 遍历回调
- (void)traversal:(BOOL(^)(id key,id value))visitorBlock {
    if (visitorBlock == nil) return;
    LinkedNode *node = _first;
    while (node != nil) {
        if (visitorBlock(node.key,node.value)) {
            return;
        }
        node = node.next;
    }
}

- (HashMapNode *)createNodeWithKey:(id)key value:(id)value parent:(HashMapNode *)parent {
    LinkedNode *node = [LinkedNode nodeWithKey:key value:value parent:parent];
    if (self.first == nil) {
        self.first = node;
        self.last = node;
    } else {
        self.last.next = node;
        node.prev = self.last;
        self.last = node;
    }
    return node;
}

@end
