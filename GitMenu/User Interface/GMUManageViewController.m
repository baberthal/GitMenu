//
//  GMUManageViewController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/1/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUManageViewController.h"
#import "GMUDetailViewController.h"
#import "GMUDetailWindowController.h"
#import "GMURepoTableCellView.h"
#import "GMURepoTableRowView.h"
#import "GMURevealInTerminalController.h"
#import "GMUUtilities.h"
@import GMUDataModel;
@import ObjectiveGit;

@interface GMUManageViewController () <NSOpenSavePanelDelegate>

@property(nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, readonly) NSOpenPanel *openRepoPanel;
@property(nonatomic, strong, readonly) GMURevealInTerminalController *revealInTermController;
@property(nonatomic, strong, readonly) GMUDetailWindowController *detailWindowController;

@property(readonly, copy) NSArray<GMUManagedRepo *> *fetchRepos;
- (NSURL *)gitRepositoryURLforURL:(NSURL *)url;

@end

static NSString *const GMUManageViewErrorDomain = @"GMU_MANAGE_VIEW_ERROR_DOMAIN";

enum {
    GMUBackgroundFetchError = 103,
    GMUFetchFailedError = 104,
    GMURepoAlreadyExistsError = 105,
    GMUGetCurrentBranchFailedError = 106,
};

@implementation GMUManageViewController

#pragma mark - Property Overrides

@synthesize managedObjectContext = _managedObjectContext;
@synthesize openRepoPanel = _openRepoPanel;
@synthesize revealInTermController = _revealInTermController;
@synthesize detailWindowController = _detailWindowController;

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }

    _managedObjectContext =
          [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator =
          [GMUCoreDataStackManager sharedManager].persistentStoreCoordinator;

    return _managedObjectContext;
}

- (NSOpenPanel *)openRepoPanel
{
    if (_openRepoPanel) {
        return _openRepoPanel;
    }

    _openRepoPanel = [NSOpenPanel openPanel];
    _openRepoPanel.delegate = self;
    _openRepoPanel.canChooseDirectories = YES;
    _openRepoPanel.showsHiddenFiles = YES;

    return _openRepoPanel;
}

- (GMURevealInTerminalController *)revealInTermController
{
    if (_revealInTermController) {
        return _revealInTermController;
    }

    _revealInTermController = [[GMURevealInTerminalController alloc] init];

    return _revealInTermController;
}

- (GMUDetailWindowController *)detailWindowController
{
    if (_detailWindowController) {
        return _detailWindowController;
    }

    _detailWindowController = [[GMUDetailWindowController alloc]
          initWithWindowNibName:NSStringFromClass([GMUDetailWindowController class])];

    return _detailWindowController;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSArray<GMUManagedRepo *> *)fetchRepos
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kManagedRepoEntityName];
    request.sortDescriptors =
          @[ [NSSortDescriptor sortDescriptorWithKey:@"repoName" ascending:NO] ];
    NSError *anyError;

    NSArray *fetched = [self.managedObjectContext executeFetchRequest:request error:&anyError];

    if (!fetched) {
        DDLogError(@"Error fetching: %@", anyError.localizedDescription);
        NSString *description =
              NSLocalizedString(@"Error attempting to update data.", @"Fetch failed.");
        NSDictionary *dict =
              @{NSLocalizedDescriptionKey : description, NSUnderlyingErrorKey : anyError};
        NSError *connectionError =
              [NSError errorWithDomain:GMUManageViewErrorDomain code:106 userInfo:dict];
        [NSApp presentError:connectionError];
        return nil;
    }

    return fetched;
}

#pragma mark - IBActions

- (void)addRepoButtonClicked:(id)sender
{
    DDLogVerbose(@"Adding new repo...");
    NSOpenPanel *openPanel = self.openRepoPanel;

    [openPanel beginSheetModalForWindow:(NSWindow * _Nonnull)self.view.window
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
                              NSError *error = [NSError errorWithDomain:GMUManageViewErrorDomain
                                                                   code:GMURepoAlreadyExistsError
                                                               userInfo:dict];
                              [NSApp presentError:error];
                              return;
                          }

                          [self addRepositoryWithURL:openPanel.URL];

                      }];
}

- (void)autodetectReposButtonClicked:(id)sender
{
}

- (IBAction)revealRepoInFinder:(id)sender
{
    NSIndexSet *selectedIndexes = self.repoArrayController.selectionIndexes;
    [selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        GMUManagedRepo *repo = (self.repoArrayController).arrangedObjects[idx];
        [[NSWorkspace sharedWorkspace] openURL:(NSURL * _Nonnull)repo.repoURL];
    }];
}

- (IBAction)revealRepoInTerminal:(id)sender
{
    NSIndexSet *selectedIndexes = self.repoArrayController.selectionIndexes;
    [selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        GMUManagedRepo *repo = (self.repoArrayController).arrangedObjects[idx];
        [self.revealInTermController revealDirectoryInTerminalApp:(NSURL * _Nonnull)repo.repoURL];
    }];
}

- (IBAction)showRepoDetails:(NSMenuItem *)sender
{
    NSIndexSet *selected = self.repoArrayController.selectionIndexes;
    [selected enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        GMUManagedRepo *repo = (self.repoArrayController).arrangedObjects[idx];

        (self.detailWindowController.primaryViewController).representedRepo = repo;
        [self.detailWindowController showWindow:self];
    }];
}

#pragma mark - Helper Methods

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
        NSError *connectionError = [NSError errorWithDomain:GMUManageViewErrorDomain
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
            NSError *connectionError = [NSError errorWithDomain:GMUManageViewErrorDomain
                                                           code:GMUFetchFailedError
                                                       userInfo:dict];
            [NSApp presentError:connectionError];
        }];
    }

    if (!matchingRepos.count) {
        return NO;
    }

    GMUManagedRepo *firstRepo = matchingRepos.firstObject;
    if ([firstRepo.repoURL isEqual:repoURL]) {
        return YES;
    }

    return NO;
}

- (NSURL *)gitRepositoryURLforURL:(NSURL *)url
{
    NSString *endPoint = url.lastPathComponent;

    if ([endPoint.lowercaseString hasSuffix:kGit]) {
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
    if ([repoURL.lastPathComponent.lowercaseString hasSuffix:kGit]) {
        return repoURL.lastPathComponent;
    }

    if ([repoURL.lastPathComponent.lowercaseString isEqualToString:kGit]) {
        NSUInteger idx = repoURL.pathComponents.count - 2;
        return repoURL.pathComponents[idx];
    }

    return repoURL.lastPathComponent;
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

    [self.tableView reloadData];
}

#pragma mark - NSTableViewDelegate

//- (NSView *)tableView:(NSTableView *)tableView
//   viewForTableColumn:(NSTableColumn *)tableColumn
//                  row:(NSInteger)row
//{
//    GMURepoTableCellView *result = [tableView makeViewWithIdentifier:@"RepoCell" owner:self];
//    [result setRepoValue:[[self.repoArrayController arrangedObjects] objectAtIndex:row]];
//    return result;
//}
//
- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    GMURepoTableRowView *rowView =
          [[GMURepoTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    return rowView;
}

@end
