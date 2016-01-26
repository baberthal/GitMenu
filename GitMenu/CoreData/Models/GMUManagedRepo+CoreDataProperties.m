//
//  GMUManagedRepo+CoreDataProperties.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GMUManagedRepo+CoreDataProperties.h"

@implementation GMUManagedRepo (CoreDataProperties)

@dynamic isFavorite;
@dynamic lastActivity;
@dynamic repoName;
@dynamic repoURL;
@dynamic effectiveName;
@dynamic repoType;
@dynamic repoGroups;

@end
