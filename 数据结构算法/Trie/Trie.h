//
//  Trie.h
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/5.
//  Copyright © 2019 styf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HashMap.h"
NS_ASSUME_NONNULL_BEGIN

@interface TrieNode<ObjectType> : NSObject{
    @public
    HashMap<NSNumber *,TrieNode<ObjectType> *> *children;
    ObjectType value;
    BOOL word;// // 是否为单词的结尾（是否为一个完整的单词）
}

- (HashMap<NSNumber *,TrieNode<ObjectType> *> *)children;
@end

@interface Trie<ObjectType> : NSObject

/// 元素的数量
- (NSUInteger)size;

/// 添加元素
/// @param key key
/// @param value 值
- (ObjectType)addWithKey:(NSString *)key value:(ObjectType)value;

/// 是否以某个字符串为前缀
/// @param prefix 前缀
- (BOOL)startsWith:(NSString *)prefix;

/// 获取key对应的值
/// @param key key
- (ObjectType)get:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
