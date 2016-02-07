//
//  GMURepoGroup.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMURepoGroup.h"
#import "GMUManagedRepo.h"

@implementation GMURepoGroup

- (NSString *)displayName
{
    return (self.groupName).uppercaseString;
}

- (NSOrderedSet<GMUItem *> *)children
{
    return self.repositories;
}

- (NSNumber *)isGroupItem
{
    return @YES;
}

@end
