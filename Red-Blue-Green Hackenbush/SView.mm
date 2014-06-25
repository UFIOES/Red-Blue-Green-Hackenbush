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
        
    }
    
    return self;
    
}

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

- (void)maximumDelete {
    
    lines = [NSMutableArray array];
    
    allNodes = [NSMutableArray array];
    
    groundNodes = [NSMutableArray array];
    
    [self setNeedsDisplay];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    NSEnumerator *feeler = touches.objectEnumerator;
    UITouch *value;
    
    while (value = [feeler nextObject]) {
        
        CGPoint where = [value locationInView:self];
        
        newLineStartNode = [SNode makeWithPoint:where];
        
        if (editingMode) {
            
            BOOL __block nearbyNode = NO;
            
            BOOL onGround = NO;
            
            SNode* __block theNode;
            
            float x1 = where.x;
            float y1 = where.y;
            
            if (fabsf(y1 - ((self.frame.size.height * 7) / 8)) < 10.0f) {
                
                y1 = (self.frame.size.height * 7) / 8;
                
                newLineStartNode = [SNode makeWithPoint:CGPointMake(x1, y1)];
                
                onGround = YES;
                
            }
            
            [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                
                SNode* node = ((SNode*) obj);
                
                float x2 = node.point.x;
                float y2 = node.point.y;
                
                float d = sqrtf((x1 - x2)*(x1 - x2) +( y1 - y2)*(y1 - y2));
                
                if (d < 10.0f) {
                    
                    theNode = node;
                    
                    nearbyNode = YES;
                    
                    *stop = YES;
                    
                }
                
            }];
            
            if (nearbyNode) {
                
                newLineStartNode = theNode;
                
            } else if (onGround) {
                
                [newLineStartNode setGroundNode];
                
            }
            
        }
        
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesCancelled:touches withEvent:event];
    
    if (editingMode) {
        
    }
    
    drawingNewLine = NO;
    
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    NSEnumerator *feeler = touches.objectEnumerator;
    UITouch *value;
    
    BOOL fail = NO;
    
    while (value = [feeler nextObject]) {
        
        CGPoint where = [value locationInView:self];
        
        newLineEndNode = [SNode makeWithPoint:where];
        
        if (editingMode) {
            
            BOOL __block nearbyNode = NO;
            
            BOOL onGround = NO;
            
            SNode* __block theNode;
            
            float x1 = where.x;
            float y1 = where.y;
            
            if (fabsf(y1 - ((self.frame.size.height * 7) / 8)) < 10.0f) {
                
                y1 = (self.frame.size.height * 7) / 8;
                
                newLineEndNode = [SNode makeWithPoint:CGPointMake(x1, y1)];
                
                onGround = YES;
                
            }
            
            [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                
                SNode* node = ((SNode*) obj);
                
                float x2 = node.point.x;
                float y2 = node.point.y;
                
                float d = sqrtf((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2));
                
                if (d < 10.0f) {
                    
                    theNode = node;
                    
                    nearbyNode = YES;
                    
                    *stop = YES;
                    
                }
                
            }];
            
            if (nearbyNode) {
                
                newLineEndNode = theNode;
                
            } else if (onGround) {
                
                [newLineEndNode setGroundNode];
                
            }
            
            float startX = newLineStartNode.point.x;
            float startY = newLineStartNode.point.y;
            
            float endX = newLineEndNode.point.x;
            float endY = newLineEndNode.point.y;
            
            float d = sqrtf((startX - endX)*(startX - endX) + (startY - endY)*(startY - endY));
            
            if (d < 10.0f) {
                
                fail = YES;
                
            }
            
        }
        
    }
    
    if (editingMode && !fail) {
        
        BOOL startNodeIsNew = ![allNodes containsObject:newLineStartNode];
        
        BOOL endNodeIsNew = ![allNodes containsObject:newLineEndNode];
        
        if (startNodeIsNew) {
            
            [allNodes addObject:newLineStartNode];
            
            if ([newLineStartNode isGroundNode]) {
                
                [groundNodes addObject:newLineStartNode];
                
            }
            
        }
        
        if (endNodeIsNew) {
            
            [allNodes addObject:newLineEndNode];
            
            if ([newLineEndNode isGroundNode]) {
                
                [groundNodes addObject:newLineEndNode];
                
            }
            
        }
        
        [newLineStartNode addLink:newLineEndNode];
        [newLineEndNode addLink:newLineStartNode];
        
        [lines addObject:[SLine makeWithColor:color startNode:newLineStartNode endNode:newLineEndNode]];
        
    } else {
        
        SLine* line1 = [SLine makeWithColor:color
                                 startNode: newLineStartNode
                                   endNode: newLineEndNode];
        
        [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            
            SLine* line2 = ((SLine*) obj);
            
            if (lineSegmentsIntersect(line1, line2)) {
                
                if (childishMode) {
                    
                    [line2.startNode removeLink:line2.endNode];
                    [line2.endNode removeLink:line2.startNode];
                    
                    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SNode* node = ((SNode*) obj);
                        
                        [node setNumber:-1];
                        
                    }];
                    
                    [groundNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SNode* node = ((SNode*) obj);
                        
                        [node assignNumbersToLinks];
                        
                    }];
                    
                    NSMutableArray* __block deadNodes = [NSMutableArray arrayWithCapacity:allNodes.count];
                    
                    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SNode* node = ((SNode*) obj);
                        
                        if (node.number < 0) {
                            
                            [deadNodes addObject:obj];
                            
                        }
                        
                    }];
                    
                    NSMutableArray* __block deadLines = [NSMutableArray array];
                    
                    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SLine* line = ((SLine*) obj);
                        
                        if ([deadNodes containsObject:line.startNode] || [deadNodes containsObject:line.endNode]) {
                            
                            [deadLines addObject:line];
                            
                        }
                        
                    }];
                    
                    if (deadLines.count > 1) {
                        
                        [line2.startNode addLink:line2.endNode];
                        [line2.endNode addLink:line2.startNode];
                        
                    } else {
                        
                        [deadLines addObject:line2];
                        
                        [deadNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            
                            [allNodes removeObject:obj];
                            
                        }];
                        
                        [deadLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            
                            [lines removeObject:obj];
                            
                        }];
                        
                    }
                    
                } else {
                    
                    [line2.startNode removeLink:line2.endNode];
                    [line2.endNode removeLink:line2.startNode];
                    
                    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SNode* node = ((SNode*) obj);
                        
                        [node setNumber:-1];
                        
                    }];
                    
                    [groundNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SNode* node = ((SNode*) obj);
                        
                        [node assignNumbersToLinks];
                        
                    }];
                    
                    NSMutableArray* __block deadNodes = [NSMutableArray arrayWithCapacity:allNodes.count];
                    
                    [allNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SNode* node = ((SNode*) obj);
                        
                        if (node.number < 0) {
                            
                            [deadNodes addObject:obj];
                            
                        }
                        
                    }];
                    
                    [deadNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        [allNodes removeObject:obj];
                        
                    }];
                    
                    NSMutableArray* __block deadLines = [NSMutableArray array];
                    
                    [deadLines addObject:line2];
                    
                    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        SLine* line = ((SLine*) obj);
                        
                        if ([deadNodes containsObject:line.startNode] || [deadNodes containsObject:line.endNode]) {
                            
                            [deadLines addObject:line];
                            
                        }
                        
                    }];
                    
                    [deadLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        [lines removeObject:obj];
                        
                    }];
                    
                }
                
                *stop = YES;
                
            }
            
        }];
        
    }
    
    drawingNewLine = NO;
    
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesMoved:touches withEvent:event];
    
    NSEnumerator *feeler = touches.objectEnumerator;
    UITouch *value;
    
    while (value = [feeler nextObject]) {
        
        CGPoint where = [value locationInView:self];
        
        newLineEndNode = [SNode makeWithPoint:where];
        /*
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

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        
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
    
    if (drawingNewLine) {
        
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
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, (self.frame.size.height * 7) / 8)];
    
    [path addLineToPoint:CGPointMake(self.frame.size.width, (self.frame.size.height * 7) / 8)];
    
    [[UIColor blackColor] setStroke];
    
    [path stroke];
    
    CGContextRestoreGState(context);
    
}


@end
