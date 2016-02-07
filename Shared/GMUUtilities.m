//
//  GMUUtilities.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUUtilities.h"
@import GMUDataModel;

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
    context.persistentStoreCoordinator = localCoordinator;
    context.undoManager = nil;

    return context;
}

@implementation GMUErrorFactory

+ (void)presentCoreDataError:(NSError *)error
                 description:(NSString *)desc
                         key:(NSString *)key
                      domain:(NSString *)domain
                     andCode:(NSInteger)code
{
    DDLogError(@"%@ - %@", desc, error.localizedDescription);
    DDLogCallStack();
    NSString *description = NSLocalizedString(desc, key);
    NSDictionary *dict = @{NSLocalizedDescriptionKey : description, NSUnderlyingErrorKey : error};
    NSError *connectionError = [NSError errorWithDomain:domain code:code userInfo:dict];

    dispatch_sync(dispatch_get_main_queue(), ^{
        [NSApp presentError:connectionError];
    });
}

@end
