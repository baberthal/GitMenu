//
//  FinderSync.m
//  GitFinderMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "FinderSync.h"

@interface FinderSync ()

@property NSURL *myFolderURL;

@end

@implementation FinderSync

- (instancetype)init
{
    self = [super init];

    NSLog(@"%s launched from %@ ; compiled at %s", __PRETTY_FUNCTION__,
          [[NSBundle mainBundle] bundlePath], __TIME__);

    // Set up the directory we are syncing.
    self.myFolderURL = [NSURL fileURLWithPath:@"/Users/Shared/MySyncExtension Documents"];
    [FIFinderSyncController defaultController].directoryURLs =
          [NSSet setWithObject:self.myFolderURL];

    // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf
    // images.
    [[FIFinderSyncController defaultController]
               setBadgeImage:[NSImage imageNamed:NSImageNameColorPanel]
                       label:@"Status One"
          forBadgeIdentifier:@"One"];
    [[FIFinderSyncController defaultController]
               setBadgeImage:[NSImage imageNamed:NSImageNameCaution]
                       label:@"Status Two"
          forBadgeIdentifier:@"Two"];

    return self;
}

#pragma mark - Primary Finder Sync protocol methods

- (void)beginObservingDirectoryAtURL:(NSURL *)url
{
    // The user is now seeing the container's contents.
    // If they see it in more than one view at a time, we're only told once.
    NSLog(@"beginObservingDirectoryAtURL:%@", url.filePathURL);
}

- (void)endObservingDirectoryAtURL:(NSURL *)url
{
    // The user is no longer seeing the container's contents.
    NSLog(@"endObservingDirectoryAtURL:%@", url.filePathURL);
}

- (void)requestBadgeIdentifierForURL:(NSURL *)url
{
    NSLog(@"requestBadgeIdentifierForURL:%@", url.filePathURL);

    // For demonstration purposes, this picks one of our two badges, or no badge at all, based on
    // the filename.
    NSInteger whichBadge = [url.filePathURL hash] % 3;
    NSString *badgeIdentifier = @[ @"", @"One", @"Two" ][whichBadge];
    [[FIFinderSyncController defaultController] setBadgeIdentifier:badgeIdentifier forURL:url];
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
    return [NSImage imageNamed:NSImageNameCaution];
}

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu
{
    // Produce a menu for the extension.
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:@"Example Menu Item" action:@selector(sampleAction:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Log MyNumber" action:@selector(logMyNumberAction:) keyEquivalent:@""];

    return menu;
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
          [target filePathURL]);
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"    %@", [obj filePathURL]);
    }];
}

@end
