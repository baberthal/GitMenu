//
//  NSColor+Solarized.h
//  CPULoad
//
//  Created by Morgan Lieberthal on 12/18/15.
//  Copyright © 2015 Morgan Lieberthal. All rights reserved.
//

@import Cocoa;

@interface NSColor (Solarized)

+ (NSColor *)solarizedBase03;
+ (NSColor *)solarizedBase02;
+ (NSColor *)solarizedBase01;
+ (NSColor *)solarizedBase00;
+ (NSColor *)solarizedBase0;
+ (NSColor *)solarizedBase1;
+ (NSColor *)solarizedBase2;
+ (NSColor *)solarizedBase3;
+ (NSColor *)solarizedYellow;
+ (NSColor *)solarizedOrange;
+ (NSColor *)solarizedRed;
+ (NSColor *)solarizedMagenta;
+ (NSColor *)solarizedViolet;
+ (NSColor *)solarizedBlue;
+ (NSColor *)solarizedCyan;
+ (NSColor *)solarizedGreen;

@property(readonly, copy) NSData *colorData;

@end
