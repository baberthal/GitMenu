//
//  GMUCoreDataStackManager.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

@import Cocoa;

@interface GMUCoreDataStackManager : NSObject

+ (instancetype)sharedManager;

/// Managed object model for the framework.
@property(nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;

/// Primary persistent store coordinator.
@property(nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/// URL for the CoreData store file.
@property(nonatomic, readonly) NSURL *storeURL;

/// URL for the shared application group container directory.
@property(nonatomic, readonly) NSURL *sharedContainerDirectory;

@end
