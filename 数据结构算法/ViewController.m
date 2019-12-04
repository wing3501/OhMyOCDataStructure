//
//  ViewController.m
//  数据结构算法
//
//  Created by 申屠云飞 on 2019/10/21.
//  Copyright © 2019 styf. All rights reserved.
//

#import "ViewController.h"
#import "SingleLinkedList.h"
#import "SingleCircleLinkedList.h"
#import "CircleLinkedList.h"
#import "Stack.h"
#import "Queue.h"
#import "Deque.h"
#import "CircleQueue.h"
#import "CircleDeque.h"
#import "BinarySearchTree.h"
#import "LevelOrderPrinter.h"
#import "AVLTree.h"
#import "RBTree.h"
#import "ListSet.h"
#import "TreeSet.h"
#import "TreeMap.h"
#import "HashMap.h"
#import "Key.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self HashMapTest];
}

- (void)HashMapTest {
    HashMap<Key *,NSNumber *> *map = [[HashMap alloc]init];
//    [self HashMapTest1:map];
//    [self HashMapTest2:map];
    [self HashMapTest3:map];
}

- (void)HashMapTest3:(HashMap *)map {
    [map setObject:@1 forKey:@"jack"];
    [map setObject:@2 forKey:@"rose"];
    [map setObject:@3 forKey:@"jim"];
    [map setObject:@4 forKey:@"jake"];
    [map remove:@"jack"];
    [map remove:@"jim"];
    for (int i = 1; i <= 10; i++) {
        [map setObject:@(i) forKey:[NSString stringWithFormat:@"test%d",i]];
        [map setObject:@(i) forKey:[Key keyWithValue:i]];
    }
    for (int i = 5; i <= 7; i++) {
        NSLog(@"map.remove(new Key(%d)) == %d    %@",i,i,[map remove:[Key keyWithValue:i]]);
    }
    for (int i = 1; i <= 3; i++) {
        [map setObject:@(i + 5) forKey:[Key keyWithValue:i]];
    }
    
    NSLog(@"map.size() == 19  %d",map.size == 19);
    NSLog(@"map.get(new Key(1)) == 6  %@",[map objectForKey:[Key keyWithValue:1]]);
    NSLog(@"map.get(new Key(2)) == 7  %@",[map objectForKey:[Key keyWithValue:2]]);
    NSLog(@"map.get(new Key(3)) == 8  %@",[map objectForKey:[Key keyWithValue:3]]);
    NSLog(@"map.get(new Key(4)) == 4  %@",[map objectForKey:[Key keyWithValue:4]]);
    NSLog(@"map.get(new Key(5)) == null  %@",[map objectForKey:[Key keyWithValue:5]]);
    NSLog(@"map.get(new Key(6)) == null  %@",[map objectForKey:[Key keyWithValue:6]]);
    NSLog(@"map.get(new Key(7)) == null  %@",[map objectForKey:[Key keyWithValue:7]]);
    NSLog(@"map.get(new Key(8)) == 8  %@",[map objectForKey:[Key keyWithValue:8]]);
    NSLog(@"-------------------------");
    [map traversal:^BOOL(id  _Nonnull key, id  _Nonnull value) {
        NSLog(@"%@_%@",key,value);
        return NO;
    }];
}

- (void)HashMapTest2:(HashMap *)map {
    [map setObject:@1 forKey:nil];
    [map setObject:@2 forKey:[[NSObject alloc]init]];
    [map setObject:@3 forKey:@"jack"];
    [map setObject:@4 forKey:@10];
    [map setObject:@5 forKey:[[NSObject alloc]init]];
    [map setObject:@6 forKey:@"jack"];
    [map setObject:@7 forKey:@10];
    [map setObject:@8 forKey:nil];
    [map setObject:nil forKey:@10];
    
    NSLog(@"map.size == 5:  %d",map.size == 5);
    NSLog(@"map.get(null) == 8:  %d",[[map objectForKey:nil] isEqual: @8]);
    NSLog(@"map.get(\"jack\") == 6:  %d",[[map objectForKey:@"jack"] isEqual: @6]);
    NSLog(@"map.get(10) == null:  %d",[map objectForKey:@10] == nil);
    NSLog(@"map.get(new Object()) == null:  %d",[map objectForKey:[[NSObject alloc]init]] == nil);
    NSLog(@"map.containsKey(10):  %d",[map containsKey:@10]);
    NSLog(@"map.containsKey(null):  %d",[map containsKey:nil]);
    NSLog(@"map.containsValue(null):  %d",[map containsValue:nil]);
    NSLog(@"map.containsValue(1) == false:  %d",[map containsValue:@1] == NO);
}

- (void)HashMapTest1:(HashMap *)map {
    for (NSInteger i = 1; i <= 20; i++) {
        [map setObject:@(i) forKey:[Key keyWithValue:i]];
    }
    for (NSInteger i = 5; i <= 7; i++) {
        [map setObject:@(i + 5) forKey:[Key keyWithValue:i]];
    }
    
    NSLog(@"map.size == 20:  %d",map.size == 20);
    NSLog(@"map.get(new Key(4)) == 4:  %d",[[map objectForKey:[Key keyWithValue:4]] integerValue] == 4);
    NSLog(@"map.get(new Key(5)) == 10:  %d",[[map objectForKey:[Key keyWithValue:5]] integerValue] == 10);
    NSLog(@"map.get(new Key(6)) == 11:  %d",[[map objectForKey:[Key keyWithValue:6]] integerValue] == 11);
    NSLog(@"map.get(new Key(7)) == 12:  %d",[[map objectForKey:[Key keyWithValue:7]] integerValue] == 12);
    NSLog(@"map.get(new Key(8)) == 8:  %d",[[map objectForKey:[Key keyWithValue:8]] integerValue] == 8);
}

- (void)TreeMapTest {
    TreeMap<NSString *,NSNumber *> *map = [TreeMap mapWithComparator:^NSComparisonResult(NSString *  _Nonnull key1, NSString *  _Nonnull key2) {
        return [key1 compare:key2];
    }];
    [map setObject:@2 forKey:@"c"];
    [map setObject:@5 forKey:@"a"];
    [map setObject:@6 forKey:@"b"];
    [map setObject:@8 forKey:@"a"];
    
    TreeMapVisitor<NSString *,NSNumber *> *visitor = [TreeMapVisitor visitorWithBlock:^BOOL(id  _Nonnull key, id  _Nonnull value) {
        NSLog(@"-----------key:%@ value:%@",key,value);
        return NO;
    }];
    [map traversal:visitor];
}

- (void)SetTest2 {
    NSMutableArray *array = @[].mutableCopy;
    for (NSInteger i = 0; i < 10000; i++) {
        [array addObject:@(i)];
    }

    ListSet *listSet = [[ListSet alloc]init];
    [self costTime:^{
        for (NSInteger i = 0; i < array.count; i++) {
            [listSet addObject:array[i]];
        }
        for (NSInteger i = 0; i < array.count; i++) {
            [listSet containsObject:array[i]];
        }
        for (NSInteger i = 0; i < array.count; i++) {
            [listSet removeObject:array[i]];
        }
    }];


    TreeSet *treeSet = [TreeSet setWithComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        if (obj1.integerValue > obj2.integerValue) {
            return NSOrderedDescending;
        }else if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];

    [self costTime:^{
        for (NSInteger i = 0; i < array.count; i++) {
            [treeSet addObject:array[i]];
        }
        for (NSInteger i = 0; i < array.count; i++) {
            [treeSet containsObject:array[i]];
        }
        for (NSInteger i = 0; i < array.count; i++) {
            [treeSet removeObject:array[i]];
        }
    }];
}

/// 计算代码执行时间
/// @param block 代码
- (void)costTime:(void(^)(void))block {
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    block();
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"Linked in %f ms", linkTime *1000.0);
}

- (void)SetTest {
    Visitor *visitor = [[Visitor alloc]init];
    visitor.visitorBlock = ^BOOL(id  _Nonnull value) {
        NSLog(@"遍历===>%@",value);
        return NO;
    };
    
    ListSet *listSet = [[ListSet alloc]init];
    [listSet addObject:@10];
    [listSet addObject:@11];
    [listSet addObject:@11];
    [listSet addObject:@12];
    [listSet addObject:@10];
    
//    [listSet traversal:visitor];
    
    TreeSet *treeSet = [TreeSet setWithComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        if (obj1.integerValue > obj2.integerValue) {
            return NSOrderedDescending;
        }else if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    [treeSet addObject:@10];
    [treeSet addObject:@11];
    [treeSet addObject:@11];
    [treeSet addObject:@12];
    [treeSet addObject:@10];
    
    [treeSet traversal:visitor];
}

- (void)RBTreeTest {
    RBTree *bst = [RBTree treeWithComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        if (obj1.integerValue > obj2.integerValue) {
            return NSOrderedDescending;
        }else if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    NSArray<NSNumber *> *data = @[@55, @87, @56, @74, @96, @22, @62, @20, @70, @68, @90, @50];
    for (NSNumber *num in data) {
        [bst add:num];
        LevelOrderPrinter *printer = [LevelOrderPrinter printerWithTree:bst];
        [printer print];
        NSLog(@"---------------------------------------");
    }
    
}

- (void)AVLTreeTest {
    AVLTree *bst = [AVLTree treeWithComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        if (obj1.integerValue > obj2.integerValue) {
            return NSOrderedDescending;
        }else if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    NSArray<NSNumber *> *data = @[@67, @52, @92, @96, @53, @95, @13, @63, @34,@82, @76, @54, @9,@68,@39];
    for (NSNumber *num in data) {
        [bst add:num];
    }
    [bst remove:@9];
    LevelOrderPrinter *printer = [LevelOrderPrinter printerWithTree:bst];
    [printer print];
}

- (void)BinarySearchTreeTest {
    BinarySearchTree *bst = [BinarySearchTree treeWithComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
        if (obj1.integerValue > obj2.integerValue) {
            return NSOrderedDescending;
        }else if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    NSArray<NSNumber *> *data = @[@7, @4, @9, @2, @5, @8, @11, @3, @12, @1];
    for (NSNumber *num in data) {
        [bst add:num];
    }
    [bst remove:@5];
    
//    Visitor *visitor = [[Visitor alloc]init];
//    visitor.visitorBlock = ^BOOL(id  _Nonnull value) {
//        return NO;
//    };
//    [bst levelOrder:visitor];
    
    LevelOrderPrinter *printer = [LevelOrderPrinter printerWithTree:bst];
    [printer print];
}

/// 双端循环队列测试
- (void)circleDequeTest {
    CircleDeque *queue = [[CircleDeque alloc]init];
    // 头5 4 3 2 1  100 101 102 103 104 105 106 8 7 6 尾
    
    // 头 8 7 6  5 4 3 2 1  100 101 102 103 104 105 106 107 108 109 null null 10 9 尾
    for (int i = 0; i < 10; i++) {
        [queue enQueueFront:@(i + 1)];
        [queue enQueueRear:@(i + 100)];
    }
    
//    NSLog(@"%@",queue);
    
    // 头 null 7 6  5 4 3 2 1  100 101 102 103 104 105 106 null null null null null null null 尾
    for (int i = 0; i < 3; i++) {
        [queue deQueueFront];
        [queue deQueueRear];
    }
//    NSLog(@"%@",queue);
    
//    // 头 11 7 6  5 4 3 2 1  100 101 102 103 104 105 106 null null null null null null 12 尾
    [queue enQueueFront:@(11)];
    [queue enQueueFront:@(12)];
    NSLog(@"%@",queue);
    
}

/// 循环队列测试
- (void)circleQueueTest {
    CircleQueue *queue = [[CircleQueue alloc]init];
    // 0 1 2 3 4 5 6 7 8 9
    for (int i = 0; i < 10; i++) {
        [queue enQueue:@(i)];
    }
    NSLog(@"%@",queue);
    // null null null null null 5 6 7 8 9
    for (int i = 0; i < 5; i++) {
        [queue deQueue];
    }
    NSLog(@"%@",queue);
    // 15 16 17 18 19 5 6 7 8 9
    for (int i = 15; i < 20; i++) {
        [queue enQueue:@(i)];
    }
    NSLog(@"%@",queue);
    while (!queue.isEmpty) {
        NSLog(@"出队：%@",[queue deQueue]);
    }
    NSLog(@"%@",queue);
}

/// 双端队列测试
- (void)dequeTest {
    Deque<NSNumber *> *queue = [[Deque alloc]init];
    [queue enQueueFront:@11];
    [queue enQueueFront:@22];
    [queue enQueueRear:@33];
    [queue enQueueRear:@44];
    NSLog(@"%@",queue.description);
    /* 尾  44  33   11  22 头 */
    while (!queue.isEmpty) {
        NSLog(@"删除:%@",[queue deQueueRear]);
    }
}

/// 队列测试
- (void)queueTest {
    Queue<NSNumber *> *queue = [[Queue alloc]init];
    [queue enQueue:@11];
    [queue enQueue:@22];
    [queue enQueue:@33];
    [queue enQueue:@44];
    while (!queue.isEmpty) {
        NSLog(@"删除:%@",[queue deQueue]);
    }
}

/// 栈测试
- (void)stackTest {
    Stack *stack = [[Stack alloc]init];
    [stack push:@11];
    [stack push:@22];
    [stack push:@33];
    [stack push:@44];
    while (!stack.isEmpty) {
        NSLog(@"删除:%@",[stack pop]);
    }
}

/// 双向循环链表测试
- (void)circleLinkedListTest {
    CircleLinkedList *list = [[CircleLinkedList alloc]init];
    for (NSUInteger i = 1; i <= 8; i++) {
        [list addObject:@(i)];
    }//1 2 3 4 5 6 7 8
    
    [list reset];
    while (![list isEmpty]) {
        [list next];
        [list next];
        NSLog(@"删除====>%@",list.remove);
    }
}

/// 单向链表测试
- (void)singleLinkedListTest {
    SingleLinkedList *list = [[SingleLinkedList alloc]init];
    [list addObject:@11];
    [list addObject:@22];
    [list addObject:@33];
    [list addObject:@44];
    
    [list insertObject:@55 atIndex:0];// [55, 11, 22, 33, 44]
    [list insertObject:@66 atIndex:2];// [55, 11, 66, 22, 33, 44]
    [list insertObject:@77 atIndex:list.size];// [55, 11, 66, 22, 33, 44, 77]
    
    [list removeObjectAtIndex:0]; // [11, 66, 22, 33, 44, 77]
    [list removeObjectAtIndex:2]; // [11, 66, 33, 44, 77]
    [list removeObjectAtIndex:list.size - 1]; // [11, 66, 33, 44]
    
    NSAssert([list indexOfObject:@44] == 3,@"校验失败");
    NSAssert([list indexOfObject:@22] == ELEMENT_NOT_FOUND,@"校验失败");
    NSAssert([list containsObject:@33],@"校验失败");
    NSAssert([[list objectAtIndex:0] isEqual:@11],@"校验失败");
    NSAssert([[list objectAtIndex:1] isEqual:@66],@"校验失败");
    NSAssert([[list objectAtIndex:list.size - 1] isEqual:@44],@"校验失败");
    
    NSLog(@"%@",list);
}

- (void)Assert:(BOOL)test {
    NSAssert(test, @"校验失败");
}

@end
