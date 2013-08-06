//
//  Astronomy.m
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
