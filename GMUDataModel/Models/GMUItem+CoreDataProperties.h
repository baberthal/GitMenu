//
//  GMUItem+CoreDataProperties.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/4/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GMUItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMUItem (CoreDataProperties)

@property(nullable, nonatomic, retain) NSString *displayName;
@property(nullable, nonatomic, retain) NSNumber *isGroupItem;
@property(nullable, nonatomic, retain) NSOrderedSet<GMUItem *> *children;
@property(nullable, nonatomic, retain) GMUItem *parent;

@end

@interface GMUItem (CoreDataGeneratedAccessors)

- (void)insertObject:(GMUItem *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray<GMUItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(GMUItem *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray<GMUItem *> *)values;
- (void)addChildrenObject:(GMUItem *)value;
- (void)removeChildrenObject:(GMUItem *)value;
- (void)addChildren:(NSOrderedSet<GMUItem *> *)values;
- (void)removeChildren:(NSOrderedSet<GMUItem *> *)values;

@end

NS_ASSUME_NONNULL_END
