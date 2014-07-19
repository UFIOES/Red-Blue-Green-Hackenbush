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
    
    [left enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SSurreal* surreal = (SSurreal*) obj;
        
        if (!surreal.hasValue) {
            
            [surreal analyzeValue];
            
        }
        
    }];
    
    [right enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SSurreal* surreal = (SSurreal*) obj;
        
        if (!surreal.hasValue) {
            
            [surreal analyzeValue];
            
        }
        
    }];
    
    if (left.count == 0 && right.count == 0) {
        
        value = new Nimber(0,0,0);
        
        hasValue = YES;
        
        return YES;
        
    } else if (left.count == 1 && right.count == 0) {
        
        value = *((SSurreal*) left.firstObject).value + *new Nimber(1,0,0);
        
        hasValue = YES;
        
        return YES;
        
    } else if (left.count == 0 && right.count == 1) {
        
        value = *((SSurreal*) right.firstObject).value + *new Nimber(-1,0,0);
        
        hasValue = YES;
        
        return YES;
        
    } else if (right.count == 0) {
        
        SSurreal* champion = [left firstObject];
        
        NSMutableArray* champions = [NSMutableArray array];
        
        for (SSurreal* surreal in left) { //finds the largest value in left, if the values is fuzzy, finds the first
            
            if (*champion.value < *surreal.value) {
                
                champion = surreal;
                
            }
            
        }
        
        [champions addObject:champion];
        
        for (SSurreal* surreal in left) {
            
            if (*champion.value | *surreal.value) {
                
                [champions addObject:surreal];
                
            }
            
        }
        
        if (champions.count == 1) {
            
            value = *champion.value + *new Nimber(1,0,0);
            
            hasValue = YES;
            
            return YES;
            
        } else {
            
            return NO;
            
        }
        
    } else if (left.count == 0) {
        
        SSurreal* champion = [right firstObject];
        
        NSMutableArray* champions = [NSMutableArray array];
        
        for (SSurreal* surreal in right) { //finds the smallest value in right, if the values is fuzzy, finds the first
            
            if (champion.value > surreal.value) {
                
                champion = surreal;
                
            }
            
        }
        
        [champions addObject:champion];
        
        for (SSurreal* surreal in right) {
            
            if (*champion.value | *surreal.value) {
                
                [champions addObject:surreal];
                
            }
            
        }
        
        if (champions.count == 1) {
            
            value = *champion.value + *new Nimber(-1,0,0);
            
            hasValue = YES;
            
            return YES;
            
        } else {
            
            return NO;
            
        }
        
    }
    
    return NO;
    
}

@end
