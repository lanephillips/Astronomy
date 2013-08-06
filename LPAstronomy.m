//
//  Astronomy.m
//  Astronomical Clock
//
//  Created by Lane on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LPAstronomy.h"

// assorted functions not connected to any one body
@implementation LPAstronomy

+(double)obliquityOfTheEcliptic:(id)jd
{
    double T = [jd julianCenturiesSinceJ2000];
    double secs = -46.815*T - 0.0006*T*T + 0.00181*T*T*T;
    return DMS(23.0, 26.0, 21.45 + secs);
}

+(double)greatCircleAngleFromLatitude:(double)lat1 longitude:(double)lon1 toLatitude:(double)lat2 longitude:(double)lon2
{
	return DEG(acos(cos(RAD(lat1))*cos(RAD(lat2))*cos(RAD(lon1-lon2)) + sin(RAD(lat1))*sin(RAD(lat2))));
}

+(NSString*)stringHoursFromDegrees:(double)degrees
{
    degrees = fmod(degrees, 360.0);
    while (degrees<0.0) {
        degrees += 360.0;
    }
    double h = degrees/15.0;
    double m = fmod(h*60.0, 60.0);
    double s = fmod(m*60.0, 60.0);
    return [NSString stringWithFormat:@"%02d:%02d:%02d",
            (int)floor(h), (int)floor(m), (int)floor(s)];
}

+(NSString*)stringDegrees:(double)d
{
    int sign = (d<0.0? -1 : 1);
    double m = fmod(sign*d*60.0, 60.0);
    double s = fmod(m*60.0, 60.0);
    return [NSString stringWithFormat:@"%02d°%02d'%02d\"",
            sign*(int)floor(sign*d), (int)floor(m), (int)floor(s)];
}

+(void)runAstronomyTests
{
    LPJulianDate* now = [LPJulianDate now];
    NSLog(@"Julian Date now: %f", now.jd);
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setYear:1985];
    [comps setMonth:2];
    [comps setDay:17];
    [comps setHour:6];
    NSDate* d = [gregorian dateFromComponents:comps];
    
    LPJulianDate* jd = [[LPJulianDate alloc] initWithDate:d];
    NSLog(@"page 7: %f", jd.jd);
    
    LPSun* sun = [[LPSun alloc] init];
    CGPoint p = [sun updatePosition:now];
    NSLog(@"Sun now: (%f, %f)", p.x, p.y);
    
    [comps setYear:1980];
    [comps setMonth:7];
    [comps setDay:27];
    [comps setHour:0];
    d = [gregorian dateFromComponents:comps];
    jd = [[LPJulianDate alloc] initWithDate:d];
    p = [sun updatePosition:jd];
    NSLog(@"page 88: (%@, %@)", [LPAstronomy stringDegrees:p.x], [LPAstronomy stringHoursFromDegrees:p.y]);
    
    LPMoon* moon = [[LPMoon alloc] init];
    p = [moon updatePosition:now];
    NSLog(@"Moon now: (%f, %f)", p.x, p.y);
    
    [comps setYear:1979];
    [comps setMonth:2];
    [comps setDay:26];
    [comps setHour:16];
    d = [gregorian dateFromComponents:comps];
    jd = [[LPJulianDate alloc] initWithDate:d];
    p = [moon updatePosition:jd];
    NSLog(@"page 144: (%@, %@)", [LPAstronomy stringDegrees:p.x], [LPAstronomy stringHoursFromDegrees:p.y]);
}

@end
