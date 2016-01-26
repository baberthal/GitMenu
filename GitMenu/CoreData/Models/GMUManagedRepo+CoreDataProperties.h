//
//  GMUManagedRepo+CoreDataProperties.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GMUManagedRepo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMUManagedRepo (CoreDataProperties)

@property(nullable, nonatomic, retain) NSNumber *isFavorite;
@property(nullable, nonatomic, retain) NSDate *lastActivity;
@property(nullable, nonatomic, retain) NSString *repoName;
@property(nullable, nonatomic, retain) NSURL *repoURL;
@property(nullable, nonatomic, retain) NSString *effectiveName;
@property(nullable, nonatomic, retain) NSNumber *repoType;
@property(nullable, nonatomic, retain) NSOrderedSet<GMURepoGroup *> *repoGroups;

@end

@interface GMUManagedRepo (CoreDataGeneratedAccessors)

- (void)insertObject:(GMURepoGroup *)value inRepoGroupsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRepoGroupsAtIndex:(NSUInteger)idx;
- (void)insertRepoGroups:(NSArray<GMURepoGroup *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRepoGroupsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRepoGroupsAtIndex:(NSUInteger)idx withObject:(GMURepoGroup *)value;
- (void)replaceRepoGroupsAtIndexes:(NSIndexSet *)indexes
                    withRepoGroups:(NSArray<GMURepoGroup *> *)values;
- (void)addRepoGroupsObject:(GMURepoGroup *)value;
- (void)removeRepoGroupsObject:(GMURepoGroup *)value;
- (void)addRepoGroups:(NSOrderedSet<GMURepoGroup *> *)values;
- (void)removeRepoGroups:(NSOrderedSet<GMURepoGroup *> *)values;

@end

NS_ASSUME_NONNULL_END
