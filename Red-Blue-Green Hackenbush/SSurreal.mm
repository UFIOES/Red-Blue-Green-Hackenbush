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
    
    surreal->value = Nimber::makeNimber(0, 0, 0);
    
    surreal->hasValue = NO;
    
    return surreal;
    
}

Nimber simplestNimber(Nimber leftNimber, Nimber rightNimber) {
    
    if (leftNimber < Nimber::makeNimber(0, 0, 0) && rightNimber > Nimber::makeNimber(0, 0, 0)) {
        
        return Nimber::makeNimber(0, 0, 0);
        
    } else if (leftNimber >= Nimber::makeNimber(0, 0, 0)) {
        
        if (rightNimber.getReal() > floor(leftNimber.getReal()) + 1) {
            
            return Nimber::makeNimber(floor(leftNimber.getReal()) + 1, leftNimber.getStar(), leftNimber.getBigStar());
            
        } else {
            
            double n = 0.5;
            
            double m = 0;
            
            while (YES) {
                
                if (floor(leftNimber.getReal()) + n + m <= leftNimber.getReal()) {
                    
                    m += n;
                    
                } else if (rightNimber.getReal() > floor(leftNimber.getReal()) + n + m) {
                    
                    return Nimber::makeNimber(floor(leftNimber.getReal()) + n + m, leftNimber.getStar(), leftNimber.getBigStar());
                    
                }
                
                n = n/2.0;
                
            }
            
        }
        
    } else if (rightNimber <= Nimber::makeNimber(0, 0, 0)) {
        
        if (leftNimber.getReal() < ceil(rightNimber.getReal()) - 1) {
            
            return Nimber::makeNimber(ceil(rightNimber.getReal()) - 1, rightNimber.getStar(), rightNimber.getBigStar());
            
        } else {
            
            double n = 0.5;
            
            double m = 0;
            
            while (YES) {
                
                if (ceil(rightNimber.getReal()) - n - m >= rightNimber.getReal()) {
                    
                    m += n;
                    
                } else if (leftNimber.getReal() < ceil(rightNimber.getReal()) - n - m) {
                    
                    return Nimber::makeNimber(ceil(rightNimber.getReal()) - n - m, rightNimber.getStar(), rightNimber.getBigStar());
                    
                }
                
                n = n/2.0;
                
            }
            
        }
        
    }
    
    return Nimber::makeNimber(0, 0, 0);
    
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
        
        value = Nimber::makeNimber(0,0,0);
        
        return hasValue = YES;
        
    } else if (left.count == 1 && right.count == 0) {
        
        value = ((SSurreal*) left.firstObject).value + Nimber::makeNimber(1,0,0);
        
        return hasValue = YES;
        
    } else if (left.count == 0 && right.count == 1) {
        
        value = ((SSurreal*) right.firstObject).value + Nimber::makeNimber(-1,0,0);
        
        return hasValue = YES;
        
    } else if (right.count == 0) { //only left options
        
        SSurreal* champion = [left firstObject];
        
        NSMutableArray* champions = [NSMutableArray array];
        
        for (SSurreal* surreal in left) { //finds the largest value in left, if the values is fuzzy, finds the first
            
            if (champion.value < surreal.value) {
                
                champion = surreal;
                
            }
            
        }
        
        [champions addObject:champion];
        
        for (SSurreal* surreal in left) {
            
            if (champion.value | surreal.value) {
                
                [champions addObject:surreal];
                
            }
            
        }
        
        if (champions.count == 1) {
            
            value = champion.value + Nimber::makeNimber(1,0,0);
            
            hasValue = YES;
            
            return YES;
            
        } else {
            
            left = champions;
            
            return NO;
            
        }
        
    } else if (left.count == 0) { //only right options
        
        SSurreal* champion = [right firstObject];
        
        NSMutableArray* champions = [NSMutableArray array];
        
        for (SSurreal* surreal in right) { //finds the smallest value in right, if the values is fuzzy, finds the first
            
            if (champion.value > surreal.value) {
                
                champion = surreal;
                
            }
            
        }
        
        [champions addObject:champion];
        
        for (SSurreal* surreal in right) {
            
            if (champion.value | surreal.value) {
                
                [champions addObject:surreal];
                
            }
            
        }
        
        if (champions.count == 1) {
            
            value = champion.value + Nimber::makeNimber(-1,0,0);
            
            hasValue = YES;
            
            return YES;
            
        } else {
            
            right = champions;
            
            return NO;
            
        }
        
    } else {
        
        SSurreal* leftChampion = [left firstObject];
        
        SSurreal* rightChampion = [right firstObject];
        
        NSMutableArray* leftChampions = [NSMutableArray array];
        
        NSMutableArray* rightChampions = [NSMutableArray array];
        
        for (SSurreal* surreal in left) { //finds the largest value in left, if the values is fuzzy, finds the first
            
            if (leftChampion.value < surreal.value) {
                
                leftChampion = surreal;
                
            }
            
        }
        
        for (SSurreal* surreal in right) { //finds the largest value in left, if the values is fuzzy, finds the first
            
            if (rightChampion.value > surreal.value) {
                
                rightChampion = surreal;
                
            }
            
        }
        
        [leftChampions addObject:leftChampion];
        
        [rightChampions addObject:rightChampion];
        
        for (SSurreal* surreal in left) {
            
            if (leftChampion.value | surreal.value) {
                
                [leftChampions addObject:surreal];
                
            }
            
        }
        
        for (SSurreal* surreal in right) {
            
            if (rightChampion.value | surreal.value) {
                
                [rightChampions addObject:surreal];
                
            }
            
        }
        
        left = leftChampions;
        
        right = rightChampions;
        
        if (leftChampions.count == 1 && rightChampions.count == 1) {
            
            if (leftChampion.value < rightChampion.value) {
                
                value = simplestNimber(leftChampion.value, rightChampion.value);
                
                return hasValue = YES;
                
            } else if (leftChampion.value == rightChampion.value) {
                
                value = leftChampion.value + Nimber::makeNimber(0, 1, 0);
                
                return hasValue = YES;
                
            }
            
        } else if (leftChampions.count == rightChampions.count) {
            
            BOOL same = YES;
            
            [leftChampions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                SSurreal* surreal1 = (SSurreal*) obj1;
                SSurreal* surreal2 = (SSurreal*) obj2;
                
                if (surreal1.value.getStar() < surreal2.value.getStar()) {
                    
                    return (NSComparisonResult) NSOrderedAscending;
                    
                } else if (surreal1.value.getStar() > surreal2.value.getStar()) {
                    
                    return (NSComparisonResult) NSOrderedDescending;
                    
                }
                
                return (NSComparisonResult) NSOrderedSame;
                
            }];
            
            [rightChampions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                SSurreal* surreal1 = (SSurreal*) obj1;
                SSurreal* surreal2 = (SSurreal*) obj2;
                
                if (surreal1.value.getStar() < surreal2.value.getStar()) {
                    
                    return (NSComparisonResult) NSOrderedAscending;
                    
                } else if (surreal1.value.getStar() > surreal2.value.getStar()) {
                    
                    return (NSComparisonResult) NSOrderedDescending;
                    
                }
                
                return (NSComparisonResult) NSOrderedSame;
                
            }];
            
            for (int i=0; i < leftChampions.count; i++) {
                
                if (!(((SSurreal*)[leftChampions objectAtIndex:i]).value == ((SSurreal*)[rightChampions objectAtIndex:i]).value)) {
                    
                    same = NO;
                    break;
                    
                }
                
                if (((SSurreal*)[leftChampions objectAtIndex:i]).value.getBigStar() != 0 || ((SSurreal*)[leftChampions objectAtIndex:i]).value.getReal() != 0) {
                    
                    same = NO;
                    break;
                    
                }
                
                if (((SSurreal*)[rightChampions objectAtIndex:i]).value.getBigStar() != 0 || ((SSurreal*)[rightChampions objectAtIndex:i]).value.getReal() != 0) {
                    
                    same = NO;
                    break;
                    
                }
                
            }
            
            if (same) {
                
                unsigned int lastStar = -1;
                
                for (int i=0; i < leftChampions.count; i++) {
                    
                    unsigned int star = ((SSurreal*)[leftChampions objectAtIndex:i]).value.getStar();
                    
                    if (star != lastStar + 1) {
                        
                        value = Nimber::makeNimber(0, lastStar + 1, 0);
                        
                        return hasValue = YES;
                        
                    }
                    
                    lastStar = star;
                    
                }
                
                value = Nimber::makeNimber(0, lastStar + 1, 0);
                
                return hasValue = YES;
                
            }
            
        }
        
    }
    
    hasValue = NO;
    
    return NO;
    
}

- (NSString*)toString {
    
    NSString* string = @"{";
    
    for (SSurreal* surreal in left) {
        
        if (surreal.hasValue) {
            
            NSString* substring = @"0";
            
            double realValue = surreal.value.getReal();
            
            unsigned int starValue = surreal.value.getStar();
            
            if (realValue != 0) {
                
                substring = [NSString stringWithFormat:@"%.*f", 12, realValue];
                
                unsigned long i = substring.length - 1;
                
                while (YES) {
                    
                    if ([substring characterAtIndex:i] != '0' || [substring characterAtIndex:i] == '.') break;
                    
                    i--;
                    
                }
                
                substring = [substring substringToIndex:i+1];
                
                if (starValue != 0) {
                    
                    substring = [substring stringByAppendingString:[NSString stringWithFormat:@"+*%u", starValue]];
                    
                }
                
            } else if (starValue != 0) {
                
                substring = [NSString stringWithFormat:@"*%u", starValue ];
                
            }
            
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,", substring]];
            
        } else {
            
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,", [surreal toString]]];
            
        }
        
    }
    
    string = [string substringToIndex:string.length - 1];
    
    string = [string stringByAppendingString:@"|"];
    
    for (SSurreal* surreal in right) {
        
        if (surreal.hasValue) {
            
            NSString* substring = @"0";
            
            double realValue = surreal.value.getReal();
            
            unsigned int starValue = surreal.value.getStar();
            
            if (realValue != 0) {
                
                substring = [NSString stringWithFormat:@"%.*f", 12, realValue];
                
                unsigned long i = substring.length - 1;
                
                while (YES) {
                    
                    if ([substring characterAtIndex:i] != '0' || [substring characterAtIndex:i] == '.') break;
                    
                    i--;
                    
                }
                
                substring = [substring substringToIndex:i+1];
                
                if (starValue != 0) {
                    
                    substring = [substring stringByAppendingString:[NSString stringWithFormat:@"+*%u", starValue]];
                    
                }
                
            } else if (starValue != 0) {
                
                substring = [NSString stringWithFormat:@"*%u", starValue ];
                
            }
            
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,", substring]];
            
        } else {
            
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,", [surreal toString]]];
            
        }
        
    }
    
    string = [string substringToIndex:string.length - 1];
    
    string = [string stringByAppendingString:@"}"];
    
    return string;
    
}

@end
