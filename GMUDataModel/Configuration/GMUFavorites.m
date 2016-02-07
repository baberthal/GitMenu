//
//  GMUFavorites.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/4/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUFavorites.h"
#import "GMUManagedRepo.h"

@implementation GMUFavorites

- (NSString *)displayName
{
    return @"FAVORITES";
}

- (NSOrderedSet<GMUItem *> *)children
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"ManagedRepository"];
    req.predicate = [NSPredicate predicateWithFormat:@"ANY isFavorite == YES"];
    NSError *error;

    NSArray<GMUManagedRepo *> *fetched =
          [self.managedObjectContext executeFetchRequest:req error:&error];
    if (!fetched) {
        NSLog(@"Error fetching... %@", error.localizedDescription);
        return nil;
    }

    return [NSOrderedSet orderedSetWithArray:fetched];
}

- (GMUItem *)parent
{
    return nil;
}

- (NSNumber *)isGroupItem
{
    return @YES;
}

@end
