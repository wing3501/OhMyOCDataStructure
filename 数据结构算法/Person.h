//
//  Person.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/5.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
/// 名称
@property (nonatomic, copy) NSString *name;
/// 骨头断了几根
@property (nonatomic, assign) NSUInteger boneBreak;

+ (instancetype)personWithName:(NSString *)name boneBreak:(NSUInteger)boneBreak;
@end

NS_ASSUME_NONNULL_END
