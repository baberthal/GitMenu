//
//  NSColor+Solarized.m
//  CPULoad
//
//  Created by Morgan Lieberthal on 12/18/15.
//  Copyright © 2015 Morgan Lieberthal. All rights reserved.
//

#import "NSColor+Solarized.h"

@implementation NSColor (Solarized)

+ (NSColor *)solarizedBase03
{
    return [NSColor colorWithCalibratedHue:(193 / 360.f) saturation:1.0 brightness:0.21 alpha:1.0];
}

+ (NSColor *)solarizedBase02
{
    return [NSColor colorWithCalibratedHue:(192 / 360.f) saturation:0.9 brightness:0.26 alpha:1.0];
}

+ (NSColor *)solarizedBase01
{
    return [NSColor colorWithCalibratedHue:(194 / 360.f) saturation:0.25 brightness:0.46 alpha:1.0];
}

+ (NSColor *)solarizedBase00
{
    return [NSColor colorWithCalibratedHue:(195 / 360.f) saturation:0.23 brightness:0.51 alpha:1.0];
}

+ (NSColor *)solarizedBase0
{
    return [NSColor colorWithCalibratedHue:(186 / 360.f) saturation:0.13 brightness:0.59 alpha:1.0];
}

+ (NSColor *)solarizedBase1
{
    return [NSColor colorWithCalibratedHue:(180 / 360.f) saturation:0.09 brightness:0.63 alpha:1.0];
}

+ (NSColor *)solarizedBase2
{
    return [NSColor colorWithCalibratedHue:(44 / 360.f) saturation:0.11 brightness:0.93 alpha:1.0];
}

+ (NSColor *)solarizedBase3
{
    return [NSColor colorWithCalibratedHue:(44 / 360.f) saturation:0.10 brightness:0.99 alpha:1.0];
}

+ (NSColor *)solarizedYellow
{
    return [NSColor colorWithCalibratedHue:(45 / 360.f) saturation:1.0 brightness:0.71 alpha:1.0];
}

+ (NSColor *)solarizedOrange
{
    return [NSColor colorWithCalibratedHue:(18 / 360.f) saturation:0.89 brightness:0.8 alpha:1.0];
}

+ (NSColor *)solarizedRed
{
    return [NSColor colorWithCalibratedHue:(1 / 360.f) saturation:0.79 brightness:0.86 alpha:1.0];
}

+ (NSColor *)solarizedMagenta
{
    return [NSColor colorWithCalibratedHue:(331 / 360.f) saturation:0.74 brightness:0.83 alpha:1.0];
}

+ (NSColor *)solarizedViolet
{
    return [NSColor colorWithCalibratedHue:(237 / 360.f) saturation:0.45 brightness:0.77 alpha:1.0];
}

+ (NSColor *)solarizedBlue
{
    return [NSColor colorWithCalibratedHue:(205 / 360.f) saturation:0.82 brightness:0.82 alpha:1.0];
}

+ (NSColor *)solarizedCyan
{
    return [NSColor colorWithCalibratedHue:(175 / 360.f) saturation:0.74 brightness:0.63 alpha:1.0];
}

+ (NSColor *)solarizedGreen
{
    return [NSColor colorWithCalibratedHue:(68 / 360.f) saturation:1.0 brightness:0.6 alpha:1.0];
}

- (NSData *)colorData
{
    return [NSArchiver archivedDataWithRootObject:self];
}

@end
