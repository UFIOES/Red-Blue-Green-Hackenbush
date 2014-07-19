//
//  Nimber.h
//  Hackenbush
//
//  Created by Sam Carlson on 7/18/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#ifndef __Hackenbush__Nimber__
#define __Hackenbush__Nimber__

#include <cmath>

#endif /* defined(__Hackenbush__Nimber__) */

class Nimber {
    
    double real; // real part
    
    unsigned int star; // star part: *0, *1, *2, etc...
    
    unsigned int bigStar; // larger fuzzy part: ±1/2, ±1, ±2, etc...
    
private:
    
    Nimber();
    
public:
    
    Nimber(double r, double s, double bS);
    
    Nimber* operator+ (Nimber nim);
    
    bool operator== (Nimber nim);
    bool operator> (Nimber nim);
    bool operator< (Nimber nim);
    bool operator>= (Nimber nim);
    bool operator<= (Nimber nim);
    bool operator| (Nimber nim);
    
    double getReal();
    
};
