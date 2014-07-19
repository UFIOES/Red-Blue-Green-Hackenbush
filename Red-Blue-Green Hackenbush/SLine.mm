//
//  SLine.mm
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/19/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import "SLine.h"

@implementation SLine

@synthesize startNode;

@synthesize endNode;

@synthesize color;

//class constructor method
+ (id)makeWithColor:(lineColor)c startNode:(SNode*)n1 endNode:(SNode*)n2 {
    
    SLine* line = [super new];
    
    line->startNode = n1;
    
    line->endNode = n2;
    
    line->color = c;
    
    return line;
    
}

- (BOOL)hasGroundNode {
    
    if (startNode.isGroundNode || endNode.isGroundNode) {
        
        return YES;
        
    }
    
    return NO;
    
}

@end
