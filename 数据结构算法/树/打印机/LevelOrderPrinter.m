//
//  LevelOrderPrinter.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/11/25.
//  Copyright © 2019 styf. All rights reserved.
//

#import "LevelOrderPrinter.h"
#import "Queue.h"
static NSInteger const TOP_LINE_SPACE = 1;//顶部符号距离父节点的最小距离（最小能填0）
static NSInteger const MIN_SPACE = 1;//节点之间允许的最小间距（最小只能填1）

@interface PrintNode : NSObject
/// <#name#>
@property (nonatomic, strong) NSObject *btNode;
/// <#name#>
@property (nonatomic, strong) PrintNode *left;
/// <#name#>
@property (nonatomic, strong) PrintNode *right;
/// <#name#>
@property (nonatomic, strong) PrintNode *parent;

//首字符的位置
/// <#name#>
@property (nonatomic, assign) NSInteger x;
/// <#name#>
@property (nonatomic, assign) NSInteger y;
/// <#name#>
@property (nonatomic, assign) NSInteger treeHeight;
/// <#name#>
@property (nonatomic, copy) NSString *string;
/// <#name#>
@property (nonatomic, assign) NSInteger width;
@end

@interface LevelInfo : NSObject
/// <#name#>
@property (nonatomic, assign) NSInteger leftX;
/// <#name#>
@property (nonatomic, assign) NSInteger rightX;

+ (instancetype)levelInfoWithLeft:(PrintNode *)left right:(PrintNode *)right;
@end

@interface LevelOrderPrinter()
/// 二叉树的基本信息
@property (nonatomic, strong) id<BinaryTreeInfo> tree;
/// <#name#>
@property (nonatomic, strong) PrintNode *root;
/// <#name#>
@property (nonatomic, assign) NSInteger minX;
/// <#name#>
@property (nonatomic, assign) NSInteger maxWidth;
@end

@implementation PrintNode
- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = string;
    }
    return self;
}

+ (instancetype)nodeWithString:(NSString *)string {
    return [[PrintNode alloc]initWithString:string];
}

+ (instancetype)nodeWithBtNode:(NSObject *)btNode opetaion:(NSObject<BinaryTreeInfo> *)opetaion {
    PrintNode *node = [[PrintNode alloc]initWithString:[opetaion string:btNode]];
    node.btNode = btNode;
    return node;
}

/// 顶部方向字符的X（极其重要）
- (NSInteger)topLineX {
    // 宽度的一半
    NSInteger delta = _width;
    if (delta % 2 == 0) {
        delta--;
    }
    delta >>= 1;

    if (_parent != nil && self == _parent.left) {
        return [self rightX] - 1 - delta;
    } else {
        return _x + delta;
    }
}
/// 右边界的位置（rightX 或者 右子节点topLineX的下一个位置）（极其重要）
- (NSInteger)rightBound {
    if (_right == nil) {
        return [self rightX];
    }
    return [_right topLineX] + 1;
}

/// 左边界的位置（x 或者 左子节点topLineX）（极其重要）
- (NSInteger)leftBound {
    if (_left == nil) {
        return _x;
    }
    return [_left topLineX];
}

/// x ~ 左边界之间的长度（包括左边界字符）
- (NSInteger)leftBoundLength {
    return _x - [self leftBound];
}

/// rightX ~ 右边界之间的长度（包括右边界字符）
- (NSInteger)rightBoundLength {
    return [self rightBound] - [self rightX];
}

/// 左边界可以清空的长度
- (NSInteger)leftBoundEmptyLength {
    return [self leftBoundLength] - 1 - TOP_LINE_SPACE;
}

/// 右边界可以清空的长度
- (NSInteger)rightBoundEmptyLength {
    return [self rightBoundLength] - 1 - TOP_LINE_SPACE;
}

/// 让left和right基于this对称
- (void)balanceWithLeft:(PrintNode *)left right:(PrintNode *)right {
    if (left == nil || right == nil) {
        return;
    }
    //【left的尾字符】与【this的首字符】之间的间距
    NSInteger deltaLeft = _x - [left rightX];
    // 【this的尾字符】与【this的首字符】之间的间距
    NSInteger deltaRight = right.x - [self rightX];
    
    NSInteger delta = MAX(deltaLeft, deltaRight);
    NSInteger newRightX = [self rightX] + delta;
    [right translateX:newRightX - right.x];
    
    NSInteger newLeftX = _x - delta - left.width;
    [left translateX:newLeftX - left.x];
}

- (NSInteger)treeHeight:(PrintNode *)node {
    if (node == nil) return 0;
    if (node.treeHeight != 0) return node.treeHeight;
    node.treeHeight = 1 + MAX([self treeHeight:node.left], [self treeHeight:node.right]);
    return node.treeHeight;
}

/// 和右节点之间的最小层级距离
- (NSInteger)minLevelSpaceToRight:(PrintNode *)right {
    NSInteger thisHeight  = [self treeHeight:self];
    NSInteger rightHeight = [self treeHeight:right];
    NSInteger minSpace = NSIntegerMax;
    for (NSInteger i = 0; i < thisHeight && i < rightHeight; i++) {
        NSInteger space = [right levelInfo:i].leftX - [self levelInfo:i].rightX;
        minSpace = MIN(minSpace, space);
    }
    return minSpace;
}

- (LevelInfo *)levelInfo:(NSInteger)level {
    if (level < 0) return nil;
    NSInteger levelY = _y + level;
    if (level >= [self treeHeight:self]) return nil;
    
    NSMutableArray<PrintNode *> *list = @[].mutableCopy;
    Queue<PrintNode *> *queue = [[Queue alloc]init];
    [queue enQueue:self];
    // 层序遍历找出第level行的所有节点
    while (!queue.isEmpty) {
        PrintNode *node = [queue deQueue];
        if (levelY == node.y) {
            [list addObject:node];
        }else if (node.y > levelY) {
            break;
        }
        
        if (node.left != nil) {
            [queue enQueue:node.left];
        }
        if (node.right != nil) {
            [queue enQueue:node.right];
        }
    }
    
    PrintNode *left = list.firstObject;
    PrintNode *right = list.lastObject;
    return [LevelInfo levelInfoWithLeft:left right:right];
}

- (void)translateX:(NSInteger)deltaX {
    if (deltaX == 0) {
        return;
    }
    _x += deltaX;
    // 如果是LineNode
    if (_btNode == nil) {
        return;
    }
    
    if (_left != nil) {
        [_left translateX:deltaX];
    }
    if (_right != nil) {
        [_right translateX:deltaX];
    }
}

/// 尾字符的下一个位置
- (NSInteger)rightX {
    return _x + _width;
}
@end

@implementation LevelInfo

- (instancetype)initWithLeft:(PrintNode *)left right:(PrintNode *)right {
    self = [super init];
    if (self) {
        _leftX = [left leftBound];
        _rightX = [right rightBound];
    }
    return self;
}

+ (instancetype)levelInfoWithLeft:(PrintNode *)left right:(PrintNode *)right {
    return [[LevelInfo alloc]initWithLeft:left right:right];
}

@end

@implementation LevelOrderPrinter

- (instancetype)initWithTree:(id<BinaryTreeInfo>)tree {
    self = [super init];
    if (self) {
        _tree = tree;
        _root = [PrintNode nodeWithBtNode:tree.root opetaion:tree];
        _maxWidth = _root.width;
    }
    return self;
}

+ (instancetype)printerWithTree:(id<BinaryTreeInfo>)tree {
    return [[LevelOrderPrinter alloc]initWithTree:tree];
}

- (void)print {
    NSLog(@"\n%@",[self printString]);
}

- (NSString *)printString {
    // nodes用来存放所有的节点
    NSMutableArray<NSMutableArray<PrintNode *> *> *nodes = @[].mutableCopy;
    [self fillNodes:nodes];
    [self cleanNodes:nodes];
    [self compressNodes:nodes];
    [self addLineNodes:nodes];

    NSInteger rowCount = nodes.count;

    // 构建字符串
    NSMutableString *string = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i < rowCount; i++) {
        if (i != 0) {
            [string appendString:@"\n"];
        }
        NSMutableArray<PrintNode *> *rowNodes = [nodes objectAtIndex:i];
        NSMutableString *rowSb = [[NSMutableString alloc]init];
        for (PrintNode *node in rowNodes) {
            NSInteger leftSpace = node.x - rowSb.length - _minX;
            for (NSInteger j = 0; j < leftSpace; j++) {
                [rowSb appendString:@" "];
            }
            [rowSb appendString:[node string]];
        }
        
        [string appendString:rowSb];
    }
    
    return string;
}

/// 添加一个元素节点
- (PrintNode *)addNode:(NSMutableArray *)nodes btNode:(NSObject *)btNode {
    PrintNode *node = nil;
    if (btNode != nil) {
        node = [PrintNode nodeWithBtNode:btNode opetaion:_tree];
        _maxWidth = MAX(_maxWidth, node.width);
        [nodes addObject:node];
    }else {
        [nodes addObject:[NSNull null]];
    }
    return node;
}

/// 以满二叉树的形式填充节点
- (void)fillNodes:(NSMutableArray<NSMutableArray<PrintNode *> *> *)nodes {
    if (nodes == nil) return;
    // 第一行
    NSMutableArray<PrintNode *> *firstRowNodes = @[].mutableCopy;
    [firstRowNodes addObject:_root];
    [nodes addObject:firstRowNodes];
    
    // 其他行
    while (YES) {
        NSMutableArray<PrintNode *> *preRowNodes = [nodes objectAtIndex:nodes.count - 1];
        NSMutableArray *rowNodes = @[].mutableCopy;
        
        BOOL notNull = NO;
        for (PrintNode *node in preRowNodes) {
            if (node == nil || [node isKindOfClass:[NSNull class]]) {
                [rowNodes addObject:[NSNull null]];
                [rowNodes addObject:[NSNull null]];
            }else {
                PrintNode *left = [self addNode:rowNodes btNode:[_tree left:node.btNode]];
                if (left != nil) {
                    node.left = left;
                    left.parent = node;
                    notNull = YES;
                }
                
                PrintNode *right = [self addNode:rowNodes btNode:[_tree right:node.btNode]];
                if (right != nil) {
                    node.right = right;
                    right.parent = node;
                    notNull = YES;
                }
            }
        }
        
        // 全是null，就退出
        if (!notNull) break;
        [nodes addObject:rowNodes];
    }
}

/// 删除全部null、更新节点的坐标
- (void)cleanNodes:(NSMutableArray<NSMutableArray<PrintNode *> *> *)nodes {
    if (nodes == nil) return;
    NSInteger rowCount = nodes.count;
    if (rowCount < 2) return;
    
    // 最后一行的节点数量
    NSInteger lastRowNodeCount = nodes.lastObject.count;
    
    // 每个节点之间的间距
    NSInteger nodeSpace = _maxWidth + 2;
    
    //最后一行的长度
    NSInteger lastRowLength = lastRowNodeCount * _maxWidth
    + nodeSpace * (lastRowNodeCount - 1);
    
    // 空集合
    NSMutableArray *nullSet = @[].mutableCopy;

    for (NSInteger i = 0; i < rowCount; i++) {
        NSMutableArray<PrintNode *> *rowNodes = [nodes objectAtIndex:i];
        
        NSInteger rowNodeCount = rowNodes.count;
        // 节点左右两边的间距
        NSInteger allSpace = lastRowLength - (rowNodeCount - 1) * nodeSpace;
        NSInteger cornerSpace = allSpace / rowNodeCount - _maxWidth;
        cornerSpace >>= 1;
        
        NSInteger rowLength = 0;
        for (NSInteger j = 0; j < rowNodeCount; j++) {
            if (j != 0) {
                // 每个节点之间的间距
                rowLength += nodeSpace;
            }
            rowLength += cornerSpace;
            PrintNode *node = [rowNodes objectAtIndex:j];
            if (![node isKindOfClass:[NSNull class]]) {
                // 居中（由于奇偶数的问题，可能有1个符号的误差）
                NSInteger deltaX = (_maxWidth - node.width) >> 1;
                node.x = rowLength + deltaX;
                node.y = i;
            }else{
                [nullSet addObject:node];
            }
            rowLength += _maxWidth;
            rowLength += cornerSpace;
        }
        // 删除所有的null
        [rowNodes removeObjectsInArray:nullSet];
    }
}

/// 压缩空格
- (void)compressNodes:(NSMutableArray<NSMutableArray<PrintNode *> *> *)nodes {
    if (nodes == nil) return;

    NSInteger rowCount = nodes.count;
    if (rowCount < 2) return;

    for (NSInteger i = rowCount - 2; i >= 0; i--) {
        NSMutableArray<PrintNode *> *rowNodes = [nodes objectAtIndex:i];
        for (PrintNode *node in rowNodes) {
            PrintNode *left = node.left;
            PrintNode *right = node.right;
            if ([left isKindOfClass:[NSNull class]] && [right isKindOfClass:[NSNull class]]) {
                continue;
            }
            if (![left isKindOfClass:[NSNull class]] && ![right isKindOfClass:[NSNull class]]) {
                //让左右节点对称
                [node balanceWithLeft:left right:right];
                
                //left和right之间可以挪动的最小间距
                NSInteger leftEmpty = [node leftBoundEmptyLength];
                NSInteger rightEmpty = [node rightBoundEmptyLength];
                NSInteger empty = MIN(leftEmpty, rightEmpty);
                empty = MIN(empty, (right.x - [left rightX]) >> 1);
                
                // left、right的子节点之间可以挪动的最小间距
                NSInteger space = [left minLevelSpaceToRight:right] - MIN_SPACE;
                space = MIN(space >> 1, empty);

                // left、right往中间挪动
                if (space > 0) {
                    [left translateX:space];
                    [right translateX:-space];
                }

                // 继续挪动
                space = [left minLevelSpaceToRight:right] - MIN_SPACE;
                if (space < 1) continue;

                // 可以继续挪动的间距
                leftEmpty = [node leftBoundEmptyLength];
                rightEmpty = [node rightBoundEmptyLength];
                if (leftEmpty < 1 && rightEmpty < 1) continue;

                if (leftEmpty > rightEmpty) {
                    [left translateX:MIN(leftEmpty, space)];
                } else {
                    [right translateX:-MIN(rightEmpty, space)];
                }
            }else if (![left isKindOfClass:[NSNull class]]) {
                [left translateX:[node leftBoundEmptyLength]];
            } else { // right != null
                [right translateX:-[node rightBoundEmptyLength]];
            }
        }
    }
}

- (void)addXLineNode:(NSMutableArray<PrintNode *> *)curRow parent:(PrintNode *)parent x:(NSInteger)x {
    PrintNode *line = [PrintNode nodeWithString:@"─"];
    line.x = x;
    line.y = parent.y;
    [curRow addObject:line];
}

- (PrintNode *)addLineNode:(NSMutableArray<PrintNode *> *)curRow nextRow:(NSMutableArray<PrintNode *> *)nextRow parent:(PrintNode *)parent child:(PrintNode *)child {
    if (child == nil) {
        return nil;
    }
    PrintNode *top = nil;
    NSInteger topX = [child topLineX];
    if (child == parent.left) {
        top = [PrintNode nodeWithString:@"┌"];
        [curRow addObject:top];
        
        for (NSInteger x = topX + 1; x < parent.x; x++) {
            [self addXLineNode:curRow parent:parent x:x];
        }
    }else {
        for (NSInteger x = [parent rightX]; x < topX; x++) {
            [self addXLineNode:curRow parent:parent x:x];
        }
        top = [PrintNode nodeWithString:@"┐"];
        [curRow addObject:top];
    }
    
    // 坐标
    top.x = topX;
    top.y = parent.y;
    child.y = parent.y + 2;
    _minX = MIN(_minX, child.x);

    // 竖线
    PrintNode *bottom = [PrintNode nodeWithString:@"│"];
    bottom.x = topX;
    bottom.y = parent.y + 1;
    [nextRow addObject:bottom];
    
    return top;
}

- (void)addLineNodes:(NSMutableArray<NSMutableArray<PrintNode *> *> *)nodes {
    NSMutableArray<NSMutableArray<PrintNode *> *> *newNodes = @[].mutableCopy;
    
    NSInteger rowCount = nodes.count;
    if (rowCount < 2) return;

    _minX = _root.x;

    for (NSInteger i = 0; i < rowCount; i++) {
        NSMutableArray<PrintNode *> *rowNodes = [nodes objectAtIndex:i];
        if (i == rowCount - 1) {
            [newNodes addObject:rowNodes];
            continue;
        }

        NSMutableArray<PrintNode *> *newRowNodes = @[].mutableCopy;
        [newNodes addObject:newRowNodes];

        NSMutableArray<PrintNode *> *lineNodes = @[].mutableCopy;
        [newNodes addObject:lineNodes];
        for (PrintNode *node in rowNodes) {
            [self addLineNode:newRowNodes nextRow:lineNodes parent:node child:node.left];
            [newRowNodes addObject:node];
            [self addLineNode:newRowNodes nextRow:lineNodes parent:node child:node.right];
        }
    }

    [nodes removeAllObjects];
    [nodes addObjectsFromArray:newNodes];
}

@end
