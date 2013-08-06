//
//  Astronomy.h
//  Astronomical Clock
//
//  Created by Lane on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

#define RAD(x) ((x)*M_PI/180.0)
#define DEG(x) ((x)*180.0/M_PI)

#define DMS(d,m,s) ((d)+((m)+(s)/60.0)/60.0)

#define kJ2000 (2451545.0)

@interface LPJulianDate : NSObject {
    double jd;
}
@property (readonly) double jd;

+(LPJulianDate*)now;
+(LPJulianDate*)j2000;

-(id)initWithJulianDate:(double)date;
-(id)initWithDate:(NSDate*)date;

-(double)julianCenturiesSinceJ2000;
-(double)universalTimeHours;
-(double)greenwichMeanSiderealTimeHours;

@end

@interface LPAstronomy : NSObject {
    
}

+(double)obliquityOfTheEcliptic:(LPJulianDate*)jd;
+(double)greatCircleAngleFromLatitude:(double)lat1 longitude:(double)lon1 toLatitude:(double)lat2 longitude:(double)lon2;

+(NSString*)stringHoursFromDegrees:(double)degrees;
+(NSString*)stringDegrees:(double)degrees;

+(void)runAstronomyTests;

@end

@interface LPBody : NSObject {
    // the date for which the position properties are current
    LPJulianDate* date;
    // geocentric equatorial coordinates
    double declination;
    double rightAscension;
}
@property (readonly) LPJulianDate* date;
@property (readonly) double declination;
@property (readonly) double rightAscension;

// position of the body in geocentric equatorial coordinates
-(CGPoint)updatePosition:(LPJulianDate*)jd;

@end

@interface LPStar : LPBody {
    
}

@end

@interface LPSun : LPBody {
    
}

@end

@interface LPMoon : LPBody {
    double semidiameter;
    double distanceToEarth; // in Earth radii
    
    // geocentric direction cosines, used in some intermediate calculations
    double l;
    double m;
    double n;
}

-(CGPoint)getTopocentricPositionFrom:(CGPoint)latlon;
-(double)ageDegrees;

@end

@interface LPPlanet : LPBody {
    double orbitalPeriod;
    double longitudeAtEpoch;
    double longitudeOfPerhelion;
    double eccentricity;
    double semimajorAxis;
    double inclination;
    double ascendingNode;
    
    // heliocentric ecliptic coordinates
    double eclipticLatitude;
    double eclipticLongitude;
    double radius;
}

+(LPPlanet*)mercury;
+(LPPlanet*)venus;
+(LPPlanet*)earth;
+(LPPlanet*)mars;
+(LPPlanet*)jupiter;
+(LPPlanet*)saturn;
+(LPPlanet*)uranus;
+(LPPlanet*)neptune;

-(id)initWithPeriod:(double)tp longitudeAtEpoch:(double)eps perhelion:(double)omg eccentricity:(double)e
      semimajorAxis:(double)a inclination:(double)i ascendingNode:(double)asc;

-(void)updateEclipticPosition:(LPJulianDate*)jd;

@end

@interface LPSky : NSObject {
    LPJulianDate* date;
    LPSun* sun;
    LPMoon* moon;
    LPPlanet* mercury;
    LPPlanet* venus;
    LPPlanet* mars;
    LPPlanet* jupiter;
    LPPlanet* saturn;
}
@property (readonly) LPJulianDate* date;
@property (readonly) LPSun* sun;
@property (readonly) LPMoon* moon;
@property (readonly) LPPlanet* mercury;
@property (readonly) LPPlanet* venus;
@property (readonly) LPPlanet* mars;
@property (readonly) LPPlanet* jupiter;
@property (readonly) LPPlanet* saturn;

-(void)setDate:(LPJulianDate*)jd;
-(void)setDateNow;

@end

