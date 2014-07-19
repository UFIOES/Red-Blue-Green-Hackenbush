//
//  Nimber.cpp
//  Hackenbush
//
//  Created by Sam Carlson on 7/18/14.
//  Copyright (c) 2014 Sam Carlson. All rights reserved.
//

#include "Nimber.h"

using namespace std;

Nimber::Nimber() {
    
    real = 0;
    star = 0; // star must be unsigned
    bigStar = 0; // bigStar must be unsigned
    
}

 Nimber Nimber::makeNimber(double r, double s, double bS) {
    
    Nimber nimber = *new Nimber();
    
    nimber.real = r;
    nimber.star = s; // star must be unsigned
    nimber.bigStar = bS; // bigStar must be unsigned
    
    return nimber;
    
}


Nimber Nimber::operator+ (Nimber nim) {
    
    return makeNimber(real + nim.real, star xor nim.star, bigStar > nim.bigStar ? bigStar - nim.bigStar : nim.bigStar - bigStar);
    
}


bool Nimber::operator== (Nimber nim) {
    
    if (real == nim.real && star == nim.star && bigStar == nim.bigStar) {
        
        return true;
        
    }
    
    return false;
    
}

bool Nimber::operator> (Nimber nim) {
    
    if (real - bigStar > nim.real + nim.bigStar) {
        
        return true;
        
    }
    
    return false;
    
}

bool Nimber::operator< (Nimber nim) {
    
    if (real + bigStar < nim.real - nim.bigStar) {
        
        return true;
        
    }
    
    return false;
    
}

bool Nimber::operator>= (Nimber nim) {
    
    return *this > nim || *this == nim;
    
}

bool Nimber::operator<= (Nimber nim) {
    
    return *this < nim || *this == nim;
    
}

bool Nimber::operator| (Nimber nim) { // fuzzy operator, e.g. star is fuzzy with zero
    
    if (!(*this == nim) && !(*this > nim) && !(*this < nim)) {
        
        return true;
        
    }
    
    return false;
    
}

double Nimber::getReal() {
    
    return real;
    
}

unsigned int Nimber::getStar() {
    
    return star;
    
}

unsigned int Nimber::getBigStar() {
    
    return bigStar;
    
}

