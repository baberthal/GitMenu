//
//  GMUSidebarNode.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/4/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

@interface GMUSidebarNode : NSObject

@property(strong) NSString *nodeTitle;
@property(strong) NSMutableArray *children;
@property(assign) BOOL isLeaf;

- (instancetype)initLeaf;

@property(atomic, getter=isDraggable, readonly) BOOL draggable;

- (NSComparisonResult)compare:(GMUSidebarNode *)aNode;

- (void)removeObjectFromChildren:(id)obj;

@property(atomic, readonly, copy) NSArray *descendants;
@property(atomic, readonly, copy) NSArray *allChildLeafs;
@property(atomic, readonly, copy) NSArray *groupChildren;

- (BOOL)isDescendantOfOrOneOfNodes:(NSArray *)nodes;
- (BOOL)isDescendantOfNodes:(NSArray *)nodes;

@end
