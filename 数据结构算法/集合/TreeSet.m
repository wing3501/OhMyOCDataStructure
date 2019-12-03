//
//  TreeSet.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/2.
//  Copyright © 2019 styf. All rights reserved.
//

#import "TreeSet.h"
#import "RBTree.h"
@interface TreeSet(){
    RBTree *tree;
}
@end
@implementation TreeSet

- (instancetype)init {
    self = [super init];
    if (self) {
        NSAssert(NO, @"Use setWithComparator");
    }
    return self;
}

- (instancetype)initWithComparator:(NSComparator)comparator {
    self = [super init];
    if (self) {
        tree = [RBTree treeWithComparator:comparator];
    }
    return self;
}

+ (instancetype)setWithComparator:(NSComparator)comparator {
    return [[self alloc]initWithComparator:comparator];
}

/// 元素的数量
- (NSUInteger)size {
    return tree.size;
}

/// 是否为空
- (BOOL)isEmpty {
    return tree.isEmpty;
}

/// 清除所有元素
- (void)clear {
    [tree clear];
}

/// 是否包含某个元素
/// @param anObject 元素
- (BOOL)containsObject:(id)anObject {
    return [tree contains:anObject];
}

/// 添加元素
/// @param anObject 元素
- (void)addObject:(id)anObject {
    [tree add:anObject];
}

/// 删除元素
/// @param anObject 元素
- (void)removeObject:(id)anObject {
    [tree remove:anObject];
}

/// 遍历
/// @param visitor 遍历回调
- (void)traversal:(Visitor *)visitor {
    [tree inorder:visitor];
}
@end
