//
//  GMUSidebarItem.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUSidebarItem.h"
#import <GMUDataModel/GMUDataModel.h>

@interface GMUSidebarItem ()

@property(nonatomic, strong) GMURepoGroup *representedGroup;

@end

@implementation GMUSidebarItem

#pragma mark - Property Synthesis

@synthesize title = _title;
@synthesize children = _children;
@synthesize childItemTitleKeypath = _childItemTitleKeypath;
@synthesize modelToItemMapTable = _mapTable;
@synthesize childItemsArrayController = _arrayController;
@synthesize groupItem = _groupItem;

#pragma mark - Initializers

- (instancetype)initWithTitle:(NSString *)title
                  isGroupItem:(BOOL)isGroupItem
           prefetchedChildren:(NSArray *)children
              andTitleKeyPath:(NSString *)titleKeyPath
{
    self = [super init];
    if (self) {
        _title = title;
        _children = children != nil ? [children mutableCopy] : [NSMutableArray array];
        _mapTable = [NSMapTable weakToStrongObjectsMapTable];
        _arrayController = [[NSArrayController alloc] init];
        _groupItem = isGroupItem;

        if (titleKeyPath != nil) {
            _childItemTitleKeypath = titleKeyPath;
            [self bindChildItemsToArrayKeypath:@keypath(self, children) ofObject:self];
        }

        [self.childItemsArrayController
              addObserver:self
               forKeyPath:@keypath(self.childItemsArrayController, arrangedObjects)
                  options:0
                  context:nil];
    }

    return self;
}

- (instancetype)initWithTitle:(NSString *)title isGroupItem:(BOOL)isGroupItem
{
    return [self initWithTitle:title
                   isGroupItem:isGroupItem
            prefetchedChildren:nil
               andTitleKeyPath:nil];
}

- (instancetype)init
{
    return [self initWithTitle:@"" isGroupItem:NO];
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [[GMUSidebarItem alloc] initWithTitle:title isGroupItem:NO];
}

+ (instancetype)itemWithRepo:(GMUManagedRepo *)repo
{
    NSString *title = repo.effectiveName;
    return [[GMUSidebarItem alloc] initWithTitle:title isGroupItem:NO];
}

+ (instancetype)groupItemWithTitle:(NSString *)title
{
    return [[GMUSidebarItem alloc] initWithTitle:title isGroupItem:YES];
}

+ (instancetype)groupItemWithGroup:(GMURepoGroup *)group
{
    NSString *title = group.groupName;
    GMUSidebarItem *item = [[GMUSidebarItem alloc] initWithTitle:title isGroupItem:YES];
    [item setRepresentedGroup:group];
    [item bindChildItemsToArrayKeypath:@keypath(item, representedGroup.repositories.array)
                              ofObject:item];
    return item;
}

+ (instancetype)groupItemWithTitle:(NSString *)title
                prefetchedChildren:(NSArray *)children
                        andKeyPath:(NSString *)keyPath
{
    return [[GMUSidebarItem alloc] initWithTitle:title
                                     isGroupItem:YES
                              prefetchedChildren:children
                                 andTitleKeyPath:keyPath];
}

- (void)bindChildItemsToArrayKeypath:(NSString *)keyPath ofObject:(id)object
{
    [self.childItemsArrayController bind:@keypath(self.childItemsArrayController, content)
                                toObject:object
                             withKeyPath:keyPath
                                 options:nil];
    self.groupItem = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@keypath(self.childItemsArrayController, arrangedObjects)]) {
        [self willChangeValueForKey:@"children"];
        NSMutableArray *watchable = [self mutableArrayValueForKey:@"children"];
        [watchable removeAllObjects];

        for (id modelItem in self.childItemsArrayController.arrangedObjects) {
            GMUSidebarItem *item = [self.modelToItemMapTable objectForKey:modelItem];

            if (!item) {
                item = [GMUSidebarItem
                      itemWithTitle:[modelItem valueForKey:self.childItemTitleKeypath]];
                [self.modelToItemMapTable setObject:item forKey:modelItem];
            }

            [watchable addObject:item];
        }

        [self didChangeValueForKey:@keypath(self, children)];
    }
}

@end
