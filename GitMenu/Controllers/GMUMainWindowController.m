//
//  GMUMainWindowController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUMainWindowController.h"
#import "GMUCoreDataStackManager.h"
#import "GMUManagedRepo.h"
#import "GMUUtilities.h"

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

@property(strong, readonly) NSManagedObjectContext *managedObjectContext;

@end

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

@end
