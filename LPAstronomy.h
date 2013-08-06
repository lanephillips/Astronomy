//
//  Astronomy.h
//
//  Created by Lane Phillips (@bugloaf) on 7/17/11.
//
//  The MIT License (MIT)
//
//  Copyright 2011-2013 Milk LLC (@Milk_LLC).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

