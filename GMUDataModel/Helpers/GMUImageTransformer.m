//
//  GMUImageTransformer.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/2/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUImageTransformer.h"

@implementation GMUImageTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    if (value == nil) {
        return nil;
    }

    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }

    if ([value isKindOfClass:[NSImage class]]) {
        return ((NSImage *)value).TIFFRepresentation;
    }

    return nil;
}

- (id)reverseTransformedValue:(id)value
{
    return [[NSImage alloc] initWithData:(NSData *)value];
}

@end
