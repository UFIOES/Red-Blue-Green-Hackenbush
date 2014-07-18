//
//  SView.m
//  Red-Blue-Green Hackenbush
//
//  Created by Sam Carlson on 6/19/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import "SView.h"

@implementation SView

@synthesize color;

@synthesize childishMode;

@synthesize editingMode;

@synthesize nodeSnapRange;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        lines = [NSMutableArray array];
        
        allNodes = [NSMutableArray array];
        
        groundNodes = [NSMutableArray array];
        
        drawingNewLine = NO;
        
        color = green;
        
        childishMode = NO;
        
        editingMode = YES;
        
        nodeSnapRange = 10.0f;
        
    }
    
    return self;
    
}

//math method, tests two SLine's for an interection
BOOL lineSegmentsIntersect(SLine* l1, SLine* l2) {
    
    float x1 = l1.startNode.point.x, x2 = l1.endNode.point.x, x3 = l2.startNode.point.x, x4 = l2.endNode.point.x;
    float y1 = l1.startNode.point.y, y2 = l1.endNode.point.y, y3 = l2.startNode.point.y, y4 = l2.endNode.point.y;
    
    float dx1 = x2-x1;
    float dx2 = x4-x3;
    float dy1 = y2-y1;
    float dy2 = y4-y3;
    
    float t1 = dx1*dy2 - dy1*dx2;
    
    if (t1 == 0) {
        return NO;
    }
    
    float dx3 = x3-x1;
    float dy3 = y3-y1;
    float t2 = (dx3*dy2 - dy3*dx2) / t1;
    
    if (t2 < 0 || t2 > 1) {
        return NO;
    }
    
    float t3 = (dx3*dy1 - dy3*dx1) / t1;
    
    if (t3 < 0 || t3 > 1) {
        return NO;
    }
    
    return YES;
    
}

//Cleans all of the arrays to dispose of nodes anf lines
- (void)maximumDelete {
    
    lines = [NSMutableArray array];
    
    allNodes = [NSMutableArray array];
    
    groundNodes = [NSMutableArray array];
    
    [self setNeedsDisplay];
    
}

//Method called when someone touches the view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    NSEnumerator *feeler = touches.objectEnumerator;
    UITouch *value;
    
    while (value = [feeler nextObject]) {
        
        CGPoint where = [value locationInView:self]; //find where the touch is
        
        newLineStartNode = [SNode makeWithPoint:where]; //make a node for that point
        
        if (editingMode) {
            
            BOOL __block nearbyNode = NO;
            
            BOOL onGround = NO;
            
            SNode* __block theNode;
            
            float x1 = where.x;
            float y1 = where.y;
            
            if (fabsf(y1 - ((self.frame.size.height * 7) / 8)) < nodeSnapRange) { //if the node is within the node snap range of the ground line, put it on the ground line and make it a ground node
                
                y1 = (self.frame.size.height * 7) / 8;
                
                newLineStartNode = [SNode makeWithPoint:CGPointMake(x1, y1)];
                
                onGround = YES;
                
            }
            
            [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) { //iterates through all of the nodes to chech if the new node if with in the node snap range of any node, if it is, use that node instead of the new node
                
                SNode* node = ((SNode*) obj);
                
                float x2 = node.point.x;
                float y2 = node.point.y;
                
                float d = sqrtf((x1 - x2)*(x1 - x2) +( y1 - y2)*(y1 - y2));
                
                if (d < nodeSnapRange) {
                    
                    theNode = node;
                    
                    nearbyNode = YES;
                    
                    *stop = YES; //unlikely that someone will try to squeeze a node between two neerby nodes, most people do not have thin enough fingers to achieve this
                    
                }
                
            }];
            
            if (nearbyNode) {
                
                newLineStartNode = theNode;
                
            } else if (onGround) { //no need to set a pre-existing node to a ground node, it may not be on the ground
                
                [newLineStartNode setGroundNode];
                
            }
            
        }
        
    }
    
}

//if something happens (push notification), that breaks a touch before it is done
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesCancelled:touches withEvent:event];
    
    if (editingMode) {
        
    }
    
    drawingNewLine = NO;
    
    [self setNeedsDisplay];
    
}

//Called when someone lifts their finger off of the screen, time to create the new end node
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    NSEnumerator *feeler = touches.objectEnumerator;
    UITouch *value;
    
    BOOL fail = NO;
    
    while (value = [feeler nextObject]) {
        
        CGPoint where = [value locationInView:self]; //find where the touch is
        
        newLineEndNode = [SNode makeWithPoint:where]; //make a node for that point
        
        if (editingMode) {
            
            BOOL __block nearbyNode = NO;
            
            BOOL onGround = NO;
            
            SNode* __block theNode;
            
            float x1 = where.x;
            float y1 = where.y;
            
            if (fabsf(y1 - ((self.frame.size.height * 7) / 8)) < nodeSnapRange) { //if the node is within the node snap range of the ground line, put it on the ground line and make it a ground node
                
                y1 = (self.frame.size.height * 7) / 8;
                
                newLineEndNode = [SNode makeWithPoint:CGPointMake(x1, y1)];
                
                onGround = YES;
                
            }
            
            [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) { //iterates through all of the nodes to chech if the new node if with in the node snap range of any node, if it is, use that node
                
                SNode* node = ((SNode*) obj);
                
                float x2 = node.point.x;
                float y2 = node.point.y;
                
                float d = sqrtf((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2));
                
                if (d < nodeSnapRange) {
                    
                    theNode = node;
                    
                    nearbyNode = YES;
                    
                    *stop = YES; //unlikely that someone will try to squeeze a node between two neerby nodes, most people do not have thin enough fingers to achieve this
                    
                }
                
            }];
            
            if (nearbyNode) {
                
                newLineEndNode = theNode;
                
            } else if (onGround) { //no need to set a pre-existing node to a ground node, it may not be on the ground
                
                [newLineEndNode setGroundNode];
                
            }
            
            float startX = newLineStartNode.point.x;
            float startY = newLineStartNode.point.y;
            
            float endX = newLineEndNode.point.x;
            float endY = newLineEndNode.point.y;
            
            float d = sqrtf((startX - endX)*(startX - endX) + (startY - endY)*(startY - endY));
            
            if (d < nodeSnapRange) { //tests if the new nodes are within the the node snap range of each other, if they are, there will be problems (the math may have of may in the future consider them the same point, making a line with no length), so we must cancel the new line
                
                fail = YES;
                
            }
            
        }
        
    }
    
    if (editingMode && !fail) { //if we are making a new line...
        
        //test that our nodes are new before adding them to the arrays
        BOOL startNodeIsNew = ![allNodes containsObject:newLineStartNode];
        
        BOOL endNodeIsNew = ![allNodes containsObject:newLineEndNode];
        
        if (startNodeIsNew) { //add the start node to appliciable arrays
            
            [allNodes addObject:newLineStartNode];
            
            if ([newLineStartNode isGroundNode]) {
                
                [groundNodes addObject:newLineStartNode];
                
            }
            
        }
        
        if (endNodeIsNew) { //add the end node to appliciable arrays
            
            [allNodes addObject:newLineEndNode];
            
            if ([newLineEndNode isGroundNode]) {
                
                [groundNodes addObject:newLineEndNode];
                
            }
            
        }
        
        //link the new nodes
        [newLineStartNode addLink:newLineEndNode];
        [newLineEndNode addLink:newLineStartNode];
        
        [lines addObject:[SLine makeWithColor:color startNode:newLineStartNode endNode:newLineEndNode]]; //make the newe line
        
    } else { //we might be cutting a line
        
        //make the line
        SLine* line1 = [SLine makeWithColor:color
                                 startNode: newLineStartNode
                                   endNode: newLineEndNode];
        
        [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) { //enumerate all lines
            
            SLine* line2 = ((SLine*) obj);
            
            if (lineSegmentsIntersect(line1, line2)) { //test for an intersection
                
                if (childishMode) { //if we are in childish mode we cannot 'drop' any lines
                    
                    //removing (cutting) the link between the nodes, to test what the new structure will be like
                    [line2.startNode removeLink:line2.endNode];
                    [line2.endNode removeLink:line2.startNode];
                    
                    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //prepare to test ground connectivity by setting all non-ground nodes to -1
                        
                        SNode* node = ((SNode*) obj);
                        
                        [node setNumber:-1];
                        
                    }];
                    
                    [groundNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //tell the ground nodes to start assigning numbers to all connected nodes
                        
                        SNode* node = ((SNode*) obj);
                        
                        [node assignNumbersToLinks];
                        
                    }];
                    
                    NSMutableArray* __block deadNodes = [NSMutableArray arrayWithCapacity:allNodes.count];
                    
                    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //if there are any nodes still with -1, they must not connect to the ground, they are dead
                        
                        SNode* node = ((SNode*) obj);
                        
                        if (node.number < 0) {
                            
                            [deadNodes addObject:obj];
                            
                        }
                        
                    }];
                    
                    NSMutableArray* __block deadLines = [NSMutableArray array];
                    
                    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //any line that contains a dead node is a dead line
                        
                        SLine* line = ((SLine*) obj);
                        
                        if ([deadNodes containsObject:line.startNode] || [deadNodes containsObject:line.endNode]) {
                            
                            [deadLines addObject:line];
                            
                        }
                        
                    }];
                    
                    if (deadLines.count > 1) { //test to make sure we are not droping any lines, if so re-add the link and cancel the cut
                        
                        [line2.startNode addLink:line2.endNode];
                        [line2.endNode addLink:line2.startNode];
                        
                    } else { //only one line is being cut, time to cut it
                        
                        [deadLines addObject:line2];
                        
                        [deadNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            
                            [allNodes removeObject:obj];
                            
                        }];
                        
                        [deadLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            
                            [lines removeObject:obj];
                            
                        }];
                        
                    }
                    
                } else { //we are not in childish mode, so we can droop lines
                    
                    //removing (cutting) the link between the nodes, to test what the new structure will be like
                    [line2.startNode removeLink:line2.endNode];
                    [line2.endNode removeLink:line2.startNode];
                    
                    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //prepare to test ground connectivity by setting all non-ground nodes to -1
                        
                        SNode* node = ((SNode*) obj);
                        
                        [node setNumber:-1];
                        
                    }];
                    
                    [groundNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //tell the ground nodes to start assigning numbers to all connected nodes
                        
                        SNode* node = ((SNode*) obj);
                        
                        [node assignNumbersToLinks];
                        
                    }];
                    
                    NSMutableArray* __block deadNodes = [NSMutableArray arrayWithCapacity:allNodes.count];
                    
                    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //if there are any nodes still with -1, they must not connect to the ground, they are dead
                        
                        SNode* node = ((SNode*) obj);
                        
                        if (node.number < 0) {
                            
                            [deadNodes addObject:obj];
                            
                        }
                        
                    }];
                    
                    [groundNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //check for dead ground nodes, as they allways have connectivity to the ground and are only are destroyed by having all connecting lines cut
                        
                        SNode* node = ((SNode*) obj);
                        
                        if (node.numLinks == 0) {
                            
                            [deadNodes addObject:obj];
                            
                        }
                        
                    }];
                    
                    NSMutableArray* __block deadLines = [NSMutableArray array];
                    
                    [deadLines addObject:line2];
                    
                    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //any line that contains a dead node is a dead line
                        
                        SLine* line = ((SLine*) obj);
                        
                        if ([deadNodes containsObject:line.startNode] || [deadNodes containsObject:line.endNode]) {
                            
                            [deadLines addObject:line];
                            
                        }
                        
                    }];
                    
                    [deadNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //delete all dead nodes
                        
                        [allNodes removeObject:obj];
                        
                    }];
                    
                    [deadLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { //finally we delete the dead lines
                        
                        [lines removeObject:obj];
                        
                    }];
                    
                }
                
                *stop = YES; //any additional intersections will be ignored, you can only cut one line at a time
                
            }
            
        }];
        
    }
    
    drawingNewLine = NO;
    
    [self setNeedsDisplay];
    
}

//when the touch moves, we must move the line for it to make sense to the user
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    NSEnumerator *feeler = touches.objectEnumerator;
    UITouch *value;
    
    while (value = [feeler nextObject]) {
        
        CGPoint where = [value locationInView:self];
        
        newLineEndNode = [SNode makeWithPoint:where];
        /* there is no need to do any math on the new node, it it will be the final one, it will be created in touchesEnded
        if (editingMode) {
            
            BOOL __block nearbyNode = NO;
            
            BOOL onGround = NO;
            
            SNode* __block theNode;
            
            float x1 = where.x;
            float y1 = where.y;
            
            if (fabsf(y1 - ((self.frame.size.height * 7) / 8)) < 7.5f) {
                
                y1 = (self.frame.size.height * 7) / 8;
                
                onGround = YES;
                
            }
            
            [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                
                SNode* node = ((SNode*) obj);
                
                float x2 = node.point.x;
                float y2 = node.point.y;
                
                float d = sqrtf((x1 - x2)*(x1 - x2) +( y1 - y2)*(y1 - y2));
                
                if (d < 7.5f) {
                    
                    theNode = node;
                    
                    nearbyNode = YES;
                    
                    *stop = YES;
                    
                }
                
            }];
            
            if (nearbyNode) {
                
                newLineEndNode.point = theNode.point;
                
            }
            
        }
        */
    }
    
    drawingNewLine = YES;
    
    [self setNeedsDisplay];
    
}

//rendering code
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) { //enumerate through and draw all of the lines
        
        SLine* line = ((SLine*) obj);
        
        UIBezierPath* path = [UIBezierPath bezierPath];
        
        [path moveToPoint:line.startNode.point];
        
        [path addLineToPoint:line.endNode.point];
        
        switch (line.color) {
            case red:
                [[UIColor redColor] setStroke];
                break;
            case blue:
                [[UIColor blueColor] setStroke];
                break;
            case green:
                [[UIColor greenColor] setStroke];
                break;
        }
        
        path.lineCapStyle = kCGLineCapRound;
        
        [path stroke];
        
    }];
    
    if (drawingNewLine) { //draw the line currently being created
        
        UIBezierPath* path = [UIBezierPath bezierPath];
        
        [path moveToPoint:newLineStartNode.point];
        
        [path addLineToPoint:newLineEndNode.point];
        
        switch (color) {
            case red:
                [[UIColor redColor] setStroke];
                break;
            case blue:
                [[UIColor blueColor] setStroke];
                break;
            case green:
                [[UIColor greenColor] setStroke];
                break;
        }
        
        if (!editingMode) {
            [[UIColor whiteColor] setStroke];
        }
        
        [path stroke];
        
    }
    
    //draw the ground line
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, (self.frame.size.height * 7) / 8)];
    
    [path addLineToPoint:CGPointMake(self.frame.size.width, (self.frame.size.height * 7) / 8)];
    
    [[UIColor blackColor] setStroke];
    
    [path stroke];
    
    CGContextRestoreGState(context);
    
    //draw the nodes
    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SNode* node = (SNode*) obj;
        
        float x = node.point.x;
        
        float y = node.point.y;
        
        float size;
        
        [[UIColor whiteColor] setStroke];
        
        if (editingMode) {
            
            size = nodeSnapRange;
            
        } else {
            
            size = 8.0f;
            
        }
        
        UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x - size/2.0f, y - size/2.0f, size, size)];
        
        [circle strokeWithBlendMode:kCGBlendModeLuminosity alpha:0.45f];
        
    }];
    
}


@end
