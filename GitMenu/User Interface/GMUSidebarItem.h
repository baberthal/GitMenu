//
//  GMUSidebarItem.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMUManagedRepo, GMURepoGroup;

@interface GMUSidebarItem : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSArrayController *childItemsArrayController;
@property(nonatomic, strong) NSString *childItemTitleKeypath;
@property(nonatomic, strong) NSMutableArray *children;
@property(nonatomic, strong) NSMapTable *modelToItemMapTable;
@property(nonatomic, assign, getter=isGroupItem) BOOL groupItem;

- (void)bindChildItemsToArrayKeypath:(NSString *)keyPath ofObject:(id)object;

+ (instancetype)itemWithTitle:(NSString *)title;

+ (instancetype)groupItemWithTitle:(NSString *)title
                prefetchedChildren:(NSArray *)children
                        andKeyPath:(NSString *)keyPath;

+ (instancetype)groupItemWithGroup:(GMURepoGroup *)group;

+ (instancetype)groupItemWithTitle:(NSString *)title;

+ (instancetype)itemWithRepo:(GMUManagedRepo *)repo;

- (instancetype)initWithTitle:(NSString *)title isGroupItem:(BOOL)groupItem;

- (instancetype)initWithTitle:(NSString *)title
                  isGroupItem:(BOOL)isGroupItem
           prefetchedChildren:(NSArray *)children
              andTitleKeyPath:(NSString *)titleKeyPath NS_DESIGNATED_INITIALIZER;

- (instancetype)init;

@end
