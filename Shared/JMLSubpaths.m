//
//  NSURL+Subpaths.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/4/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "JMLSubpaths.h"

@implementation NSURL (Subpaths)

- (BOOL)jml_hasDirectoryPath
{
    return CFURLHasDirectoryPath((__bridge CFURLRef)self);
}

- (BOOL)jml_isSubpathOfURL:(NSURL *)aURL
{
    NSString *myPath;
    NSString *otherPath;

    if (self.fileURL && aURL.fileURL) {
        myPath = self.path.stringByResolvingSymlinksInPath;
        otherPath = aURL.path.stringByResolvingSymlinksInPath;
        return [myPath jml_isSubpathOfPath:otherPath];
    }

    if (!(self.scheme && aURL.scheme &&
          [self.scheme compare:aURL.scheme options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
        return NO;
    }

    if (!(self.host && aURL.host &&
          [self.host compare:aURL.host options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
        myPath = self.standardizedURL.path;
        otherPath = aURL.standardizedURL.path;

        if (myPath && otherPath) {
            if (myPath.length == 0)
                myPath = @"/";
            if (otherPath.length == 0)
                otherPath = @"/";

            return [myPath jml_isSubpathOfPath:otherPath];
        }
    }

    return NO;
}

@end

@implementation NSString (Subpaths)

- (BOOL)jml_isSubpathOfPath:(NSString *)aPath
{
    NSParameterAssert(aPath); // karelia case #115844

    // Strip off trailing slashes as they confuse the search
    while ([aPath hasSuffix:@"/"] && ![self hasSuffix:@"/"] && aPath.length > 1) {
        aPath = [aPath substringToIndex:aPath.length - 1];
    }

    // Used to -hasPrefix:, but really need to do it case insensitively
    NSRange range = [self rangeOfString:aPath options:NSAnchoredSearch | NSCaseInsensitiveSearch];

    if (range.location != 0)
        return NO;

    // Correct for last component being only a sub*string*
    if (self.length == range.length)
        return YES; // shortcut for exact match
    if ([aPath hasSuffix:@"/"])
        return YES; // when has a directory termintator, no risk of mismatch

    BOOL result = ([self characterAtIndex:range.length] == '/');
    return result;
}

@end