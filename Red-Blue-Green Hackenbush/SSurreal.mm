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

class Nimber {
    
    double real = 0; // real part
    
    double star = 0; // star part: *0, *1, *2, etc...
    
    double bigStar = 0; // larger fuzzy part: ±1/2, ±1, ±2, etc...
    
public:
    
    Nimber(double r, double s, double bS) {
        
        real = r;
        star = s;
        bS = bS;
        
    }
    
};

+ (id)makeWithLeftArray:(NSArray*)leftArray rightArray:(NSArray*)rightArray {
    
    SSurreal* surreal = [[SSurreal alloc] init];
    
    surreal->left = [NSMutableArray arrayWithArray:leftArray];
    
    surreal->right = [NSMutableArray arrayWithArray:rightArray];
    
    return surreal;
    
}

@end
