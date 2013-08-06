//
//  Sun.m
//  Astronomical Clock
//
//  Created by Lane on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LPAstronomy.h"

@implementation LPSun

-(CGPoint)updatePosition:(LPJulianDate *)jd
{
    // low precision technique from section C24 of Astronomical Almanac
    
    // number of days since J2000
    double n = jd.jd - [LPJulianDate j2000].jd;
    // mean longitude of sun, corrected for aberration
    double L = fmod(280.460 + 0.9856474 * n, 360.0);
    // mean anomaly
    double g = fmod(357.528 + 0.9856003 * n, 360.0);
    // ecliptic longitude
    double lambda = fmod(L + 1.915 * sin(RAD(g)) + 0.020 * sin(2.0*RAD(g)), 360.0);
    // obliquity of ecliptic
    double epsilon = 23.439 - 0.0000004 * n;
    
    // right ascension
    rightAscension = fmod(DEG(atan(cos(RAD(epsilon))*tan(RAD(lambda)))), 360.0);

    // RA and lambda should be in the same quadrant
    int ql = (int)floor(lambda/90.0);
    int qra = (int)floor(rightAscension/90.0);
    if (ql<qra)
        ql += 4;
    rightAscension = fmod(rightAscension+(ql-qra)*90.0, 360.0);
    
    // declination
    declination = DEG(asin(sin(RAD(epsilon)) * sin(RAD(lambda))));
    
    // TODO other solar properties from page C24
    
    return [super updatePosition:jd];
}

@end
