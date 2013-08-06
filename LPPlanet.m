//
//  Planet.m
//  Astronomical Clock
//
//  Created by Lane on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LPAstronomy.h"

@implementation LPPlanet

+(LPPlanet*)mercury
{
    return [[LPPlanet alloc] initWithPeriod:0.240852 longitudeAtEpoch:60.750646 perhelion:77.299833 eccentricity:0.205633 semimajorAxis:0.387099 inclination:7.004540 ascendingNode:48.212740];
}

+(LPPlanet*)venus
{
    return [[LPPlanet alloc] initWithPeriod:0.615211 longitudeAtEpoch:88.455855 perhelion:131.430236 eccentricity:0.006778 semimajorAxis:0.723332 inclination:3.394535 ascendingNode:76.589820];
}

+(LPPlanet*)earth
{
    return [[LPPlanet alloc] initWithPeriod:1.00004 longitudeAtEpoch:99.403308 perhelion:102.768413 eccentricity:0.016713 semimajorAxis:1.00000 inclination:0.0 ascendingNode:0.0];
}

+(LPPlanet*)mars
{
    return [[LPPlanet alloc] initWithPeriod:1.880932 longitudeAtEpoch:240.739474 perhelion:335.874939 eccentricity:0.093396 semimajorAxis:1.523688 inclination:1.849736 ascendingNode:49.480308];
}

+(LPPlanet*)jupiter
{
    return [[LPPlanet alloc] initWithPeriod:11.863075 longitudeAtEpoch:90.638185 perhelion:14.170747 eccentricity:0.048482 semimajorAxis:5.202561 inclination:1.303613 ascendingNode:100.353142];
}

+(LPPlanet*)saturn
{
    return [[LPPlanet alloc] initWithPeriod:29.471362 longitudeAtEpoch:287.690033 perhelion:92.861407 eccentricity:0.055581 semimajorAxis:9.554747 inclination:2.488980 ascendingNode:113.576139];
}

+(LPPlanet*)uranus
{
    return [[LPPlanet alloc] initWithPeriod:84.039492 longitudeAtEpoch:271.063148 perhelion:172.884833 eccentricity:0.046321 semimajorAxis:19.21814 inclination:0.773059 ascendingNode:73.926961];
}

+(LPPlanet*)neptune
{
    return [[LPPlanet alloc] initWithPeriod:164.79246 longitudeAtEpoch:282.349556 perhelion:48.009758 eccentricity:0.009003 semimajorAxis:30.109570 inclination:1.770646 ascendingNode:131.670599];
}

-(id)initWithPeriod:(double)tp longitudeAtEpoch:(double)eps perhelion:(double)omg eccentricity:(double)e
      semimajorAxis:(double)a inclination:(double)i ascendingNode:(double)asc
{
    self = [super init];
    if (self) {
        orbitalPeriod = tp;
        longitudeAtEpoch = eps;
        longitudeOfPerhelion = omg;
        eccentricity = e;
        semimajorAxis = a;
        inclination = i;
        ascendingNode = asc;
    }
    return self;
}

-(void)updateEclipticPosition:(LPJulianDate*)jd
{
    // using the method of section 54 in Practical Astronomy with Your Calculator
    
    // days since epoch of 1990 Jan 0.0
    double D = jd.jd - 2447891.5;
    
    // mean anomaly
    double M = 360.0 * D / 365.242191 / orbitalPeriod + longitudeAtEpoch - longitudeOfPerhelion;
    // true anomaly
    // TODO a more precise value can be obtained by solving Kepler's equation
    double nu = M + 360.0 * eccentricity * sin(RAD(M)) / M_PI;
    
    // heliocentric longitude
    double l = nu + longitudeOfPerhelion;
    
    // length of the radius vector
    double r = semimajorAxis * (1.0 - eccentricity*eccentricity) / (1.0 + eccentricity*cos(RAD(nu)));
    
    if (self==[LPPlanet earth]) {
        eclipticLatitude = 0.0;
        eclipticLongitude = l;
        radius = r;
        
        date = jd;
    } else {
        // heliocentric ecliptic latitude
        eclipticLatitude = DEG(asin(sin(RAD(l - ascendingNode))*sin(RAD(inclination))));
    
        // project longitude onto the ecliptic plane
        eclipticLongitude = DEG(atan2(sin(RAD(l - ascendingNode))*cos(RAD(inclination)), cos(RAD(l - ascendingNode)))) + ascendingNode;
        
        // and project radius
        radius = r * cos(eclipticLatitude);
    }
}

-(CGPoint)updatePosition:(LPJulianDate *)jd
{
    LPPlanet* earth = [LPPlanet earth];
    [earth updateEclipticPosition:jd];
    double L = earth->eclipticLongitude;
    double R = earth->radius;
    
    [self updateEclipticPosition:jd];
    
    // geocentric longitude
    double lambda;
    if (semimajorAxis > 1.0) {
        // outer planets
        lambda = DEG(atan2(R*sin(RAD(eclipticLongitude - L)), 
                           radius - R * cos(RAD(eclipticLongitude - L)))) + eclipticLongitude;
    } else {
        // inner planets
        lambda = 180.0 + L + DEG(atan2(radius*sin(RAD(L - eclipticLongitude)), 
                           R - radius * cos(RAD(L - eclipticLongitude))));
    }
    
    // geocentric latitude
    double beta = DEG(atan2(radius*tan(RAD(eclipticLatitude))*sin(RAD(lambda-eclipticLongitude)), R*sin(RAD(eclipticLongitude - L))));
    
    // obliquity of the ecliptic
    double e = [LPAstronomy obliquityOfTheEcliptic:jd];
    
    // convert to equatorial coordinates
    rightAscension = DEG(atan2(sin(RAD(lambda))*cos(RAD(e)) - tan(RAD(beta))*sin(RAD(e)), cos(RAD(lambda))));
    
    declination = DEG(asin(sin(RAD(beta))*cos(RAD(e)) + cos(RAD(beta))*sin(RAD(e))*sin(RAD(lambda))));
    
    return [super updatePosition:jd];
}

@end
