//
//  RBTree.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/29.
//  Copyright © 2019 styf. All rights reserved.
//

#import "BBST.h"

NS_ASSUME_NONNULL_BEGIN

@interface RBNode : BinaryTreeNode
/// 节点颜色
@property (nonatomic, assign) BOOL color;
@end

@interface RBTree : BBST

@end

NS_ASSUME_NONNULL_END
