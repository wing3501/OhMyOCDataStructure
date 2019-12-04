//
//  HashMap.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/12/3.
//  Copyright © 2019 styf. All rights reserved.
//

#import "HashMap.h"
#import "Queue.h"

static BOOL const RED = NO;
static BOOL const BLACK = YES;
static float const DEFAULT_LOAD_FACTOR = 0.75f;//装填因子

@implementation HashMapNode

- (instancetype)initWithKey:(id)key value:(id)value parent:(nullable HashMapNode *)parent
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

+ (instancetype)nodeWithKey:(id)key value:(id)value parent:(nullable HashMapNode *)parent {
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
- (HashMapNode *)sibling {
    if ([self isLeftChild]) {
        return self.parent.right;
    }
    if ([self isRightChild]) {
        return self.parent.left;
    }
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Node_%@_%@", self.key,self.value];
}

- (NSUInteger)hash {
    NSUInteger hash = self.key == nil ? 0 : [self.key hash];
    return hash ^ (hash >> 16);
}
@end

@interface HashMap<K,V> (){
    NSUInteger size;//元素的数量
    NSMutableArray<HashMapNode<K,V> *> *table;//数组
    NSNull *null;//占位元素
    NSUInteger currentCapacity;//当前容量
}

@end

@implementation HashMap

- (instancetype)init {
    self = [super init];
    if (self) {
        currentCapacity = 1 << 4;
        null = [NSNull null];
        table = [NSMutableArray arrayWithCapacity:currentCapacity];
        [self resetTable];
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
    if (size == 0) return;
    size = 0;
    for (NSInteger i = 0; i < size; i++) {
        table[i] = null;
    }
}

/// 放入字典
/// @param value 值
/// @param key key
- (id)setObject:(id)value forKey:(id)key {
    [self resize];
    
    NSUInteger index = [self indexOfKey:key];
    // 取出index位置的红黑树根节点
    HashMapNode *root = table[index];
    if ([root isEqual:null]) {
        root = [HashMapNode nodeWithKey:key value:value parent:nil];
        table[index] = root;
        size++;
        [self fixAfterPut:root];
        return nil;
    }
    
    // 添加新的节点到红黑树上面
    HashMapNode *parent = root;
    HashMapNode *node = root;
    NSComparisonResult cmp = NSOrderedSame;
    id k1 = key;
    NSUInteger h1 = [self hashOfKey:k1];
    HashMapNode *result = nil;
    BOOL searched = NO;// 是否已经搜索过这个key
    do {
        parent = node;
        id k2 = node.key;
        NSUInteger h2 = node.hash;
        //先拿节点的hash进行比较
        if (h1 > h2) {
            cmp = NSOrderedDescending;
        } else if (h1 < h2) {
            cmp = NSOrderedAscending;
        } else if ([k1 isEqual:k2]){
            cmp = NSOrderedSame;
        }else if (k1 != nil && k2 != nil && self.comparator && [k1 isKindOfClass:[k2 class]] && self.comparator(k1,k2) != NSOrderedSame) {
            //两个key都不为空，且类型相同，有比较器
            cmp = self.comparator(k1,k2);
        }else if (k1 != nil && k2 != nil && [k1 isKindOfClass:[k2 class]] && [k1 respondsToSelector:@selector(compare:)] && [k1 compare:k2] != NSOrderedSame){
            //两个key都不为空，且类型相同，支持比较
            cmp = [k1 compare:k2];
        } else if (searched) {// 已经扫描了
            //用key自己的hash进行比较
            if ([k1 hash] > [k2 hash]) {
                cmp = NSOrderedDescending;
            }else if ([k1 hash] < [k2 hash]) {
                cmp = NSOrderedAscending;
            }else{
                cmp = NSOrderedSame;
            }
        }else{
            //还没有扫描，然后再根据内存地址大小决定左右
            if (node.left != nil) {
                result = [self nodeWithNode:node.left key:k1];
            }
            if (result == nil) {
                //左边没找到，继续去右边找
                result = [self nodeWithNode:node.right key:k1];
            }
            if (result != nil) {
                //两边都找过了，并且找到了,已经存在这个key
                node = result;
                cmp = 0;
            }else{
                // 不存在这个key
                searched = YES;
                //用key自己的hash进行比较
                if ([k1 hash] > [k2 hash]) {
                    cmp = NSOrderedDescending;
                }else if ([k1 hash] < [k2 hash]) {
                    cmp = NSOrderedAscending;
                }else{
                    cmp = NSOrderedSame;
                }
            }
        }
        
        if (cmp == NSOrderedDescending) {
            node = node.right;
        } else if (cmp == NSOrderedAscending) {
            node = node.left;
        } else {
            id oldValue = node.value;
            node.key = key;
            node.value = value;
            return oldValue;
        }
    } while (node != nil);
    
    // 看看插入到父节点的哪个位置
    HashMapNode *newNode = [HashMapNode nodeWithKey:key value:value parent:parent];
    if (cmp == NSOrderedDescending) {
        parent.right = newNode;
    } else {
        parent.left = newNode;
    }
    size++;
    
    // 新添加节点之后的处理
    [self fixAfterPut:newNode];
    return nil;
}

/// 从哈希表取出
/// @param key key
- (nullable id)objectForKey:(id)key {
    HashMapNode *node = [self nodeOfKey:key];
    return node != nil ? node.value : nil;
}

/// 根据key从哈希表删除元素
/// @param key key
- (id)remove:(id)key {
    return [self removeNode:[self nodeOfKey:key]];
}

/// 从哈希表删除元素
/// @param node 节点
- (id)removeNode:(HashMapNode *)node {
    if (node == nil) return nil;
    
    HashMapNode *willNode = node;
    
    size--;
    
    id oldValue = node.value;
    
    if ([node hasTwoChildren]) { // 度为2的节点
        // 找到后继节点
        HashMapNode *s = [self successor:node];
        // 用后继节点的值覆盖度为2的节点的值
        node.key = s.key;
        node.value = s.value;
        // 删除后继节点
        node = s;
    }
    
    // 删除node节点（node的度必然是1或者0）
    HashMapNode *replacement = node.left != nil ? node.left : node.right;
    NSUInteger index = [self indexOfNode:node];
    
    if (replacement != nil) { // node是度为1的节点
        // 更改parent
        replacement.parent = node.parent;
        // 更改parent的left、right的指向
        if (node.parent == nil) { // node是度为1的节点并且是根节点
            table[index] = replacement;
        } else if (node == node.parent.left) {
            node.parent.left = replacement;
        } else { // node == node.parent.right
            node.parent.right = replacement;
        }
        
        // 删除节点之后的处理
        [self fixAfterRemove:replacement];
    } else if (node.parent == nil) { // node是叶子节点并且是根节点
        table[index] = null;
    } else { // node是叶子节点，但不是根节点
        if (node == node.parent.left) {
            node.parent.left = nil;
        } else { // node == node.parent.right
            node.parent.right = nil;
        }
        
        // 删除节点之后的处理
        [self fixAfterRemove:node];
    }
    // 交给子类去处理
    [self afterRemoveWithWillNode:willNode removedNode:node];
    return oldValue;
}

/// 查找某个节点的后继节点
/// @param node 节点
- (HashMapNode *)successor:(HashMapNode *)node {
    if (node == nil) {
        return nil;
    }
    
    HashMapNode *p = node.right;
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

/// 是否包含某个key
/// @param key key
- (BOOL)containsKey:(id)key {
    return [self nodeOfKey:key] != nil;
}

/// 是否包含某个value
/// @param value value
- (BOOL)containsValue:(id)value {
    if (size == 0) return NO;
    Queue<HashMapNode *> *queue = [[Queue alloc]init];
    for (int i = 0; i < table.count; i++) {
        if ([table[i] isEqual:null]) continue;
        
        [queue enQueue:table[i]];
        while (!queue.isEmpty) {
            HashMapNode *node = [queue deQueue];
            if ([value isEqual:node.value]) return YES;
            
            if (node.left != nil) {
                [queue enQueue:node.left];
            }
            if (node.right != nil) {
                [queue enQueue:node.right];
            }
        }
    }
    return NO;
}

/// 遍历
/// @param visitorBlock 遍历回调
- (void)traversal:(BOOL(^)(id key,id value))visitorBlock {
    if (size == 0 || visitorBlock == nil) return;
    Queue<HashMapNode *> *queue = [[Queue alloc]init];
    for (int i = 0; i < table.count; i++) {
        if ([table[i] isEqual:null]) continue;
        
        [queue enQueue:table[i]];
        while (!queue.isEmpty) {
            HashMapNode *node = [queue deQueue];
            if (visitorBlock(node.key,node.value)) {
                return;
            }
            
            if (node.left != nil) {
                [queue enQueue:node.left];
            }
            if (node.right != nil) {
                [queue enQueue:node.right];
            }
        }
    }
}

/// 删除后处理子类重写
/// @param willNode <#willNode description#>
/// @param removedNode <#removedNode description#>
- (void)afterRemoveWithWillNode:(HashMapNode *)willNode removedNode:(HashMapNode *)removedNode {}

/// 扩容
- (void)resize {
    if ((float)size / table.count <= DEFAULT_LOAD_FACTOR) return;
    
    NSMutableArray *oldTable  = table;
    currentCapacity = oldTable.count << 1;
    table = [[NSMutableArray alloc]initWithCapacity:currentCapacity];
    [self resetTable];
    
    Queue<HashMapNode *> *queue = [[Queue alloc]init];
    for (NSInteger i = 0; i < oldTable.count; i++) {
        if ([oldTable[i] isEqual:null]) continue;
        
        [queue enQueue:oldTable[i]];
        while (!queue.isEmpty) {
            HashMapNode *node = [queue deQueue];
            
            if (node.left != nil) {
                [queue enQueue:node.left];
            }
            if (node.right != nil) {
                [queue enQueue:node.right];
            }
            // 挪动代码得放到最后面
            [self moveNode:node];
        }
    }
}

/// 查找key对应的节点
/// @param key key
- (HashMapNode *)nodeOfKey:(id)key {
    HashMapNode *root = table[[self indexOfKey:key]];
    return root == nil ? nil : [self nodeWithNode:root key:key];
}

/// 查找key对应的节点
/// @param node 查找起始节点
/// @param k1 key
- (HashMapNode *)nodeWithNode:(HashMapNode *)node key:(id)k1 {
    NSUInteger h1 = [self hashOfKey:k1];
    // 存储查找结果
    HashMapNode *result = nil;
    NSComparisonResult cmp = NSOrderedSame;
    while (node != nil) {
        id k2 = node.key;
        NSUInteger h2 = node.hash;
        //先比较哈希值
        if (h1 > h2) {
            node = node.right;
        } else if (h1 < h2) {
            node = node.left;
        } else if ([k1 isEqual:k2]) {
            return node;
        }else if (k1 != nil && k2 != nil && self.comparator && [k1 isKindOfClass:[k2 class]] && self.comparator(k1,k2) != NSOrderedSame) {
            //两个key都不为空，且类型相同，有比较器
            cmp = self.comparator(k1,k2);
            node = cmp > 0 ? node.right : node.left;
        }else if (k1 != nil && k2 != nil && [k1 isKindOfClass:[k2 class]] && [k1 respondsToSelector:@selector(compare:)] && [k1 compare:k2] != NSOrderedSame){
            //两个key都不为空，且类型相同，支持比较
            cmp = [k1 compare:k2];
            node = cmp > 0 ? node.right : node.left;
        }else {
            if (node.right != nil) {
                result = [self nodeWithNode:node.right key:k1];
            }
            if (result != nil) {
                //在右边找到了
                return result;
            }else{
                // 只能往左边找
                node = node.left;
            }
        }
    }
    return nil;
}

/// 根据key生成对应的索引（在桶数组中的位置）
/// @param key key
- (NSUInteger)indexOfKey:(id)key {
    return [self hashOfKey:key] & (table.count - 1);
}

/// 用key对应节点的hash值
/// @param key key
- (NSUInteger)hashOfKey:(id)key {
    if (key == nil) return 0;
    NSUInteger hash = [key hash];
    return hash ^ (hash >> 16);
}

/// 返回节点所属桶的下标
/// @param node 节点
- (NSUInteger)indexOfNode:(HashMapNode *)node {
    return node.hash & (table.count - 1);
}

/// 移动节点
/// @param newNode 节点
- (void)moveNode:(HashMapNode *)newNode {
    // 重置
    newNode.parent = nil;
    newNode.left = nil;
    newNode.right = nil;
    newNode.color = RED;
    
    NSUInteger index = [self indexOfNode:newNode];
    // 取出index位置的红黑树根节点
    HashMapNode *root = table[index];
    if ([root isEqual:null]) {
        root = newNode;
        table[index] = root;
        [self fixAfterPut:root];
        return;
    }
            
    // 添加新的节点到红黑树上面
    HashMapNode *parent = root;
    HashMapNode *node = root;
    NSComparisonResult cmp = NSOrderedSame;
    id k1 = newNode.key;
    NSUInteger h1 = newNode.hash;
    do {
        parent = node;
        id k2 = node.key;
        NSUInteger h2 = node.hash;
        //先拿节点的hash进行比较
        if (h1 > h2) {
            cmp = NSOrderedDescending;
        } else if (h1 < h2) {
            cmp = NSOrderedAscending;
        } else if (k1 != nil && k2 != nil && self.comparator && [k1 isKindOfClass:[k2 class]] && self.comparator(k1,k2) != NSOrderedSame) {
            //两个key都不为空，且类型相同，有比较器
            cmp = self.comparator(k1,k2);
        } else if (k1 != nil && k2 != nil && [k1 isKindOfClass:[k2 class]] && [k1 respondsToSelector:@selector(compare:)] && [k1 compare:k2] != NSOrderedSame){
            //两个key都不为空，且类型相同，支持比较
            cmp = [k1 compare:k2];
        } else {
            //实在比不出来，用key自己的hash进行比较
            if ([k1 hash] > [k2 hash]) {
                cmp = NSOrderedDescending;
            }else if ([k1 hash] < [k2 hash]) {
                cmp = NSOrderedAscending;
            }else{
                cmp = NSOrderedSame;
            }
        }
        if (cmp == NSOrderedDescending) {
            node = node.right;
        } else if (cmp == NSOrderedAscending) {
            node = node.left;
        }
    } while (node != nil);
            
    // 看看插入到父节点的哪个位置
    newNode.parent = parent;
    if (cmp == NSOrderedDescending) {
        parent.right = newNode;
    } else {
        parent.left = newNode;
    }
    
    // 新添加节点之后的处理
    [self fixAfterPut:newNode];
}

/// 删除后处理
/// @param node 节点
- (void)fixAfterRemove:(HashMapNode *)node {
    // 如果删除的节点是红色
    // 或者 用以取代删除节点的子节点是红色
    if ([self isRed:node]) {
        [self blackNode:node];
        return;
    }
    
    HashMapNode *parent = node.parent;
    // 删除的是根节点
    if (parent == nil) return;
    // 删除的是黑色叶子节点【下溢】
    // 判断被删除的node是左还是右
    BOOL left = parent.left == nil || node.isLeftChild;
    HashMapNode *sibling = left ? parent.right : parent.left;
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
                [self fixAfterRemove:parent];
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
                [self fixAfterRemove:parent];
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

/// 新增节点后处理
/// @param node 节点
- (void)fixAfterPut:(HashMapNode *)node {
    HashMapNode *parent = node.parent;
    
    // 添加的是根节点 或者 上溢到达了根节点
    if (parent == nil) {
        [self blackNode:node];
        return;
    }
    
    // 如果父节点是黑色，直接返回
    if ([self isBlack:parent]) return;
    
    // 叔父节点
    HashMapNode *uncle = parent.sibling;
    // 祖父节点
    HashMapNode *grand = [self redNode:parent.parent];
    if ([self isRed:uncle]) {// 叔父节点是红色【B树节点上溢】
        [self blackNode:parent];
        [self blackNode:uncle];
        // 把祖父节点当做是新添加的节点
        [self fixAfterPut:grand];
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
- (void)rotateLeft:(HashMapNode *)grand {
    HashMapNode *parent = grand.right;
    HashMapNode *child = parent.left;
    grand.right = child;
    parent.left = grand;
    [self afterRotate:grand parent:parent child:child];
}

/// 右旋转
/// @param grand 节点
- (void)rotateRight:(HashMapNode *)grand {
    HashMapNode *parent = grand.left;
    HashMapNode *child = parent.right;
    grand.left = child;
    parent.right = grand;
    [self afterRotate:grand parent:parent child:child];
}

/// 旋转后的操作
/// @param grand 祖父节点
/// @param parent 父节点
/// @param child 子节点
- (void)afterRotate:(HashMapNode *)grand parent:(HashMapNode *)parent child:(HashMapNode *)child {
    // 让parent称为子树的根节点
    parent.parent = grand.parent;
    if ([grand isLeftChild]) {
        grand.parent.left = parent;
    } else if ([grand isRightChild]) {
        grand.parent.right = parent;
    } else { // grand是root节点
        table[[self indexOfNode:grand]] = parent;
    }
    
    // 更新child的parent
    if (child != nil) {
        child.parent = grand;
    }
    
    // 更新grand的parent
    grand.parent = parent;
    
}

/// 重置数组
- (void)resetTable {
    for (NSUInteger i = 0; i < currentCapacity; i++) {
        [table addObject:null];
    }
}

/// 给节点染色
/// @param node 节点
/// @param color 颜色
- (HashMapNode *)colorNode:(HashMapNode *)node color:(BOOL)color {
    if (node == nil) return node;
    node.color = color;
    return node;
}

/// 把节点染成红色
/// @param node 节点
- (HashMapNode *)redNode:(HashMapNode *)node {
    return [self colorNode:node color:RED];
}

/// 把节点染成黑色
/// @param node 节点
- (HashMapNode *)blackNode:(HashMapNode *)node {
    return [self colorNode:node color:BLACK];
}

/// 返回给定节点的颜色
/// @param node 节点
- (BOOL)colorOfNode:(HashMapNode *)node {
    return node == nil ? BLACK : node.color;
}

/// 节点是否是黑色
/// @param node 节点
- (BOOL)isBlack:(HashMapNode *)node {
    return [self colorOfNode:node] == BLACK;
}

/// 节点是否是红色
/// @param node 节点
- (BOOL)isRed:(HashMapNode *)node {
    return [self colorOfNode:node] == RED;
}

@end
