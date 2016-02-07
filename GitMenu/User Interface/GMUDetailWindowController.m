//
//  GMUDetailWindowController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUDetailWindowController.h"
#import "GMUDetailViewController.h"
#import "GMURepoTableRowView.h"
#import "GMUSidebarTableCellView.h"
#import "GMUUtilities.h"
@import GMUDataModel;

@interface GMUDetailWindowController ()

@property(nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, strong, readonly) NSArray<GMURepoGroup *> *fetchedRepoGroups;
@property(nonatomic, strong, readonly) NSArray<GMUManagedRepo *> *fetchedFavorites;
@property(nonatomic, strong, readonly) NSArray<GMUManagedRepo *> *fetchedOtherRepos;
@property(nonatomic, strong, readonly) NSArray<id> *topLevelSidebarItems;

@end

static NSString *const GMUDetailViewErrorDomain = @"GMU_DETAIL_VIEW_ERROR_DOMAIN";

@implementation GMUDetailWindowController

#pragma mark - Property Overrides

@synthesize primaryViewController = _primaryViewController;

@synthesize sidebarItems = _sidebarItems;
@synthesize topLevelSidebarItems = _topLevelItems;
@synthesize managedObjectContext = _context;
@synthesize fetchedFavorites = _fetchedFavorites;
@synthesize fetchedRepoGroups = _fetchedRepoGroups;
@synthesize fetchedOtherRepos = _fetchedOtherRepos;

- (GMUDetailViewController *)primaryViewController
{
    if (_primaryViewController) {
        return _primaryViewController;
    }

    _primaryViewController = [[GMUDetailViewController alloc]
          initWithNibName:NSStringFromClass([GMUDetailViewController class])
                   bundle:nil];

    return _primaryViewController;
}

- (NSDictionary<id, NSArray *> *)sidebarItems
{
    if (_sidebarItems) {
        return _sidebarItems;
    }

    NSMutableDictionary<id, NSArray<GMUItem *> *> *items = [NSMutableDictionary dictionary];

    for (id item in self.topLevelSidebarItems) {
        if (![item isKindOfClass:[NSString class]]) {
            [items setObject:[[(GMUItem *)item children] array] forKey:item];
            continue;
        }

        if ([[item uppercaseString] isEqualToString:[@"FAVORITES" uppercaseString]]) {
            [items setObject:self.fetchedFavorites forKey:item];
            continue;
        }

        else if ([[item uppercaseString] isEqualToString:[@"OTHER" uppercaseString]]) {
            [items setObject:self.fetchedOtherRepos forKey:item];
            continue;
        }
    }

    _sidebarItems = items;

    return _sidebarItems;
}

- (NSArray<id> *)topLevelSidebarItems
{
    if (_topLevelItems) {
        return _topLevelItems;
    }

    NSMutableArray *items = [NSMutableArray arrayWithObject:@"FAVORITES"];
    [items addObjectsFromArray:self.fetchedRepoGroups];
    [items addObject:@"OTHER"];

    _topLevelItems = items;

    return _topLevelItems;
}

//- (NSMutableArray<GMUSidebarItem *> *)setupSidebarItems
//{
//    NSMutableArray<GMUSidebarItem *> *items = [NSMutableArray array];
//
//    GMUSidebarItem *favorites = [GMUSidebarItem groupItemWithTitle:@"FAVORITES"];
//    [favorites bindChildItemsToArrayKeypath:@keypath(self, fetchedFavorites) ofObject:self];
//    [items addObject:favorites];
//
//    for (GMURepoGroup *group in self.fetchedRepoGroups) {
//        GMUSidebarItem *item = [GMUSidebarItem groupItemWithGroup:group];
//        [items addObject:item];
//    }
//
//    /// TODO: Add Github / BitBucket Support
//    for (GMUManagedRepo *repo in self.fetchedOtherRepos) {
//        GMUSidebarItem *item = [GMUSidebarItem itemWithRepo:repo];
//        [items addObject:item];
//    }
//
//    return items;
//}
//
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

#pragma mark - Window Lifecycle

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.mainContentView addSubview:(self.primaryViewController).view];
}

#pragma mark - CoreData Fetching

- (NSArray<GMUManagedRepo *> *)fetchedFavorites
{
    if (_fetchedFavorites) {
        return _fetchedFavorites;
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kManagedRepoEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY isFavorite == YES"];
    NSError *anyError;

    _fetchedFavorites = [self.managedObjectContext executeFetchRequest:request error:&anyError];

    if (!_fetchedFavorites) {
        [GMUErrorFactory presentCoreDataError:anyError
                                  description:@"Error attempting to fetch favorites."
                                          key:@"Fetch failed."
                                       domain:GMUDetailViewErrorDomain
                                      andCode:106];
        return nil;
    }

    return _fetchedFavorites;
}

- (NSArray<GMUManagedRepo *> *)fetchedOtherRepos
{
    if (_fetchedOtherRepos) {
        return _fetchedOtherRepos;
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kManagedRepoEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY repoGroups == NULL"];

    NSError *error;

    NSArray *fetched = [self.managedObjectContext executeFetchRequest:request error:&error];

    if (!fetched) {
        [GMUErrorFactory presentCoreDataError:error
                                  description:@"Error fetching repos."
                                          key:@"Fetch failed."
                                       domain:GMUDetailViewErrorDomain
                                      andCode:108];
        return nil;
    }

    _fetchedOtherRepos = fetched;
    return _fetchedOtherRepos;
}

- (NSArray<GMURepoGroup *> *)fetchedRepoGroups
{
    if (_fetchedRepoGroups) {
        return _fetchedRepoGroups;
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kRepoGroupEntityName];
    request.sortDescriptors =
          @[ [NSSortDescriptor sortDescriptorWithKey:@"groupName" ascending:NO] ];
    NSError *fetchError;

    NSArray *fetched = [self.managedObjectContext executeFetchRequest:request error:&fetchError];

    if (!fetched) {
        [GMUErrorFactory presentCoreDataError:fetchError
                                  description:@"Error Fetching Groups"
                                          key:@"Fetch failed."
                                       domain:GMUDetailViewErrorDomain
                                      andCode:110];
        return nil;
    }

    _fetchedRepoGroups = fetched;
    return _fetchedRepoGroups;
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if ([splitView isEqual:self.mainContentSplitView]) {
        return [subview isEqual:self.sidebarContainerView];
    }

    else if ([splitView isEqual:self.sidebarSplitView]) {
        return [subview isEqual:self.sidebarCommitContainerView];
    }

    return NO;
}

#pragma mark - NSOutlineViewDataSource

/**
 *  A helper method to get the children of a given sidebar item
 *
 *  @param item The sidebar item whose children we want
 *
 *  @return The children of the item
 */
- (NSArray *)_childrenForSidebarItem:(id)item
{
    NSArray *children;
    if (item == nil) {
        children = self.topLevelSidebarItems;
    }
    else if ([item isKindOfClass:[GMUItem class]]) {
        children = [[(GMUItem *)item children] array];
    }
    else {
        children = [self.sidebarItems objectForKey:item];
    }

    return children;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [[self _childrenForSidebarItem:item] objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([outlineView parentForItem:item] == nil) {
        return YES;
    }

    return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self _childrenForSidebarItem:item] count];
}

#pragma mark - NSOutlineViewDelegate

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [self.topLevelSidebarItems containsObject:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
    if ([[item uppercaseString] isEqualToString:@"FAVORITES"]) {
        return NO;
    }

    return YES;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    if ([self.topLevelSidebarItems containsObject:item]) {
        NSTableCellView *result = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        if ([item isKindOfClass:[GMUItem class]]) {
            result.textField.stringValue = [[(GMUItem *)item displayName] uppercaseString];
        }
        else {
            result.textField.stringValue = [item uppercaseString];
        }

        return result;
    }

    GMUSidebarTableCellView *result = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    result.textField.stringValue = [(GMUItem *)item displayName];
    return result;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return ![self.topLevelSidebarItems containsObject:item];
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item
{
    GMURepoTableRowView *rowView =
          [[GMURepoTableRowView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
    //    [rowView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    [rowView setSelectionFillCornerRadius:1.f];
    return rowView;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if ([self.sidebar selectedRow] != -1) {
        GMUManagedRepo *repo = [self.sidebar itemAtRow:(self.sidebar).selectedRow];
        if (repo) {
            [self.primaryViewController setRepresentedRepo:repo];
        }
    }
}

@end
