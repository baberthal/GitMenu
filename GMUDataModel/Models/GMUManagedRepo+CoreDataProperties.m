//
//  GMUManagedRepo+CoreDataProperties.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GMUManagedRepo+CoreDataProperties.h"

@implementation GMUManagedRepo (CoreDataProperties)

@dynamic effectiveName;
@dynamic isFavorite;
@dynamic lastActivity;
@dynamic repoName;
@dynamic repoType;
@dynamic repoURL;
@dynamic repoGitDirectoryURL;
@dynamic displayPath;
@dynamic displayGitDirectoryPath;
@dynamic repoGroups;

@end
