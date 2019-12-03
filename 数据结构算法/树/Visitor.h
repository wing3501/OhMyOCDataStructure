//
//  Visitor.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/2.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 遍历访问回调 返回值为是否暂停遍历
typedef BOOL(^VisitorBlock)(id value);

@interface Visitor : NSObject
/// 是否暂停遍历
@property (nonatomic, assign) BOOL stop;
/// 遍历回调
@property (nonatomic, copy) VisitorBlock visitorBlock;
@end

NS_ASSUME_NONNULL_END
