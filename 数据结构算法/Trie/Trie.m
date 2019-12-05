//
//  Trie.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/5.
//  Copyright © 2019 styf. All rights reserved.
//

#import "Trie.h"

@implementation TrieNode
- (HashMap<NSNumber *,TrieNode *> *)children {
    if (self->children == nil) {
        self->children = [[HashMap alloc]init];
    }
    return self->children;
}
@end

@interface Trie<ObjectType>(){
    NSUInteger size;//元素的数量
    TrieNode<ObjectType> *root;
}
@end

@implementation Trie

- (instancetype)init {
    self = [super init];
    if (self) {
        root = [[TrieNode alloc]init];
    }
    return self;
}

/// 元素的数量
- (NSUInteger)size {
    return size;
}

/// 是否为空
- (BOOL)isEmpty {
    return size == 0;
}

/// 清除所有元素
- (void)clear {
    size = 0;
    [root.children clear];
}

- (id)get:(NSString *)key {
    TrieNode *node = [self nodeOfKey:key];
    return node == nil ? nil : node->value;
}

- (BOOL)contains:(NSString *)key {
    return [self nodeOfKey:key] != nil;
}

- (id)addWithKey:(NSString *)key value:(id)value {
    [self keyCheck:key];
    
    TrieNode *node = root;
    NSUInteger len = key.length;
    for (NSUInteger i = 0; i < len; i++) {
        unichar c = [key characterAtIndex:i];
        TrieNode *childNode = [node.children objectForKey:[NSNumber numberWithUnsignedChar:c]];
        if (childNode == nil) {
            childNode = [[TrieNode alloc]init];
            [node.children setObject:childNode forKey:[NSNumber numberWithUnsignedChar:c]];
        }
        node = childNode;
    }
    
    if (node->word) {// 已经存在这个单词
        id oldValue = node->value;
        node->value = value;
        return oldValue;
    }
    
    // 新增一个单词
    node->word = YES;
    node->value = value;
    size++;
    return nil;
}

- (BOOL)startsWith:(NSString *)prefix {
    [self keyCheck:prefix];
    
    TrieNode *node = root;
    NSUInteger len = prefix.length;
    for (NSUInteger i = 0; i < len; i++) {
        unichar c = [prefix characterAtIndex:i];
        node = [node.children objectForKey:[NSNumber numberWithUnsignedChar:c]];
        if (node == nil) {
            return NO;
        }
    }
    return YES;
}

- (TrieNode *)nodeOfKey:(NSString *)key {
    [self keyCheck:key];
    
    TrieNode *node = root;
    NSUInteger len = key.length;
    for (NSUInteger i = 0; i < len; i++) {
        unichar c = [key characterAtIndex:i];
        node = [node.children objectForKey:[NSNumber numberWithUnsignedChar:c]];
        if (node == nil) {
            return nil;
        }
    }
    return node->word ? node : nil;
}

- (void)keyCheck:(NSString *)key{
    if (key.length == 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"key must not be empty" userInfo:nil];
    }
}
@end
