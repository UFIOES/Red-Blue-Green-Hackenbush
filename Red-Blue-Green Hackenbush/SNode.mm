//
//  SNode.mm
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/21/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import "SNode.h"

@implementation SNode

@synthesize point;

@synthesize number;

@synthesize numLinks;

@synthesize links;

//Sets the node's number, used for checking connectivity to the ground
- (void)setNumber:(int)n {
    
    if (!groundNode) {
        
        number = n;
        
    }
    
}


//deprecated, use the class method makeWithPoint
- (id)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
    
}

//add a node to the array of links
- (void)addLink:(SNode*)link {
    
    numLinks++;
    
    [links addObject:link];
    
}

//remove a node from the array of links
- (void)removeLink:(SNode*)link {
    
    numLinks--;
    
    [links removeObject:link];
    
}

//used to recursively assign numbers to linked nodes, initiate call on ground nodes only, used to check connectivity to the ground
- (void)assignNumbersToLinks {
    
    for (SNode* node in links) {
        
        if ((node.number < 0 || node.number > self.number + 1) && self.number >= 0) {
            
            node.number = self.number + 1;
            
            [node assignNumbersToLinks];
            
        }
        
    }
    
}
//designate a ground node
- (void)setGroundNode {
    
    groundNode = YES;
    
    number = 0;
    
}

//check for being a ground node
- (BOOL)isGroundNode {
    
    return groundNode;
    
}

//class constructor method
+ (id)makeWithPoint:(CGPoint)p {
    
    SNode* node = [super new];
    
    node->point = p;
    
    node->number = -1;
    
    node->links = [NSMutableArray array];
    
    node->numLinks = 0;
    
    return node;
    
}

- (id)clone {
    
    SNode* __block node = [SNode makeWithPoint:point];
    
    [links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [node addLink:obj];
        
    }];
    
    if (groundNode) [node setGroundNode];
    
    return node;
    
}

@end
