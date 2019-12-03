//
//  LevelOrderPrinter.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/25.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryTreeInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface LevelOrderPrinter : NSObject

+ (instancetype)printerWithTree:(id<BinaryTreeInfo>)tree;

- (void)print;
@end

NS_ASSUME_NONNULL_END
