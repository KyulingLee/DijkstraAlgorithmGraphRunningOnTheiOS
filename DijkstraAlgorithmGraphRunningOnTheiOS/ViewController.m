//
//  ViewController.m
//  DijkstraAlgorithmGraphRunningOnTheiOS
//
//  Created by Lee Bong Kyu on 2013. 11. 27..
//  Copyright (c) 2013년 Lee Bong Kyu. All rights reserved.
//

#import "ViewController.h"
#import "GraphNodeView.h"
#import "GraphCanvasView.h"

#import "GraphNodeItem.h"

#import "GraphResolver.h"

#define NODE_PARING(node1, node2) [NSArray arrayWithObjects:node1, node2, nil]

@interface ViewController ()

@end

@implementation ViewController


-(IBAction)pushAddNode:(id)sender {
    graphCanvasView.addingNode = !graphCanvasView.addingNode;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == firstNodeAlert) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Set"]) {
            startID = [[alertView textFieldAtIndex:0] text];
            
            secondNodeAlert = [[UIAlertView alloc] initWithTitle:@"Set End Node"
                                                         message:@"Enter the end node ID"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Set", nil];
            
            [secondNodeAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[secondNodeAlert textFieldAtIndex:0] setPlaceholder:[NSString stringWithFormat:@"Enter node ID"]];
            [secondNodeAlert show];
        }
    } else if (alertView == secondNodeAlert) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Set"]) {
            endID = [[alertView textFieldAtIndex:0] text];
        }
        [self findRouteWithStart:startID end:endID];
    }
}

-(IBAction)pushFindPath:(id)sender {
    firstNodeAlert = [[UIAlertView alloc] initWithTitle:@"Set Start Node"
                                                message:@"Enter the start node ID"
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"Set", nil];
    
    [firstNodeAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[firstNodeAlert textFieldAtIndex:0] setPlaceholder:[NSString stringWithFormat:@"Enter node ID"]];
    [firstNodeAlert show];
}

-(void)findRouteWithStart:(NSString *)startNode end:(NSString *)endNode {
    NSMutableDictionary *connections = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *nodes = [[NSMutableDictionary alloc] init];
    
    for (NSArray *pairings in graphCanvasView.nodeParings) {
        
        GraphNodeItem *firstItem = [[GraphNodeItem alloc] init];
        firstItem.nodeTag = [(GraphNodeView *)[pairings objectAtIndex:0] nodeTag];
        firstItem.neighbours = [[NSMutableDictionary alloc] init];
        
        GraphNodeItem *secondItem = [[GraphNodeItem alloc] init];
        secondItem.nodeTag = [(GraphNodeView *)[pairings objectAtIndex:1] nodeTag];
        secondItem.neighbours = [[NSMutableDictionary alloc] init];
        
        for (NSArray *array in graphCanvasView.nodeParings) {
            NSInteger arcWeight = [self weightBetween:firstItem.nodeTag and:secondItem.nodeTag inConnections:graphCanvasView.nodeParings];
            
            if (arcWeight != INFINITY) {
                [connections setObject:[NSNumber numberWithInteger:arcWeight]
                                forKey:@[firstItem, secondItem]];
            }
        }
    }
    
    for (GraphNodeView *n in graphCanvasView.graphNodes) {
        GraphNodeItem *item = [[GraphNodeItem alloc] init];
        item.nodeTag = n.nodeTag;
        item.neighbours = [[NSMutableDictionary alloc] init];
        
        [nodes setObject:item forKey:item.nodeTag];
    }
    
    GraphResolver *resolver = [[GraphResolver alloc] init];
    
    [resolver dijkstrasOnConnections:connections
                               nodes:nodes
                       withStartNode:startNode
                             endNode:endNode
                andCompletionHandler:^(NSMutableArray *path, NSInteger weight) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSMutableDictionary *pathDict = [[NSMutableDictionary alloc] init];
                        for (int i = 1; i < [path count]; i++) {
                            [pathDict setObject:[NSNumber numberWithInt:0] forKey:@[[path objectAtIndex:i-1], [path objectAtIndex:i]]];
                        }
                        
                        [graphCanvasView showRouteBetweenFinalNodes:pathDict];
                        
                        NSMutableString *pathString = [[NSMutableString alloc] init];
                        
                        for (NSString *node in path) {
                            [pathString appendString:node];
                            if (![node isEqualToString:[path objectAtIndex:[path count]-1]]) {
                                [pathString appendString:@", "];
                            }
                        }
                        
                        [[navigationBar topItem] setTitle:[NSString stringWithFormat:@"Route Found With Weight %i", weight]];
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Optimum Path Found!"
                                                                            message:[NSString stringWithFormat:@"Optimum path found\n%@\n Weight %i",pathString, weight]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Dismiss"
                                                                  otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }];
}

-(NSInteger)weightBetween:(NSString *)nodeOne and:(NSString *)nodeTwo inConnections:(NSMutableDictionary *)connections {
    for (NSArray *array in connections) {
        if (([[[array objectAtIndex:0] nodeTag] isEqualToString:nodeOne] || [[[array objectAtIndex:0] nodeTag] isEqualToString:nodeTwo])
            && ([[[array objectAtIndex:1] nodeTag] isEqualToString:nodeOne] || [[[array objectAtIndex:1] nodeTag] isEqualToString:nodeTwo])) {
            return [[connections objectForKey:array] integerValue];
        }
    }
    return INFINITY;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    graphNodes = [[NSMutableArray alloc] init];
    nodeParings = [[NSMutableDictionary alloc] init];
    
    graphCanvasView.graphNodes = [[NSMutableArray alloc] init];
    graphCanvasView.nodeParings = [[NSMutableDictionary alloc] init];
    
    addingNode = FALSE;
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
