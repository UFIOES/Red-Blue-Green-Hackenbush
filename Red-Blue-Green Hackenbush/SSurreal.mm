//
//  SSurreal.mm
//  Hackenbush
//
//  Created by Sam Carlson on 7/18/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import "SSurreal.h"

@implementation SSurreal

@synthesize left;

@synthesize right;

@synthesize value;

@synthesize hasValue;

+ (id)makeWithLeftArray:(NSArray*)leftArray rightArray:(NSArray*)rightArray {
    
    SSurreal* surreal = [[SSurreal alloc] init];
    
    surreal->left = [NSMutableArray arrayWithArray:leftArray];
    
    surreal->right = [NSMutableArray arrayWithArray:rightArray];
    
    surreal->value = new Nimber(0, 0, 0);
    
    return surreal;
    
}

- (BOOL)analyzeValue {
    
    if (left.count == 0 && right.count == 0) {
        
        value = new Nimber(0,0,0);
        
        return YES;
        
    } else if (left.count == 0 && right.count == 1) {
        
        for (SSurreal* surreal in right) {
            
            if (surreal.hasValue) {
                
                value = surreal.value + 1;
                
                return YES;
                
            } else {
                
                if ([surreal analyzeValue]) {
                    
                    value = surreal.value + 1;
                    
                    return YES;
                    
                }
                
            }
            
        }
        
    } else if (left.count == 1 && right.count == 0) {
        
        for (SSurreal* surreal in left) {
            
            if (surreal.hasValue) {
                
                value = surreal.value - 1;
                
                return YES;
                
            } else {
                
                if ([surreal analyzeValue]) {
                    
                    value = surreal.value + 1;
                    
                    return YES;
                    
                }
                
            }
            
        }
        
    }
    
    return NO;
    
}

@end
