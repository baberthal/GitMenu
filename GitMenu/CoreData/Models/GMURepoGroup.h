//
//  GMURepoGroup.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class GMUManagedRepo;
@class GTRepository;

NS_ASSUME_NONNULL_BEGIN

@interface GMURepoGroup : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "GMURepoGroup+CoreDataProperties.h"
