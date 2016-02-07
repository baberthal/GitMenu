//
//  GMUConfiguration+CoreDataProperties.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GMUConfiguration+CoreDataProperties.h"

@implementation GMUConfiguration (CoreDataProperties)

@dynamic folderBadgeClean;
@dynamic folderBadgeConflicted;
@dynamic folderBadgeDirty;
@dynamic folderBadgeIgnored;
@dynamic folderBadgeNew;
@dynamic folderBadgeRenamed;
@dynamic statusRelativeToIndex;
@dynamic statusRelativeToWorktree;

@end
