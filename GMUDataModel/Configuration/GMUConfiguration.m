//
//  GMUConfiguration.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/2/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUConfiguration.h"
#import "EXTKeyPathCoding.h"
#import <Cocoa/Cocoa.h>

@implementation GMUConfiguration

- (NSImage *)folderBadgeNew
{
    NSImage *internal = [self primitiveValueForKey:@keypath(self, folderBadgeNew)];
    if (!internal) {
        internal = [NSImage imageNamed:@"folder-badge-new"];
        [self setPrimitiveValue:internal forKey:@keypath(self, folderBadgeNew)];
    }

    return internal;
}

- (NSImage *)folderBadgeDirty
{
    NSImage *internal = [self primitiveValueForKey:@keypath(self, folderBadgeDirty)];
    if (!internal) {
        internal = [NSImage imageNamed:@"folder-badge-dirty"];
        [self setPrimitiveValue:internal forKey:@keypath(self, folderBadgeDirty)];
    }

    return internal;
}

- (NSImage *)folderBadgeClean
{
    NSImage *internal = [self primitiveValueForKey:@keypath(self, folderBadgeClean)];
    if (!internal) {
        internal = [NSImage imageNamed:@"folder-badge-clean"];
        [self setPrimitiveValue:internal forKey:@keypath(self, folderBadgeClean)];
    }

    return internal;
}

- (NSImage *)folderBadgeRenamed
{
    NSImage *internal = [self primitiveValueForKey:@keypath(self, folderBadgeRenamed)];
    if (!internal) {
        internal = [NSImage imageNamed:@"folder-badge-renamed"];
        [self setPrimitiveValue:internal forKey:@keypath(self, folderBadgeRenamed)];
    }

    return internal;
}

- (NSImage *)folderBadgeIgnored
{
    NSImage *internal = [self primitiveValueForKey:@keypath(self, folderBadgeIgnored)];
    if (!internal) {
        internal = [NSImage imageNamed:@"folder-badge-ignored"];
        [self setPrimitiveValue:internal forKey:@keypath(self, folderBadgeIgnored)];
    }

    return internal;
}

- (NSImage *)folderBadgeConflicted
{
    NSImage *internal = [self primitiveValueForKey:@keypath(self, folderBadgeConflicted)];
    if (!internal) {
        internal = [NSImage imageNamed:@"folder-badge-conflicted"];
        [self setPrimitiveValue:internal forKey:@keypath(self, folderBadgeConflicted)];
    }

    return internal;
}

@end
