//
//  GraphNodeView.h
//  DijkstraAlgorithmGraphRunningOnTheiOS
//
//  Created by Lee Bong Kyu on 2013. 11. 27..
//  Copyright (c) 2013년 Lee Bong Kyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphNodeView : UIView
{
    UIImageView *backgroundImageView;
    UILabel *nodeTagLabel;
}

@property (strong, nonatomic) NSString *nodeTag;

-(void)showNodeAtPoint:(CGPoint)point inParentView:(UIView *)pView withTag:(NSString *)tag;

@end
