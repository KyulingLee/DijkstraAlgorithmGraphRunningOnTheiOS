//
//  ViewController.h
//  DijkstraAlgorithmGraphRunningOnTheiOS
//
//  Created by Lee Bong Kyu on 2013. 11. 27..
//  Copyright (c) 2013년 Lee Bong Kyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphNodeView;
@class GraphCanvasView;

@interface ViewController : UIViewController <UIAlertViewDelegate> {
    NSMutableArray *graphNodes;
    NSMutableDictionary *nodeParings;
    
    NSString *startID;
    NSString *endID;
    
    BOOL addingNode;
    
    UIAlertView *firstNodeAlert;
    UIAlertView *secondNodeAlert;
    
    IBOutlet GraphCanvasView *graphCanvasView;
    IBOutlet UINavigationBar *navigationBar;
}

- (IBAction)pushAddNode:(id)sender;
- (IBAction)pushFindPath:(id)sender;

-(void)findRouteWithStart:(NSString *)startNode end:(NSString *)endNode;


@end
