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
    
    // 현재 어떠한 노드도 연결되어 있지 않을 때, 초기화 시킵니다
    for (int i = 0; i < [[nodes allKeys] count]; i++) {
        GraphNodeItem *currentItem = [nodes objectForKey:[[nodes allKeys] objectAtIndex:i]];
        currentItem.distance = INFINITY;
    }
    
    // 제공된 모든 연결을 분석하고 각 노드의 이웃 관계를 설정한다
    for (NSArray *pair in connections) {
        //서로가 1:1로 연결된 상태에서 각자의 연결된 노드 ID와 거리를 측정해 저장한다
        [[[nodes objectForKey:[[pair objectAtIndex:0] nodeTag]] neighbours] setObject:[connections objectForKey:pair] forKey:[[pair objectAtIndex:1] nodeTag]];
        [[[nodes objectForKey:[[pair objectAtIndex:1] nodeTag]] neighbours] setObject:[connections objectForKey:pair] forKey:[[pair objectAtIndex:0] nodeTag]];
    }
    
    //그래프의 시작 노드를 추가한다
    [[nodes objectForKey:startID] setDistance:0];
    
    //그래프의 모든 분석되지 않은 노드를 저장할 저장소를 만듭니다. 파싱이 완료되면, 각각의 노드는 여기에서 제거될 겁니다
    NSMutableDictionary *duplicationNodes = [NSMutableDictionary dictionaryWithDictionary:nodes];
    
    //그래프의 시작 노드를 currentNode로 설정한다
    GraphNodeItem *currentNode;
    currentNode = [duplicationNodes objectForKey:startID];
    
    //분석되지 않은 노드들을 정렬한다. 빨리 결과 처리를 진행하기 위해서 이용한다
    duplicationNodes = [self sortNodes:duplicationNodes];
    
    //그래프에 스캔되지 않은 노드가 있으면 계속 동작한다. (그래프 스캔 작업)
    while ([[duplicationNodes allKeys] count] > 0) {
        //그래프 또는 작업된 것들 중에서 가장 짧은 노드 찾기
        NSString *shortID = [self lightestNodeOnGraph:duplicationNodes];
        currentNode = [duplicationNodes objectForKey:shortID];
        
        //가장 짧은 노드가 복제된 대기열에서 제거되도록 한다
        [duplicationNodes removeObjectForKey:currentNode.nodeTag];
        
        // 가장 짧은 노드의 이웃을 모두 확인한다
        for (NSString *neighbour in currentNode.neighbours) {
            
            // 현재의 노드를 통해 연결된 이웃 노드의 거리를 얻어온다
            NSInteger distance = currentNode.distance + [[currentNode.neighbours objectForKey:neighbour] integerValue];
            
            //이전 이웃의 거리가 새로운 노드의 거리보다 큰 경우에는 참조한다
            if ([[nodes objectForKey:neighbour] distance] > distance)
                //만약 그렇다면, 이웃의 거리를 업데이트한다
                [[nodes objectForKey:neighbour] setDistance:distance];
        }
        
        //시작 노드가 재포착되지 않도록 직접 거리를 설정
        //이러면 시작 노드를 다시 스캔할 일이 없어진다
        [[nodes objectForKey:startID] setDistance:INFINITY];
        
        //만약 끝 노드에 도달했을 경우, 반복문을 끝낸다.
        if ([[self lightestNodeOnGraph:duplicationNodes] isEqualToString:endID])
            break;
    }
    
    // Set the start node's weight to 0, preparing it for the parsing
    //구문 분석을 위해 준비하고, 0으로 시작 노드의 무게를 설정
    [[nodes objectForKey:startID] setDistance:0];
    
    // 최적의 경로의 노드를 보유할 배열을 생성한다
    NSMutableArray *optimumPath = [[NSMutableArray alloc] init];
    
    // 현재 노드를 앤드 노드로 설정해서 받아온다
    GraphNodeItem *node = [nodes objectForKey:endID];
    
    //시작 노드에 도달할 때까지 반복한다
    while (![node.nodeTag isEqualToString:startID]) {
        // 최적의 노드를 현재 경로에 추가한다
        [optimumPath addObject:node.nodeTag];
        
        //경로에 다음을 찾을 수 있도록 현재 노드의 모든 이웃을 통해 스캔한다
        for (NSString *n in node.neighbours) {
            //최적 경로 다음에 이웃 노드가 있는지 확인한다
            //만약 있다면, 이 for문을 나가고 지금 작업하고 있는 노드에서 계속 진행한다
            if ([[nodes objectForKey:n] distance] == node.distance - [[node.neighbours objectForKey:n] integerValue]) {
                node = [nodes objectForKey:n];
                break;
            }
        }
    }
    
    //경로에 첫 번째 노드를 추가
    [optimumPath addObject:startID];
    
    // 화면에 보기 쉽게 하도록 경로를 역으로 출력한다
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

//KYULING: 그래프에서 제일 가벼운 노드를 리턴시킨다.
-(NSString *)lightestNodeOnGraph:(NSMutableDictionary *)includedNodes {
    NSArray *sortedArray = [includedNodes.allValues sortedArrayUsingComparator:^NSComparisonResult(GraphNodeItem *first, GraphNodeItem *second) {
        return [[NSNumber numberWithInteger:first.distance] compare:[NSNumber numberWithInteger:second.distance]];
    }];
    
    return [[includedNodes allKeysForObject:[sortedArray objectAtIndex:0]] objectAtIndex:0];
}


@end
