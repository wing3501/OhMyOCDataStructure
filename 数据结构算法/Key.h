//
//  Key.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/4.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Key : NSObject
@property (nonatomic, assign) NSInteger value;
+ (instancetype)keyWithValue:(NSInteger)value;
@end

NS_ASSUME_NONNULL_END
