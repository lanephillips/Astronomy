//
//  ClockModel.m
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

@implementation LPSky
@synthesize date, sun, moon;
@synthesize mercury, venus, mars, jupiter, saturn;

-(id)init
{
    self = [super init];
    if (self) {
        date = nil;
        sun = [[LPSun alloc] init];
        moon = [[LPMoon alloc] init];
        mercury = [LPPlanet mercury];
        venus = [LPPlanet venus];
        mars = [LPPlanet mars];
        jupiter = [LPPlanet jupiter];
        saturn = [LPPlanet saturn];
        [self setDateNow];
    }
    return self;
}

-(void)setDateNow
{
    [self setDate:[LPJulianDate now]];
}

-(void)setDate:(LPJulianDate *)jd
{
    date = [[LPJulianDate alloc] initWithJulianDate:jd.jd];
    [sun updatePosition:date];
    [moon updatePosition:date];
    [mercury updatePosition:date];
    [venus updatePosition:date];
    [mars updatePosition:date];
    [jupiter updatePosition:date];
    [saturn updatePosition:date];
}

@end
