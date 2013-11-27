//
//  GraphCanvasView.h
//  DijkstraAlgorithmGraphRunningOnTheiOS
//
//  Created by Lee Bong Kyu on 2013. 11. 27..
//  Copyright (c) 2013년 Lee Bong Kyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphNodeView;

@protocol GraphCanvasViewDelegate <NSObject>

-(void)setStartPoint:(NSString *)startID andEndPoint:(NSString *)endID;

@end


@interface GraphCanvasView : UIView <UIAlertViewDelegate> {
    GraphNodeView *firstTappedNode;
    GraphNodeView *secondTappedNode;
    
    NSMutableDictionary *finalParings;
}

@property (strong, nonatomic) NSMutableArray *graphNodes;
@property (strong, nonatomic) NSMutableDictionary *nodeParings;
@property (strong, nonatomic) id<GraphCanvasViewDelegate> delegate;

@property BOOL addingNode;
@property BOOL settingPath;

-(void)showRouteBetweenFinalNodes:(NSMutableDictionary *)finalNodes;


@end
