//
//  GMUMainWindowController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUMainWindowController.h"
#import "GMUMainViewController.h"
#import "GMUSidebarController.h"
#import "GMUUtilities.h"
#import <GMUDataModel/GMUDataModel.h>
#import <ObjectiveGit/ObjectiveGit.h>

enum {
    GMUBackgroundFetchError = 103,
    GMUFetchFailedError = 104,
    GMURepoAlreadyExistsError = 105,
    GMUGetCurrentBranchFailedError = 106,
};

@interface GMUMainWindowController ()

@property(weak) IBOutlet NSToolbar *toolbar;

@property(weak) IBOutlet NSButton *toolbarButtonAdd;
@property(weak) IBOutlet NSButton *toolbarButtonConfigure;
@property(weak) IBOutlet NSButton *toolbarButtonBranch;
@property(weak) IBOutlet NSButton *toolbarButtonClone;

@property(weak) IBOutlet NSToolbarItem *toolbarItemAdd;
@property(weak) IBOutlet NSToolbarItem *toolbarItemConfigure;
@property(weak) IBOutlet NSToolbarItem *toolbarItemBranch;
@property(weak) IBOutlet NSToolbarItem *toolbarItemClone;

@property(weak) IBOutlet NSSplitView *splitView;
@property(weak) IBOutlet NSView *sidebarView;
@property(weak) IBOutlet NSView *mainContentView;

@property(strong, readonly) NSOpenPanel *openPanel;
@property(strong) IBOutlet GMUSidebarController *sidebarController;
@property(strong) IBOutlet GMUMainViewController *mainViewController;

@property(strong, readonly) NSManagedObjectContext *managedObjectContext;

- (BOOL)repositoryExistsInMOCWithURL:(NSURL *)repoURL;
- (void)addRepositoryWithURL:(NSURL *)repoURL;
- (NSString *)defaultNameForRepoWithURL:(NSURL *)repoURL;

@end

static NSString *MAIN_MENU_ERROR_DOMAIN = @"GMU_MAIN_MENU_ERROR_DOMAIN";

@implementation GMUMainWindowController

#pragma mark - Property Overrides

@synthesize openPanel = _openPanel;
@synthesize managedObjectContext = _context;

- (NSOpenPanel *)openPanel
{
    if (_openPanel) {
        return _openPanel;
    }

    _openPanel = [NSOpenPanel openPanel];
    _openPanel.delegate = self;
    _openPanel.canChooseDirectories = YES;
    _openPanel.showsHiddenFiles = YES;

    return _openPanel;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_context) {
        return _context;
    }

    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.persistentStoreCoordinator =
          [[GMUCoreDataStackManager sharedManager] persistentStoreCoordinator];
    return _context;
}

#pragma mark - View Lifecycle Events

- (void)windowDidLoad
{
    [super windowDidLoad];
    DDLogFunction();
}

#pragma mark - NSSplitView Delegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if ([subview isEqual:self.sidebarView]) {
        return YES;
    }

    return NO;
}

#pragma mark - Actions

- (void)addNewRepository:(id)sender
{
    DDLogVerbose(@"Adding new repo...");
    NSOpenPanel *openPanel = self.openPanel;

    [openPanel beginSheetModalForWindow:self.window
                      completionHandler:^(NSInteger result) {
                          if (result == NSFileHandlingPanelCancelButton) {
                              return;
                          }

                          if ([self repositoryExistsInMOCWithURL:openPanel.URL]) {
                              NSString *description = NSLocalizedString(
                                    @"This repo is already managed.", @"Repo already exists.");
                              NSDictionary *dict = @{
                                  NSLocalizedDescriptionKey : description,
                                  NSURLErrorKey : openPanel.URL
                              };
                              NSError *error = [NSError errorWithDomain:MAIN_MENU_ERROR_DOMAIN
                                                                   code:GMURepoAlreadyExistsError
                                                               userInfo:dict];
                              [NSApp presentError:error];
                              return;
                          }

                          [self addRepositoryWithURL:openPanel.URL];

                      }];
}

#pragma mark - Helper / Convenience Methods

- (NSURL *)gitRepositoryURLforURL:(NSURL *)url
{
    NSString *endPoint = [url lastPathComponent];

    if ([[endPoint lowercaseString] hasSuffix:kGit]) {
        return url;
    }

    if ([endPoint isEqualToString:kGit]) {
        return url;
    }

    NSURL *possibleGitDir = [url URLByAppendingPathComponent:kGit isDirectory:YES];
    NSError *error;
    if ([possibleGitDir checkResourceIsReachableAndReturnError:&error]) {
        return possibleGitDir;
    }

    if (error) {
        [NSApp presentError:error];
    }

    DDLogDebug(@"This is not a valid path: %@", url);
    return nil;
}

- (NSString *)defaultNameForRepoWithURL:(NSURL *)repoURL
{
    if ([[[repoURL lastPathComponent] lowercaseString] hasSuffix:kGit]) {
        return [repoURL lastPathComponent];
    }

    if ([[[repoURL lastPathComponent] lowercaseString] isEqualToString:kGit]) {
        NSUInteger idx = [[repoURL pathComponents] count] - 2;
        return [[repoURL pathComponents] objectAtIndex:idx];
    }

    return [repoURL lastPathComponent];
}

- (void)addRepositoryWithURL:(NSURL *)repoURL
{
    GMUManagedRepo *newRepo =
          [NSEntityDescription insertNewObjectForEntityForName:kManagedRepoEntityName
                                        inManagedObjectContext:self.managedObjectContext];
    newRepo.repoURL = repoURL;
    newRepo.repoName = [self defaultNameForRepoWithURL:repoURL];

    NSError *error;

    if (![self.managedObjectContext save:&error]) {
        DDLogError(@"Error saving managed object context: %@\n%@", error.localizedDescription,
                   error.userInfo);
        [NSApp presentError:error];
    }
}

- (BOOL)repositoryExistsInMOCWithURL:(NSURL *)repoURL
{
    NSError *anyError;
    NSManagedObjectContext *taskContext = GMU_privateQueueContext(&anyError);
    if (!taskContext) {
        DDLogError(@"Error creating background fetch context: %@\n%@",
                   anyError.localizedDescription, anyError.userInfo);
        NSString *description = NSLocalizedString(@"Could not configure application.",
                                                  @"Failed to create background fetch context.");
        NSDictionary *dict =
              @{NSLocalizedDescriptionKey : description, NSUnderlyingErrorKey : anyError};
        NSError *connectionError = [NSError errorWithDomain:MAIN_MENU_ERROR_DOMAIN
                                                       code:GMUBackgroundFetchError
                                                   userInfo:dict];
        [NSApp presentError:connectionError];
    }

    NSFetchRequest *existingRepoFetchRequest =
          [NSFetchRequest fetchRequestWithEntityName:kManagedRepoEntityName];
    existingRepoFetchRequest.predicate =
          [NSPredicate predicateWithFormat:@"repoURL == %@", repoURL];
    NSArray *matchingRepos =
          [self.managedObjectContext executeFetchRequest:existingRepoFetchRequest error:&anyError];

    if (!matchingRepos) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            DDLogError(@"Error fetching: %@\n%@", anyError.localizedDescription, anyError.userInfo);
            NSString *description =
                  NSLocalizedString(@"Error attempting to fetch existing repos.", @"Fetch failed");
            NSDictionary *dict =
                  @{NSLocalizedDescriptionKey : description, NSUnderlyingErrorKey : anyError};
            NSError *connectionError = [NSError errorWithDomain:MAIN_MENU_ERROR_DOMAIN
                                                           code:GMUFetchFailedError
                                                       userInfo:dict];
            [NSApp presentError:connectionError];
        }];
    }

    if (!matchingRepos.count) {
        return NO;
    }

    GMUManagedRepo *firstRepo = [matchingRepos firstObject];
    if ([firstRepo.repoURL isEqual:repoURL]) {
        return YES;
    }

    return NO;
}

#pragma mark - GMURepoDetailViewControllerDelegate

- (void)detailViewControllerChangedCurrentRepo:(GMUManagedRepo *)repo
{
    GTRepository *underlyingRepo = repo.underlyingRepo;
    NSError *error;
    GTBranch *currentBranch = [underlyingRepo currentBranchWithError:&error];
    DDLogInfo(@"Current Branch: %@", currentBranch.shortName);

    if (!currentBranch) {
        NSString *desc =
              NSLocalizedString(@"Failed to get current branch.", @"Current Branch Failed.");
        NSDictionary *dict = @{NSLocalizedDescriptionKey : desc, NSUnderlyingErrorKey : error};
        NSError *repoError = [NSError errorWithDomain:MAIN_MENU_ERROR_DOMAIN
                                                 code:GMUGetCurrentBranchFailedError
                                             userInfo:dict];
        [NSApp presentError:repoError];
        return;
    }

    NSString *branchName = currentBranch.shortName;
    self.toolbarButtonBranch.title = branchName;
}

@end
