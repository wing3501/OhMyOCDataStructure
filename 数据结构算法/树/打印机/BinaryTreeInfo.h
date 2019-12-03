//
//  BinaryTreeInfo.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/22.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BinaryTreeInfo <NSObject>

/// 返回根节点
- (id)root;

/// 返回给定节点的左节点
- (id)left:(id)node;

/// 返回给定节点的右节点
- (id)right:(id)node;

/// 节点的打印方式
- (NSString *)string:(id)node;
@end

NS_ASSUME_NONNULL_END
