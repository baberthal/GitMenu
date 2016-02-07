//
//  GMUItem+CoreDataProperties.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/4/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GMUItem+CoreDataProperties.h"

@implementation GMUItem (CoreDataProperties)

@dynamic displayName;
@dynamic isGroupItem;
@dynamic children;
@dynamic parent;

@end
