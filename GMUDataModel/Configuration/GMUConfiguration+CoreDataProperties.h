//
//  GMUConfiguration+CoreDataProperties.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GMUConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMUConfiguration (CoreDataProperties)

@property(nullable, nonatomic, retain) NSImage *folderBadgeClean;
@property(nullable, nonatomic, retain) NSImage *folderBadgeConflicted;
@property(nullable, nonatomic, retain) NSImage *folderBadgeDirty;
@property(nullable, nonatomic, retain) NSImage *folderBadgeIgnored;
@property(nullable, nonatomic, retain) NSImage *folderBadgeNew;
@property(nullable, nonatomic, retain) NSImage *folderBadgeRenamed;
@property(nullable, nonatomic, retain) NSNumber *statusRelativeToIndex;
@property(nullable, nonatomic, retain) NSNumber *statusRelativeToWorktree;

@end

NS_ASSUME_NONNULL_END
