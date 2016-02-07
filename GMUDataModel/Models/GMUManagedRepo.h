//
//  GMUManagedRepo.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUItem.h"

typedef NS_ENUM(NSInteger, GMUManagedRepositoryType) {
    GMUManagedRepositoryTypeUnknown = -1,
    GMUManagedRepositoryTypeSource = 1,
    GMUManagedRepositoryTypeClone = 2,
    GMUManagedRepositoryTypeFork = 3
};

@class GMURepoGroup;
@class GTRepository;

NS_ASSUME_NONNULL_BEGIN

@interface GMUManagedRepo : GMUItem

@property(readonly, strong) GTRepository *underlyingRepo;

@end

NS_ASSUME_NONNULL_END

#import "GMUManagedRepo+CoreDataProperties.h"
