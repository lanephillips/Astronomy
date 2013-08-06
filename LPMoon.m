//
//  Moon.m
//  Astronomical Clock
//
//  Created by Lane on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LPAstronomy.h"

@implementation LPMoon

-(CGPoint)updatePosition:(LPJulianDate *)jd
{
    // this is the low precision formula from section D46 of the Astronomical Almanac
    
    double T = [jd julianCenturiesSinceJ2000];
    
    // ecliptic longitude
    double lambda = 218.32 + 481267.883*T
        + 6.29*sin(RAD(134.9+477198.85*T)) - 1.27*sin(RAD(259.2-413335.38*T))
        + 0.66*sin(RAD(235.7+890534.23*T)) + 0.21*sin(RAD(269.9+954397.70*T))
        - 0.19*sin(RAD(357.5+35999.05*T)) - 0.17*sin(RAD(217.6-407332.20*T));
    // ecliptic latitude
    double beta = 5.13*sin(RAD(93.3+483202.03*T)) + 0.28*sin(RAD(228.2+960400.87*T))
        - 0.28*sin(RAD(318.3+6003.18*T)) - 0.17*sin(RAD(217.6-407332.20*T));
    // horizontal parallax
    double pi = 0.9508 + 0.0518*cos(RAD(134.9+477198.85*T)) + 0.0095*cos(RAD(259.2-413335.38*T))
        + 0.0078*cos(RAD(235.7+890534.23*T)) + 0.0028*cos(RAD(269.9+954397.70*T));
    
    semidiameter = 0.2725*pi;
    distanceToEarth = 1.0/sin(RAD(pi));
    
    // geocentric direction cosines
    l = cos(RAD(beta)) * cos(RAD(lambda));
    m = 0.9175*cos(RAD(beta))*sin(RAD(lambda)) - 0.3978*sin(RAD(beta));
    n = 0.3978*cos(RAD(beta))*sin(RAD(lambda)) + 0.9175*sin(RAD(beta));
    
    declination = DEG(asin(n));
    rightAscension = DEG(atan2(m, l));
    
    return [super updatePosition:jd];
}

-(CGPoint)getTopocentricPositionFrom:(CGPoint)latlon
{
    // this is the low precision formula from section D46 of the Astronomical Almanac
    
    // assume date and geocentric position were already set with updatePosition
    
    // observer's geocentric latitude
    double phi = latlon.x;
    // observer's east longitude
    double lambda = latlon.y;
    // local sidereal time in degrees
    double T = [date julianCenturiesSinceJ2000];
    double theta = 100.46 + 36000.77*T + lambda + 15.0*[date universalTimeHours];
    
    // geocentric rectangular coordinates
    double x = distanceToEarth * l;
    double y = distanceToEarth * m;
    double z = distanceToEarth * n;
    
    // topocentric rectangular coordinates
    double tx = x - cos(RAD(phi))*cos(RAD(theta));
    double ty = y - cos(RAD(phi))*sin(RAD(theta));
    double tz = z - sin(RAD(phi));
    
    // topocentric radius
    double tr = sqrt(tx*tx + ty*ty + tz*tz);
    // TODO other topocentric measurements if we want them
    
    double topoRA = DEG(atan2(ty, tx));
    double topoD = DEG(asin(tz/tr));
    
    return CGPointMake(topoD, topoRA);
}

-(double)ageDegrees
{
    LPSun* sun = [[LPSun alloc] init];
    [sun updatePosition:date];
    double rasun = sun.rightAscension;
    
    double D = fmod(rightAscension - rasun, 360.0);
    return D;
}

@end
