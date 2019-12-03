//
//  AVLTree.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/28.
//  Copyright © 2019 styf. All rights reserved.
//

#import "BinarySearchTree.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVLNode : BinaryTreeNode
/// 节点高度
@property (nonatomic, assign) NSInteger height;
@end

@interface AVLTree : BinarySearchTree

@end

NS_ASSUME_NONNULL_END
