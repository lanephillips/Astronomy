//
//  ClockModel.m
//  Astronomical Clock
//
//  Created by Lane on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
