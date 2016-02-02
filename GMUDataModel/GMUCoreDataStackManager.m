//
//  GMUCoreDataStackManager.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUCoreDataStackManager.h"
#import "GMUConstants.h"
#import "ZAssert.h"

static NSString *const ErrorDomain = @"CoreDataStackManager";

@implementation GMUCoreDataStackManager

@synthesize managedObjectModel = _mom;
@synthesize persistentStoreCoordinator = _coordinator;
@synthesize sharedContainerDirectory = _sharedContainerDirectory;
@synthesize storeURL = _storeURL;

+ (instancetype)sharedManager
{
    static GMUCoreDataStackManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });

    return sharedManager;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_mom) {
        return _mom;
    }

    NSBundle *sharedBundle = [NSBundle bundleWithIdentifier:kGMUBundleID];
    NSURL *momURL = [sharedBundle URLForResource:@"GMUModel" withExtension:@"momd"];
    _mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];

    return _mom;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_coordinator) {
        return _coordinator;
    }

    NSURL *url = self.storeURL;
    if (!url) {
        return nil;
    }

    NSPersistentStoreCoordinator *psc =
          [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

    NSDictionary *options = @{
        NSMigratePersistentStoresAutomaticallyOption : @YES,
        NSInferMappingModelAutomaticallyOption : @YES
    };

    NSError *error;

    if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                           configuration:nil
                                     URL:url
                                 options:options
                                   error:&error]) {
        [NSApp presentError:error];
        return nil;
    }

    _coordinator = psc;

    return _coordinator;
}

- (NSURL *)sharedContainerDirectory
{
    if (_sharedContainerDirectory) {
        return _sharedContainerDirectory;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url =
          [fileManager containerURLForSecurityApplicationGroupIdentifier:GMUAppGroupIdentifier];
    NSError *error;

    NSDictionary *properties = [url resourceValuesForKeys:@[ NSURLIsDirectoryKey ] error:&error];
    if (properties) {
        NSNumber *isDirectoryNumber = properties[NSURLIsDirectoryKey];

        if (isDirectoryNumber && !isDirectoryNumber.boolValue) {
            NSString *description =
                  NSLocalizedString(@"Could not access the app group's data folder.",
                                    @"Failed to initialize sharedContainerDirectory.");
            NSString *reason = NSLocalizedString(@"Found a file in its place.",
                                                 @"Failed to initialize sharedContainerDirectory.");
            NSDictionary *userInfo = @{
                NSLocalizedDescriptionKey : description,
                NSLocalizedFailureReasonErrorKey : reason,
            };
            error = [NSError errorWithDomain:ErrorDomain code:101 userInfo:userInfo];

            [NSApp presentError:error];

            return nil;
        }
    }

    else {
        if (error.code == NSFileReadNoSuchFileError) {
            BOOL ok = [fileManager createDirectoryAtPath:url.path
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
            if (!ok) {
                [NSApp presentError:error];

                return nil;
            }
        }
    }

    _sharedContainerDirectory = url;

    return _sharedContainerDirectory;
}

- (NSURL *)storeURL
{
    if (_storeURL) {
        return _storeURL;
    }

    _storeURL = [self.sharedContainerDirectory URLByAppendingPathComponent:GMUMainStoreFilename];

    return _storeURL;
}

@end
