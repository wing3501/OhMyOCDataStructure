//
//  TreeMap.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/2.
//  Copyright © 2019 styf. All rights reserved.
//

#import "TreeMap.h"
#import "Queue.h"

static BOOL const RED = NO;
static BOOL const BLACK = YES;

@implementation TreeMapVisitor

- (instancetype)initWithBlock:(BOOL(^)(id key,id value))block {
    self = [super init];
    if (self) {
        _visitorBlock = block;
    }
    return self;
}

+ (instancetype)visitorWithBlock:(BOOL(^)(id key,id value))block {
    return [[self alloc]initWithBlock:block];
}
@end

@implementation TreeMapNode

- (instancetype)initWithKey:(id)key value:(id)value parent:(nullable TreeMapNode *)parent
{
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
        self.parent = parent;
        _color = RED;
    }
    return self;
}

+ (instancetype)nodeWithKey:(id)key value:(id)value parent:(nullable TreeMapNode *)parent {
    return [[self alloc]initWithKey:key value:value parent:parent];
}

/// 是否是叶子节点
- (BOOL)isLeaf {
    return self.left == nil && self.right == nil;
}

/// 是否有左右子树
- (BOOL)hasTwoChildren {
    return self.left != nil && self.right != nil;
}

/// 是否是父节点的左子树节点
- (BOOL)isLeftChild {
    return self.parent != nil && [self isEqual:self.parent.left];
}

/// 是否是父节点的右子树节点
- (BOOL)isRightChild {
    return self.parent != nil && [self isEqual:self.parent.right];
}

/// 返回叔父节点
- (TreeMapNode *)sibling {
    if ([self isLeftChild]) {
        return self.parent.right;
    }
    if ([self isRightChild]) {
        return self.parent.left;
    }
    return nil;
}

@end

@interface TreeMap(){
    NSUInteger size;//元素的数量
    TreeMapNode *root;//根节点
}
/// 比较器 比较key的大小
@property (nonatomic, copy) NSComparator comparator;
@end

@implementation TreeMap

- (instancetype)initWithComparator:(NSComparator)comparator {
    self = [super init];
    if (self) {
        _comparator = comparator;
    }
    return self;
}

+ (instancetype)mapWithComparator:(NSComparator)comparator {
    return [[self alloc]initWithComparator:comparator];
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
    root = nil;
}

/// 放入字典
/// @param value 值
/// @param key key
- (id)setObject:(id)value forKey:(id)key {
    [self keyNotNullCheck:key];
    
    // 添加第一个节点
    if (root == nil) {
        root = [TreeMapNode nodeWithKey:key value:value parent:nil];
        size++;
        
        // 新添加节点之后的处理
        [self afterPut:root];
        return nil;
    }
            
    // 添加的不是第一个节点
    // 找到父节点
    TreeMapNode *parent = root;
    TreeMapNode *node = root;
    NSComparisonResult cmp = 0;
    do {
        cmp = _comparator(key, node.key);
        parent = node;
        if (cmp == NSOrderedDescending) {
            node = node.right;
        } else if (cmp == NSOrderedAscending) {
            node = node.left;
        } else { // 相等
            node.key = key;
            id oldValue = node.value;
            node.value = value;
            return oldValue;
        }
    } while (node != nil);
    
    // 看看插入到父节点的哪个位置
    TreeMapNode *newNode = [TreeMapNode nodeWithKey:key value:value parent:parent];
    if (cmp == NSOrderedDescending) {
        parent.right = newNode;
    } else {
        parent.left = newNode;
    }
    size++;
    // 新添加节点之后的处理
    [self afterPut:newNode];
    return nil;
}

/// 根据key查找节点
/// @param key key
- (TreeMapNode *)node:(id)key {
    TreeMapNode *node = root;
    while (node != nil) {
        NSComparisonResult cmp = _comparator(key,node.key);
        if (cmp == NSOrderedSame) {
            return node;
        }else if (cmp == NSOrderedDescending) {
            node = node.right;
        }else{
            node = node.left;
        }
    }
    return nil;
}

/// 从字典取出
/// @param key key
- (nullable id)objectForKey:(id)key {
    TreeMapNode *node = [self node:key];
    return node != nil ? node.value : nil;
}

/// 根据key从字典删除元素
/// @param key key
- (id)remove:(id)key {
    return [self removeNode:[self node:key]];
}

/// 删除某个节点
/// @param node 节点
- (id)removeNode:(TreeMapNode *)node {
    if (node == nil) return nil;
    
    size--;
    
    id oldValue = node.value;
    
    if ([node hasTwoChildren]) { // 度为2的节点
        // 找到后继节点
        TreeMapNode *s = [self successor:node];
        // 用后继节点的值覆盖度为2的节点的值
        node.key = s.key;
        node.value = s.value;
        // 删除后继节点
        node = s;
    }
    
    // 删除node节点（node的度必然是1或者0）
    TreeMapNode *replacement = node.left != nil ? node.left : node.right;
    
    if (replacement != nil) { // node是度为1的节点
        // 更改parent
        replacement.parent = node.parent;
        // 更改parent的left、right的指向
        if (node.parent == nil) { // node是度为1的节点并且是根节点
            root = replacement;
        } else if (node == node.parent.left) {
            node.parent.left = replacement;
        } else { // node == node.parent.right
            node.parent.right = replacement;
        }
        
        // 删除节点之后的处理
        [self afterRemove:node];
    } else if (node.parent == nil) { // node是叶子节点并且是根节点
        root = nil;
        
        // 删除节点之后的处理
        [self afterRemove:node];
    } else { // node是叶子节点，但不是根节点
        if (node == node.parent.left) {
            node.parent.left = nil;
        } else { // node == node.parent.right
            node.parent.right = nil;
        }
        
        // 删除节点之后的处理
        [self afterRemove:node];
    }
    
    return oldValue;
}

/// 删除节点之后的处理
/// @param node 节点
- (void)afterRemove:(TreeMapNode *)node {
    // 如果删除的节点是红色
    // 或者 用以取代删除节点的子节点是红色
    if ([self isRed:node]) {
        [self blackNode:node];
        return;
    }
    
    TreeMapNode *parent = node.parent;
    // 删除的是根节点
    if (parent == nil) return;
    // 删除的是黑色叶子节点【下溢】
    // 判断被删除的node是左还是右
    BOOL left = parent.left == nil || node.isLeftChild;
    TreeMapNode *sibling = left ? parent.right : parent.left;
    if (left) {// 被删除的节点在左边，兄弟节点在右边
        if ([self isRed:sibling]) {// 兄弟节点是红色
            [self blackNode:sibling];
            [self redNode:parent];
            [self rotateLeft:parent];
            // 更换兄弟
            sibling = parent.right;
        }
        
        // 兄弟节点必然是黑色
        if ([self isBlack:sibling.left] && [self isBlack:sibling.right]) {
            // 兄弟节点没有1个红色子节点，父节点要向下跟兄弟节点合并
            BOOL parentBlack = [self isBlack:parent];
            [self blackNode:parent];
            [self redNode:sibling];
            if (parentBlack) {
                [self afterRemove:parent];
            }
        } else {// 兄弟节点至少有1个红色子节点，向兄弟节点借元素
            // 兄弟节点的左边是黑色，兄弟要先旋转
            if ([self isBlack:sibling.right]) {
                [self rotateRight:sibling];
                sibling = parent.right;
            }
            
            [self colorNode:sibling color:[self colorOfNode:parent]];
            [self blackNode:sibling.right];
            [self blackNode:parent];
            [self rotateLeft:parent];
        }
    } else {// 被删除的节点在右边，兄弟节点在左边
        if ([self isRed:sibling]) {// 兄弟节点是红色
            [self blackNode:sibling];
            [self redNode:parent];
            [self rotateRight:parent];
            // 更换兄弟
            sibling = parent.left;
        }
        
        // 兄弟节点必然是黑色
        if ([self isBlack:sibling.left] && [self isBlack:sibling.right]) {
            // 兄弟节点没有1个红色子节点，父节点要向下跟兄弟节点合并
            BOOL parentBlack = [self isBlack:parent];
            [self blackNode:parent];
            [self redNode:sibling];
            if (parentBlack) {
                [self afterRemove:parent];
            }
        }else {// 兄弟节点至少有1个红色子节点，向兄弟节点借元素
            // 兄弟节点的左边是黑色，兄弟要先旋转
            if ([self isBlack:sibling.left]) {
                [self rotateLeft:sibling];
                sibling = parent.left;
            }
            
            [self colorNode:sibling color:[self colorOfNode:parent]];
            [self blackNode:sibling.left];
            [self blackNode:parent];
            [self rotateRight:parent];
        }
    }
}

/// 新添加节点之后的处理
/// @param node 节点
- (void)afterPut:(TreeMapNode *)node {
    TreeMapNode *parent = node.parent;
    
    // 添加的是根节点 或者 上溢到达了根节点
    if (parent == nil) {
        [self blackNode:node];
        return;
    }
    
    // 如果父节点是黑色，直接返回
    if ([self isBlack:parent]) return;
    
    // 叔父节点
    TreeMapNode *uncle = parent.sibling;
    // 祖父节点
    TreeMapNode *grand = [self redNode:parent.parent];
    if ([self isRed:uncle]) {// 叔父节点是红色【B树节点上溢】
        [self blackNode:parent];
        [self blackNode:uncle];
        // 把祖父节点当做是新添加的节点
        [self afterPut:grand];
        return;
    }
    
    // 叔父节点不是红色
    if (parent.isLeftChild) {// L
        if (node.isLeftChild) {// LL
            [self blackNode:parent];
        }else{// LR
            [self blackNode:node];
            [self rotateLeft:parent];
        }
        [self rotateRight:grand];
    }else {// R
        if (node.isLeftChild) {// RL
            [self blackNode:node];
            [self rotateRight:parent];
        }else{// RR
            [self blackNode:parent];
        }
        [self rotateLeft:grand];
    }
}

/// 左旋转
/// @param grand 节点
- (void)rotateLeft:(TreeMapNode *)grand {
    TreeMapNode *parent = grand.right;
    TreeMapNode *child = parent.left;
    grand.right = child;
    parent.left = grand;
    [self afterRotate:grand parent:parent child:child];
}

/// 右旋转
/// @param grand 节点
- (void)rotateRight:(TreeMapNode *)grand {
    TreeMapNode *parent = grand.left;
    TreeMapNode *child = parent.right;
    grand.left = child;
    parent.right = grand;
    [self afterRotate:grand parent:parent child:child];
}

/// 旋转后的操作
/// @param grand 祖父节点
/// @param parent 父节点
/// @param child 子节点
- (void)afterRotate:(TreeMapNode *)grand parent:(TreeMapNode *)parent child:(TreeMapNode *)child {
    // 让parent称为子树的根节点
    parent.parent = grand.parent;
    if ([grand isLeftChild]) {
        grand.parent.left = parent;
    } else if ([grand isRightChild]) {
        grand.parent.right = parent;
    } else { // grand是root节点
        root = parent;
    }
    
    // 更新child的parent
    if (child != nil) {
        child.parent = grand;
    }
    
    // 更新grand的parent
    grand.parent = parent;
    
}

/// 是否包含某个key
/// @param key key
- (BOOL)containsKey:(id)key {
    return [self node:key] != nil;
}

/// 是否包含某个value
/// @param value value
- (BOOL)containsValue:(id)value {
    if (root == nil) return NO;
    
    Queue<TreeMapNode *> *queue = [[Queue alloc]init];
    [queue enQueue:root];
    
    while (!queue.isEmpty) {
        TreeMapNode *node = [queue deQueue];
        
        if ([value isEqual:node.value]) return YES;
        
        if (node.left != nil) {
            [queue enQueue:node.left];
        }
        if (node.right != nil) {
            [queue enQueue:node.right];
        }
    }
    return NO;
}

/// 遍历
/// @param visitor 遍历回调
- (void)traversal:(TreeMapVisitor *)visitor {
    if (visitor == nil) return;
    [self traversal:root visitor:visitor];
}

/// 中序遍历
/// @param node 开始节点
/// @param visitor 遍历器
- (void)traversal:(TreeMapNode *)node visitor:(TreeMapVisitor *)visitor {
    if (node == nil || visitor.stop) return;

    [self traversal:node.left visitor:visitor];
    if (visitor.stop) return;
    visitor.stop = visitor.visitorBlock(node.key,node.value);
    [self traversal:node.right visitor:visitor];
}

/// 查找某个节点的前驱节点
/// @param node 节点
- (TreeMapNode *)predecessor:(TreeMapNode *)node {
    if (node == nil) {
        return nil;
    }
    // 前驱节点在左子树当中（left.right.right.right....）
    TreeMapNode *p = node.left;
    if (p != nil) {
        while (p.right != nil) {
            p = p.right;
        }
        return p;
    }
    
    // 从父节点、祖父节点中寻找前驱节点
    while (node.parent != nil && node == node.parent.left) {
        node = node.parent;
    }
    
    // node.parent == null
    // node == node.parent.right
    return node.parent;
}

/// 查找某个节点的后继节点
/// @param node 节点
- (TreeMapNode *)successor:(TreeMapNode *)node {
    if (node == nil) {
        return nil;
    }
    
    TreeMapNode *p = node.right;
    if (p != nil) {
        while (p.left != nil) {
            p = p.left;
        }
        return p;
    }
    
    // 从父节点、祖父节点中寻找前驱节点
    while (node.parent != nil && node == node.parent.right) {
        node = node.parent;
    }
    
    return node.parent;
}

/// 给节点染色
/// @param node 节点
/// @param color 颜色
- (TreeMapNode *)colorNode:(TreeMapNode *)node color:(BOOL)color {
    if (node == nil) return node;
    node.color = color;
    return node;
}

/// 把节点染成红色
/// @param node 节点
- (TreeMapNode *)redNode:(TreeMapNode *)node {
    return [self colorNode:node color:RED];
}

/// 把节点染成黑色
/// @param node 节点
- (TreeMapNode *)blackNode:(TreeMapNode *)node {
    return [self colorNode:node color:BLACK];
}

/// 返回给定节点的颜色
/// @param node 节点
- (BOOL)colorOfNode:(TreeMapNode *)node {
    return node == nil ? BLACK : node.color;
}

/// 节点是否是黑色
/// @param node 节点
- (BOOL)isBlack:(TreeMapNode *)node {
    return [self colorOfNode:node] == BLACK;
}

/// 节点是否是红色
/// @param node 节点
- (BOOL)isRed:(TreeMapNode *)node {
    return [self colorOfNode:node] == RED;
}

- (void)keyNotNullCheck:(id)key {
    if(key == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"key must not be null" userInfo:nil];
}
@end
