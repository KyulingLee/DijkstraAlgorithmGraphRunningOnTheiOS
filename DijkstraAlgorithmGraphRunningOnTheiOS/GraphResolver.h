//
//  GraphResolver.h
//  DijkstraAlgorithmGraphRunningOnTheiOS
//
//  Created by Lee Bong Kyu on 2013. 11. 27..
//  Copyright (c) 2013년 Lee Bong Kyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphResolver : NSObject

-(void)dijkstrasOnConnections:(NSMutableDictionary *)connections nodes:(NSMutableDictionary *)nodes withStartNode:(NSString *)startID endNode:(NSString *)endID andCompletionHandler:(void (^)(NSMutableArray *, NSInteger))callback;

@end
