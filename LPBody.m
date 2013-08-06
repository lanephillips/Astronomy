//
//  Body.m
//  Astronomical Clock
//
//  Created by Lane on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LPAstronomy.h"

@implementation LPBody
@synthesize declination, rightAscension, date;

-(CGPoint)updatePosition:(LPJulianDate *)jd
{
    date = jd;
    return CGPointMake(declination, rightAscension);
}

@end
