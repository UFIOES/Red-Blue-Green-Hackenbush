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

- (void)setNumber:(int)n {
    
    if (!groundNode) {
        
        number = n;
        
    }
    
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
    
}

- (void)addLink:(SNode*)link {
    
    [links addObject:link];
    
}

- (void)removeLink:(SNode*)link {
    
    [links removeObject:link];
    
}

- (void)assignNumbersToLinks {
    
    [links enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SNode* node = ((SNode*) obj);
        
        if ((node.number < 0 || node.number > self.number + 1) && self.number >= 0) {
            
            node.number = self.number + 1;
            
            [node assignNumbersToLinks];
            
        }
        
    }];
    
}

- (void)setGroundNode {
    
    groundNode = YES;
    
    number = 0;
    
}

- (BOOL)isGroundNode {
    
    return groundNode;
    
}

+ (id)makeWithPoint:(CGPoint)p {
    
    SNode* node = [super new];
    
    node->point = p;
    
    node->number = -1;
    
    node->links = [NSMutableArray array];
    
    return node;
    
}

@end
