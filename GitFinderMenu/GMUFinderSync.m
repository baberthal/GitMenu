//
//  FinderSync.m
//  GitFinderMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUFinderSync.h"
#import "GMURepoController.h"
#import <GMUDataModel/GMUDataModel.h>

@interface GMUFinderSync ()

@property NSURL *myFolderURL;
@property(nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, readonly) NSSet<NSURL *> *observedRepoURLs;
@property(strong) NSMutableSet<GMURepoController *> *repoControllers;
@property(nonatomic, strong, readonly) NSArray<GMUManagedRepo *> *managedRepos;

- (GMURepoController *)repoControllerForURL:(NSURL *)url;

@end

static NSString *const GMUFinderSyncErrorDomain = @"GMU_FINDER_SYNC_ERROR_DOMAIN";

@implementation GMUFinderSync

- (instancetype)init
{
    self = [super init];

    NSLog(@"%s launched from %@ ; compiled at %s", __PRETTY_FUNCTION__,
          [NSBundle mainBundle].bundlePath, __TIME__);

    self.repoControllers = [NSMutableSet set];
    // Set up the directory we are syncing.
    self.myFolderURL = [NSURL fileURLWithPath:@"/Users/Shared/MySyncExtension Documents"];
    [FIFinderSyncController defaultController].directoryURLs = self.observedRepoURLs;

    // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf
    // images.
    [self registerImages];

    return self;
}

- (void)registerImages
{
    [[FIFinderSyncController defaultController] setBadgeImage:self.configuration.folderBadgeNew
                                                        label:@"New"
                                           forBadgeIdentifier:@"New"];
    [[FIFinderSyncController defaultController] setBadgeImage:self.configuration.folderBadgeDirty
                                                        label:@"Dirty"
                                           forBadgeIdentifier:@"Dirty"];
    [[FIFinderSyncController defaultController] setBadgeImage:self.configuration.folderBadgeClean
                                                        label:@"Clean"
                                           forBadgeIdentifier:@"Clean"];
    [[FIFinderSyncController defaultController] setBadgeImage:self.configuration.folderBadgeRenamed
                                                        label:@"Renamed"
                                           forBadgeIdentifier:@"Renamed"];
    [[FIFinderSyncController defaultController] setBadgeImage:self.configuration.folderBadgeIgnored
                                                        label:@"Ignored"
                                           forBadgeIdentifier:@"Ignored"];
    [[FIFinderSyncController defaultController]
               setBadgeImage:self.configuration.folderBadgeConflicted
                       label:@"Conflicted"
          forBadgeIdentifier:@"Conflicted"];
}

#pragma mark - Property Overrides

@synthesize managedObjectContext = _context;
@synthesize configuration = _configuration;
@synthesize observedRepoURLs = _observedRepoURLs;
@synthesize managedRepos = _managedRepos;
@synthesize repoControllers = _repoControllers;

- (NSManagedObjectContext *)managedObjectContext
{
    if (_context) {
        return _context;
    }

    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.persistentStoreCoordinator =
          [GMUCoreDataStackManager sharedManager].persistentStoreCoordinator;

    return _context;
}

- (GMUConfiguration *)configuration
{
    if (_configuration) {
        return _configuration;
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Configuration"];
    NSError *error;

    _configuration =
          [self.managedObjectContext executeFetchRequest:request error:&error].lastObject;

    if (error) {
        DDLogError(@"Error fetching configuration (%@)", error.localizedDescription);
    }

    if (!_configuration) {
        _configuration =
              [NSEntityDescription insertNewObjectForEntityForName:@"Configuration"
                                            inManagedObjectContext:self.managedObjectContext];
    }

    return _configuration;
}

- (NSSet<NSURL *> *)observedRepoURLs
{
    if (_observedRepoURLs) {
        return _observedRepoURLs;
    }

    __block NSMutableArray<NSURL *> *repoURLs = [NSMutableArray array];
    [self.managedRepos
          enumerateObjectsUsingBlock:^(GMUManagedRepo *repo, NSUInteger idx, BOOL *stop) {
              if (repo.repoURL) {
                  [repoURLs addObject:repo.repoURL];
              }
          }];

    _observedRepoURLs = [NSSet setWithArray:repoURLs];

    return _observedRepoURLs;
}

- (NSArray<GMUManagedRepo *> *)managedRepos
{
    if (_managedRepos) {
        return _managedRepos;
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kManagedRepoEntityName];
    NSError *error;

    _managedRepos = [self.managedObjectContext executeFetchRequest:request error:&error];

    if (!_managedRepos) {
        NSString *desc =
              NSLocalizedString(@"Failed to fetch managed repositories.", @"Fetch failed.");
        NSDictionary *dict = @{NSLocalizedDescriptionKey : desc, NSUnderlyingErrorKey : error};
        NSError *fetchError =
              [NSError errorWithDomain:GMUFinderSyncErrorDomain code:103 userInfo:dict];
        [NSApp presentError:fetchError];
    }

    return _managedRepos;
}

#pragma mark - Primary Finder Sync protocol methods

- (void)beginObservingDirectoryAtURL:(NSURL *)url
{
    // The user is now seeing the container's contents.
    // If they see it in more than one view at a time, we're only told once.
    NSLog(@"beginObservingDirectoryAtURL:%@", url.filePathURL);

    GMURepoController *thisRepoController = [GMURepoController controllerAtURL:url];
    thisRepoController.configuration = self.configuration;
    [self.repoControllers addObject:thisRepoController];
}

- (void)endObservingDirectoryAtURL:(NSURL *)url
{
    GMURepoController *controller = [self repoControllerForURL:url.filePathURL];
    if (controller) {
        [self.repoControllers removeObject:controller];
    }

    controller = nil;
    NSLog(@"endObservingDirectoryAtURL:%@", url.filePathURL);
}

- (void)requestBadgeIdentifierForURL:(NSURL *)url
{
    NSLog(@"requestBadgeIdentifierForURL:%@", url.filePathURL);

    GMURepoController *controller = [self repoControllerForURL:url.filePathURL];

    if (!controller) {
        controller = [GMURepoController controllerAtURL:url.filePathURL];
    }

    [[FIFinderSyncController defaultController]
          setBadgeIdentifier:[controller badgeIdentifierForURL:url.filePathURL]
                      forURL:url];
}

#pragma mark - Menu and toolbar item support

- (NSString *)toolbarItemName
{
    return @"GitFinderMenu";
}

- (NSString *)toolbarItemToolTip
{
    return @"GitFinderMenu: Click the toolbar item for a menu.";
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:GMUImageNameMenuIcon];
}

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu
{
    // Produce a menu for the extension.
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:@"Example Menu Item" action:@selector(sampleAction:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Log MyNumber" action:@selector(logMyNumberAction:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Log Repos" action:@selector(logManagedReposAction:) keyEquivalent:@""];

    return menu;
}

#pragma mark - Helper Methods

- (GMURepoController *)repoControllerForURL:(NSURL *)url
{
    NSOrderedSet *componentsOfUrl = [NSOrderedSet orderedSetWithArray:url.pathComponents];
    NSURL *wantedURL;

    for (NSURL *topURL in self.observedRepoURLs) {
        NSOrderedSet *topURLcomponents = [NSOrderedSet orderedSetWithArray:topURL.pathComponents];
        if ([topURLcomponents isSubsetOfOrderedSet:componentsOfUrl]) {
            wantedURL = topURL;
        }
        else if ([topURLcomponents isEqualToOrderedSet:componentsOfUrl]) {
            wantedURL = topURL;
        }
    }

    GMURepoController *matching =
          [[self.repoControllers objectsPassingTest:^BOOL(GMURepoController *obj, BOOL *stop) {
              if ([obj isValidForURL:wantedURL]) {
                  return YES;
                  *stop = YES;
              }
              return NO;
          }] anyObject];

    if (!matching) {
        GMURepoController *newCtrl = [GMURepoController controllerAtURL:wantedURL];
        [self.repoControllers addObject:newCtrl];
        matching = newCtrl;
    }

    return matching;
}

- (IBAction)logMyNumberAction:(id)sender
{
    NSUserDefaults *sharedUserDefaults =
          [[NSUserDefaults alloc] initWithSuiteName:GMUAppGroupIdentifier];
    NSInteger myNumber = [sharedUserDefaults integerForKey:@"MyNumberKey"];

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"My Number!";

    NSString *alertText =
          [NSString stringWithFormat:@"The value of my number is %ld", (long)myNumber];
    alert.informativeText = alertText;

    [alert addButtonWithTitle:@"OK"];

    [alert runModal];
}

- (IBAction)sampleAction:(id)sender
{
    NSURL *target = [[FIFinderSyncController defaultController] targetedURL];
    NSArray *items = [[FIFinderSyncController defaultController] selectedItemURLs];

    NSLog(@"sampleAction: menu item: %@, target = %@, items = ", [sender title],
          target.filePathURL);
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"    %@", [obj filePathURL]);
    }];
}

- (IBAction)logManagedReposAction:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kManagedRepoEntityName];
    NSError *error;
    NSArray<GMUManagedRepo *> *managedRepos =
          [self.managedObjectContext executeFetchRequest:request error:&error];

    if (!managedRepos) {
        NSLog(@"Error fetching: %@", error.localizedDescription);
        NSString *desc =
              NSLocalizedString(@"Error attempting to fetch managed repos.", @"Fetch failed.");
        NSDictionary *dict = @{NSLocalizedDescriptionKey : desc, NSUnderlyingErrorKey : error};
        NSError *fetchError =
              [NSError errorWithDomain:@"FINDER_SYNC_ERROR_DOMAIN" code:103 userInfo:dict];
        [NSApp presentError:fetchError];
        return;
    }

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Managed Repos!";

    NSMutableString *alertMessage = [NSMutableString string];
    [alertMessage appendString:@"The following repositories are managed by GitMenu:\n"];

    for (GMUManagedRepo *repo in managedRepos) {
        [alertMessage appendFormat:@"%@\n", repo.repoURL];
    }

    alert.informativeText = alertMessage;

    [alert addButtonWithTitle:@"OK"];

    [alert runModal];

    NSLog(@"Managed Repos: %@", managedRepos);
}

@end
