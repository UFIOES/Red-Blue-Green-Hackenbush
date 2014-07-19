//
//  SSurreal.h
//  Hackenbush
//
//  Created by Sam Carlson on 7/18/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Nimber.h"

@interface SSurreal : NSObject {
    
    NSMutableArray* left;
    
    NSMutableArray* right;
    
    BOOL hasValue;
    
    Nimber* value;
    
}

@property NSMutableArray* left;

@property NSMutableArray* right;

@property (readonly) Nimber* value;

@property BOOL hasValue;

+ (id)makeWithLeftArray:(NSArray*)leftArray rightArray:(NSArray*)rightArray;

- (BOOL)analyzeValue;

@end

