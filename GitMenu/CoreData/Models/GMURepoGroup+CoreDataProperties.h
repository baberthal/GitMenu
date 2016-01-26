//
//  GMURepoGroup+CoreDataProperties.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GMURepoGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMURepoGroup (CoreDataProperties)

@property(nullable, nonatomic, retain) NSString *groupName;
@property(nullable, nonatomic, retain) NSOrderedSet<GMUManagedRepo *> *repositories;

@end

@interface GMURepoGroup (CoreDataGeneratedAccessors)

- (void)insertObject:(GMUManagedRepo *)value inRepositoriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRepositoriesAtIndex:(NSUInteger)idx;
- (void)insertRepositories:(NSArray<GMUManagedRepo *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRepositoriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRepositoriesAtIndex:(NSUInteger)idx withObject:(GMUManagedRepo *)value;
- (void)replaceRepositoriesAtIndexes:(NSIndexSet *)indexes
                    withRepositories:(NSArray<GMUManagedRepo *> *)values;
- (void)addRepositoriesObject:(GMUManagedRepo *)value;
- (void)removeRepositoriesObject:(GMUManagedRepo *)value;
- (void)addRepositories:(NSOrderedSet<GMUManagedRepo *> *)values;
- (void)removeRepositories:(NSOrderedSet<GMUManagedRepo *> *)values;

@end

NS_ASSUME_NONNULL_END
