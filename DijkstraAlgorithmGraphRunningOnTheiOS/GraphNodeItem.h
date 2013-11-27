//
//  GraphNodeItem.h
//  DijkstraAlgorithmGraphRunningOnTheiOS
//
//  Created by Lee Bong Kyu on 2013. 11. 27..
//  Copyright (c) 2013년 Lee Bong Kyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphNodeItem : NSObject

@property (strong, nonatomic) NSString *nodeTag;
@property (assign, nonatomic) NSInteger distance;

@property (strong, nonatomic) NSMutableDictionary *neighbours;

@end
