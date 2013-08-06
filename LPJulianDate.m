//
//  JulianDate.m
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

@implementation LPJulianDate
@synthesize jd;

+(LPJulianDate*)now
{
    return [[LPJulianDate alloc] initWithDate:[NSDate date]];
}

+(LPJulianDate*)j2000
{
    static LPJulianDate* j2 = nil;
    if (!j2) {
        j2 = [[LPJulianDate alloc] initWithJulianDate:kJ2000];
    }
    return j2;
}

-(id)initWithJulianDate:(double)date
{
    self = [super init];
    if (self) {
        jd = date;
    }
    return self;
}

-(id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
         
        NSDateComponents *comps =
        [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                               NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                     fromDate:date];
        
        int y = [comps year];
        int m = [comps month];
        double d = [comps day] + ([comps hour] + ([comps minute] + [comps second]/60.0)/60.0)/24.0;
        
        if (m==1 || m==2) {
            y -= 1;
            m += 12;
        }
        
        int A = (int)trunc(y / 100.0);
        int B = 2 - A + (int)trunc(A / 4.0);
        
        int C = (int)(y<0? trunc(365.25*y - 0.75) : trunc(365.25*y));
        int D = (int)trunc(30.6001*(m+1));

        jd = B + C + D + d + 1720994.5;
    }
    return self;
}

-(double)julianCenturiesSinceJ2000
{
    return (jd - kJ2000)/36525.0;
}

-(double)universalTimeHours
{
    return fmod(jd + 0.5, 1.0) * 24.0;
}

-(double)greenwichMeanSiderealTimeHours
{
    return fmod(18.697374558 + 24.06570982441908 * (jd - kJ2000), 24.0);
}

@end
