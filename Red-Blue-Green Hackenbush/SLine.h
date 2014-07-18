//
//  SLine.h
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/19/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SNode.h"

//Used to define the color of lines
typedef enum : NSUInteger {
    blue,
    red,
    green,
} lineColor;

@interface SLine : NSObject {
    
    SNode* startNode;
    
    SNode* endNode;
    
    lineColor color;
    
}

@property SNode* startNode;

@property SNode* endNode;

@property lineColor color;

+ (id)makeWithColor:(lineColor)c startNode:(SNode*)n1 endNode:(SNode*)n2;

@end
