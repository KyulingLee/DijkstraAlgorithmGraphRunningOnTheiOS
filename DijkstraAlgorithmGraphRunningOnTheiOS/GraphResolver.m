//
//  GraphResolver.m
//  DijkstraAlgorithmGraphRunningOnTheiOS
//
//  Created by Lee Bong Kyu on 2013. 11. 27..
//  Copyright (c) 2013년 Lee Bong Kyu. All rights reserved.
//

#import "GraphResolver.h"
#import "GraphNodeItem.h"

@implementation GraphResolver

-(void)dijkstrasOnConnections:(NSMutableDictionary *)connections nodes:(NSMutableDictionary *)nodes withStartNode:(NSString *)startID endNode:(NSString *)endID andCompletionHandler:(void (^)(NSMutableArray *, NSInteger))callback {
    
    for (int i = 0; i < [[nodes allKeys] count]; i++) {
        GraphNodeItem *currentItem = [nodes objectForKey:[[nodes allKeys] objectAtIndex:i]];
        currentItem.distance = INFINITY;
    }
    
    for (NSArray *pair in connections) {
        [[[nodes objectForKey:[[pair objectAtIndex:0] nodeTag]] neighbours] setObject:[connections objectForKey:pair] forKey:[[pair objectAtIndex:1] nodeTag]];
        [[[nodes objectForKey:[[pair objectAtIndex:1] nodeTag]] neighbours] setObject:[connections objectForKey:pair] forKey:[[pair objectAtIndex:0] nodeTag]];
    }
    
    [[nodes objectForKey:startID] setDistance:0];
    
    NSMutableDictionary *duplicationNodes = [NSMutableDictionary dictionaryWithDictionary:nodes];
    
    GraphNodeItem *currentNode;
    currentNode = [duplicationNodes objectForKey:startID];
    
    duplicationNodes = [self sortNodes:duplicationNodes];
    
    while ([[duplicationNodes allKeys] count] > 0) {
        
        NSString *shortID = [self lightestNodeOnGraph:duplicationNodes];
        currentNode = [duplicationNodes objectForKey:shortID];
        //스캔된 제일 짧은 녀석 가져오기
        [duplicationNodes removeObjectForKey:currentNode.nodeTag];
        
        for (NSString *neighbour in currentNode.neighbours) {
            
            NSInteger distance = currentNode.distance + [[currentNode.neighbours objectForKey:neighbour] integerValue];
            
            if ([[nodes objectForKey:neighbour] distance] > distance)
                [[nodes objectForKey:neighbour] setDistance:distance];
        }
        
        [[nodes objectForKey:startID] setDistance:INFINITY];
        
        if ([[self lightestNodeOnGraph:duplicationNodes] isEqualToString:endID])
            break;
    }
    
    NSLog(@"Final weight of path: %i", [[nodes objectForKey:endID] distance]);
    
    [[nodes objectForKey:startID] setDistance:0];
    
    NSMutableArray *optimumPath = [[NSMutableArray alloc] init];
    
    GraphNodeItem *node = [nodes objectForKey:endID];
    
    while (![node.nodeTag isEqualToString:startID]) {
    
        [optimumPath addObject:node.nodeTag];
        
        // 스캔해서 모든 거리를 찾아서 처리한다.
        for (NSString *n in node.neighbours) {
            //옵티멀한 거리를 찾아서 처리한다.
            //찾아서 처리하면 반복문을 빠진다.
            if ([[nodes objectForKey:n] distance] == node.distance - [[node.neighbours objectForKey:n] integerValue]) {
                node = [nodes objectForKey:n];
                break;
            }
        }
    }
    
    [optimumPath addObject:startID];
    
    optimumPath = [NSMutableArray arrayWithArray:[[optimumPath reverseObjectEnumerator] allObjects]];
    
    callback(optimumPath, [[nodes objectForKey:endID] distance]);
}

//KYULING: 노드 두개에서 아이템 거리를 비교한다.
-(NSInteger)distanceBetween:(GraphNodeItem *)item1 and:(GraphNodeItem *)item2 forConnections:(NSMutableDictionary *)connections {
    for (NSArray *pair in connections) {
        
        if (([[[pair objectAtIndex:0] nodeTag] isEqualToString:item1.nodeTag] || [[[pair objectAtIndex:0] nodeTag] isEqualToString:item2.nodeTag])
            && ([[[pair objectAtIndex:1] nodeTag] isEqualToString:item1.nodeTag] || [[[pair objectAtIndex:1] nodeTag] isEqualToString:item2.nodeTag])) {
            return [(NSNumber *)[connections objectForKey:pair] integerValue];
        }
    }
    
    return INFINITY;
}

//KYULING: weight에 따라 노드를 정렬시킨다.
-(NSMutableDictionary *)sortNodes:(NSMutableDictionary *)dictionary {
    NSArray *allNodes = [dictionary allValues];
    
    NSArray *sortedArray = [allNodes sortedArrayUsingComparator:^NSComparisonResult(GraphNodeItem *item1, GraphNodeItem *item2) {
        return [[NSNumber numberWithInteger:item1.distance] compare:[NSNumber numberWithInteger:item2.distance]];
    }];
    
    NSMutableDictionary *sortedDict = [[NSMutableDictionary alloc] init];
    
    for (GraphNodeItem *item in sortedArray) {
        [sortedDict setObject:item forKey:item.nodeTag];
    }
    
    return sortedDict;
}

//KYULING: 그래프에서 가벼운 노드를 리턴시킨다.
-(NSString *)lightestNodeOnGraph:(NSMutableDictionary *)includedNodes {
    NSArray *sortedArray = [includedNodes.allValues sortedArrayUsingComparator:^NSComparisonResult(GraphNodeItem *first, GraphNodeItem *second) {
        return [[NSNumber numberWithInteger:first.distance] compare:[NSNumber numberWithInteger:second.distance]];
    }];
    
    return [[includedNodes allKeysForObject:[sortedArray objectAtIndex:0]] objectAtIndex:0];
}


@end
