//
//  SView.h
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/19/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLine.h"
#import "SNode.h"
#import "SSurreal.h"

@interface SView : UIView {
    
    NSMutableArray* lines;
    
    NSMutableArray* allNodes;
    
    NSMutableArray* groundNodes;
    
    SNode* newLineStartNode;
    
    SNode* newLineEndNode;
    
    BOOL drawingNewLine;
    
    lineColor color;
    
    BOOL childishMode;
    
    BOOL editingMode;
    
    float nodeSnapRange;
    
    SSurreal* value;
    
}

@property lineColor color;

@property BOOL childishMode;

@property BOOL editingMode;

@property float nodeSnapRange;

- (id)initWithFrame:(CGRect)frame;

- (void)maximumDelete;

@end
