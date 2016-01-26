//
//  GMUUtilities.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUUtilities.h"
#import "GMUCoreDataStackManager.h"

NSManagedObjectContext *GMU_privateQueueContext(NSError *__autoreleasing *error)
{
    NSPersistentStoreCoordinator *localCoordinator = [[NSPersistentStoreCoordinator alloc]
          initWithManagedObjectModel:[GMUCoreDataStackManager sharedManager].managedObjectModel];

    if (![localCoordinator
              addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:[GMUCoreDataStackManager sharedManager].storeURL
                                 options:nil
                                   error:error]) {
        return nil;
    }

    NSManagedObjectContext *context =
          [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:localCoordinator];
    context.undoManager = nil;

    return context;
}