//
//  GMUSidebarNode.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/4/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUSidebarNode.h"

@implementation GMUSidebarNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nodeTitle = @"Unnamed";
        self.children = [NSMutableArray array];

        [self setLeaf:NO];
    }

    return self;
}

- (instancetype)initLeaf
{
    self = [self init];
    if (self) {
        [self setLeaf:YES];
    }

    return self;
}

- (void)setLeaf:(BOOL)flag
{
    _isLeaf = flag;
    if (_isLeaf) {
        self.children = [NSMutableArray arrayWithObject:self];
    }
    else {
        self.children = [NSMutableArray array];
    }
}

- (NSComparisonResult)compare:(GMUSidebarNode *)aNode
{
    return [self.nodeTitle.lowercaseString compare:aNode.nodeTitle.lowercaseString];
}

#pragma mark - Drag & Drop

- (void)removeObjectFromChildren:(id)obj
{
    for (id node in self.children) {
        if (node == obj) {
            [self.children removeObjectIdenticalTo:obj];
            return;
        }

        if (![node isLeaf]) {
            [node removeObjectFromChildren:obj];
        }
    }
}

- (NSArray *)descendants
{
    NSMutableArray *descendants = [NSMutableArray array];
    id node = nil;

    for (node in self.children) {
        [descendants addObject:node];
        if (![node isLeaf]) {
            [descendants addObjectsFromArray:[node descendants]];
        }
    }

    return descendants;
}

- (NSArray *)allChildLeafs
{
    NSMutableArray *childLeafs = [NSMutableArray array];
    id node = nil;

    for (node in self.children) {
        if ([node isLeaf]) {
            [childLeafs addObject:node];
        }
        else {
            [childLeafs addObjectsFromArray:[node allChildLeafs]];
        }
    }

    return childLeafs;
}

- (NSArray *)groupChildren
{
    NSMutableArray *groupChildren = [NSMutableArray array];
    GMUSidebarNode *child;

    for (child in self.children) {
        if (!child.isLeaf) {
            [groupChildren addObject:child];
        }
    }

    return groupChildren;
}

- (BOOL)isDescendantOfOrOneOfNodes:(NSArray *)nodes
{
    id node = nil;
    for (node in nodes) {
        if (node == self) {
            return YES;
        }

        if (![node isLeaf]) {
            if ([self isDescendantOfOrOneOfNodes:[node children]])
                return YES;
        }
    }

    return NO;
}

- (BOOL)isDescendantOfNodes:(NSArray *)nodes
{
    id node = nil;
    for (node in nodes) {
        if (![node isLeaf]) {
            if ([self isDescendantOfOrOneOfNodes:[node children]])
                return YES;
        }
    }

    return NO;
}

@end
