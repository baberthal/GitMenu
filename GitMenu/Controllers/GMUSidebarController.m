//
//  GMUSidebarController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUSidebarController.h"
#import "GMUCoreDataStackManager.h"
#import "GMUManagedRepo.h"
#import "GMURepoGroup.h"
#import "GMURepoSidebarCellView.h"
#import "GMUUtilities.h"

@interface GMUSidebarController ()

@property(nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, readonly) NSArray *topLevelItems;

+ (NSArray *)defaultTopLevelItems;

@end

static NSString *const GMUSidebarErrorDomain = @"SIDEBAR_ERROR_DOMAIN";

@implementation GMUSidebarController

@synthesize managedObjectContext = _context;
@synthesize topLevelItems = _topLevelItems;

#pragma mark - Class Methods

+ (NSArray *)defaultTopLevelItems
{
    static NSArray *_defaultTopLevelItems;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultTopLevelItems = @[ @"Favorites", @"Github", @"Bitbucket", @"Local Repositories" ];
    });

    return _defaultTopLevelItems;
}

#pragma mark - Convenience Methods

- (void)reloadSidebarView:(id)sender
{
    _topLevelItems = nil;
    ZAssert(self.topLevelItems, @"Error reloading top level items.");
    [self.sidebar reloadData];
}

- (NSArray *)_childrenForItem:(id)item
{
    NSArray *children;
    if (item == nil) {
        children = self.topLevelItems;
    }
    else {
        if ([item isKindOfClass:[GMURepoGroup class]]) {
            GMURepoGroup *group = (GMURepoGroup *)item;
            children = [group.repositories array];
        }
        else if ([item isKindOfClass:[NSString class]]) {
            NSArray *fetchedGroups = [self _fetchGroups:self];
            if (fetchedGroups) {
                NSPredicate *namePredicate =
                      [NSPredicate predicateWithFormat:@"groupName == %@", (NSString *)item];
                GMURepoGroup *thisGroup =
                      [[fetchedGroups filteredArrayUsingPredicate:namePredicate] firstObject];
                if (thisGroup) {
                    children = [thisGroup.repositories array];
                }
                else {
                    if ([item isEqualToString:@"Local Repositories"]) {
                        NSError *error;
                        NSFetchRequest *fetchRequest =
                              [NSFetchRequest fetchRequestWithEntityName:kManagedRepoEntityName];
                        fetchRequest.predicate =
                              [NSPredicate predicateWithFormat:@"ANY repoGroups == NULL"];
                        NSArray *fetchedRepos =
                              [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                       error:&error];
                        if (!fetchedRepos) {
                            DDLogError(@"Error fetching repositories: %@",
                                       error.localizedDescription);
                        }

                        children = fetchedRepos;
                    }
                    DDLogInfo(@"Group %@ had no repos.", thisGroup);
                }
            }
            else {
                DDLogInfo(@"Fetched Groups %@ was nil.", fetchedGroups);
            }
        }
        else {
            DDLogInfo(@"Item (%@) was neither a GMURepoGroup or NSString, was %@", item,
                      [item class]);
        }
    }

    return children;
}

- (NSArray *)_fetchGroups:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RepoGroup"];
    request.sortDescriptors =
          @[ [NSSortDescriptor sortDescriptorWithKey:@"groupName" ascending:NO] ];
    NSError *anyError;

    NSArray *fetchedGroups =
          [self.managedObjectContext executeFetchRequest:request error:&anyError];

    if (!fetchedGroups) {
        DDLogError(@"Error fetching: %@", anyError.localizedDescription);
        NSString *description =
              NSLocalizedString(@"Error attempting to update data.", @"Fetch failed.");
        NSDictionary *dict =
              @{NSLocalizedDescriptionKey : description, NSUnderlyingErrorKey : anyError};
        NSError *connectionError =
              [NSError errorWithDomain:GMUSidebarErrorDomain code:106 userInfo:dict];
        [NSApp presentError:connectionError];
        return nil;
    }

    return fetchedGroups;
}

- (NSString *)_titleForTopLevelItem:(id)item
{
    NSString *value;
    if ([item isKindOfClass:[NSString class]]) {
        value = [item uppercaseString];
    }
    else if ([item isKindOfClass:[GMURepoGroup class]]) {
        GMURepoGroup *group = (GMURepoGroup *)item;
        value = [group.groupName uppercaseString];
    }

    return value;
}

#pragma mark - Property Overrides

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

- (NSArray *)topLevelItems
{
    if (_topLevelItems) {
        return _topLevelItems;
    }

    NSMutableArray *items = [NSMutableArray array];
    [items addObjectsFromArray:[GMUSidebarController defaultTopLevelItems]];

    NSArray *fetchedGroups = [self _fetchGroups:self];
    [items addObjectsFromArray:fetchedGroups];

    _topLevelItems = items;

    return _topLevelItems;
}

#pragma mark - NSOutlineViewDataSource

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (![outlineView isEqual:self.sidebar]) {
        return nil;
    }

    return [[self _childrenForItem:item] objectAtIndex:index];
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
    return [[self _childrenForItem:item] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [self.topLevelItems containsObject:item];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    if ([self.topLevelItems containsObject:item]) {
        NSTableCellView *result = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        NSString *value = [self _titleForTopLevelItem:item];
        result.textField.stringValue = value;
        return result;
    }
    else {
        GMURepoSidebarCellView *result =
              [outlineView makeViewWithIdentifier:@"RepoCell" owner:self];
        GMUManagedRepo *repo = (GMUManagedRepo *)item;
        [result setRepoValue:repo];
        return result;
    }
}

@end
