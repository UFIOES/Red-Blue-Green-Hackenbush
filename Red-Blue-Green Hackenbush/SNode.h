//
//  SNode.h
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/21/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNode : NSObject {
    
    CGPoint point;
    
    int number;
    
    NSMutableArray* links;
    
    BOOL groundNode;
    
    int numLinks;
    
}

@property CGPoint point;

@property (nonatomic) int number;

@property int numLinks;

@property NSMutableArray* links;

- (void)setNumber:(int)n;

- (void)setGroundNode;

- (BOOL)isGroundNode;

- (void)addLink:(SNode*)link;

- (void)removeLink:(SNode*)link;

- (void)assignNumbersToLinks;

+ (id)makeWithPoint:(CGPoint)p;

- (id)clone;

@end
