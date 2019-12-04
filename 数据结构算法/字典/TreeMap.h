//
//  TreeMap.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/2.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface TreeMapVisitor<K,V> : NSObject
/// 是否暂停遍历
@property (nonatomic, assign) BOOL stop;
/// 遍历访问回调 返回值为是否暂停遍历
@property (nonatomic, copy) BOOL(^visitorBlock)(K key,V value);

+ (instancetype)visitorWithBlock:(BOOL(^)(K key,V value))block;

@end

@interface TreeMapNode<K,V> : NSObject
/// key
@property (nonatomic, strong) K key;
/// value
@property (nonatomic, strong) V value;
/// 节点颜色
@property (nonatomic, assign) BOOL color;
/// 左子树节点
@property (nonatomic, strong, nullable) TreeMapNode<K,V> *left;
/// 右子树节点
@property (nonatomic, strong, nullable) TreeMapNode<K,V> *right;
/// 父节点
@property (nonatomic, strong, nullable) TreeMapNode<K,V> *parent;

+ (instancetype)nodeWithKey:(K)key value:(V)value parent:(nullable TreeMapNode<K,V> *)parent;

/// 是否是叶子节点
- (BOOL)isLeaf;

/// 是否有左右子树
- (BOOL)hasTwoChildren;

/// 是否是父节点的左子树节点
- (BOOL)isLeftChild;

/// 是否是父节点的右子树节点
- (BOOL)isRightChild;

/// 返回叔父节点
- (TreeMapNode<K,V> *)sibling;
@end

@interface TreeMap<K,V> : NSObject
+ (instancetype)mapWithComparator:(NSComparator)comparator;

/// 元素的数量
- (NSUInteger)size;

/// 是否为空
- (BOOL)isEmpty;

/// 清除所有元素
- (void)clear;

/// 放入字典
/// @param value 值
/// @param key key
- (V)setObject:(V)value forKey:(K)key;

/// 从字典取出
/// @param key key
- (nullable V)objectForKey:(K)key;

/// 根据key从字典删除元素
/// @param key key
- (V)remove:(K)key;

/// 是否包含某个key
/// @param key key
- (BOOL)containsKey:(K)key;

/// 是否包含某个value
/// @param value value
- (BOOL)containsValue:(V)value;

/// 遍历
/// @param visitor 遍历回调
- (void)traversal:(TreeMapVisitor *)visitor;
@end

NS_ASSUME_NONNULL_END
