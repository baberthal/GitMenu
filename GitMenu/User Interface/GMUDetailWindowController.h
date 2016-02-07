//
//  GMUDetailWindowController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

@class GMUItem;

@protocol GMUWindowController <NSObject, NSToolbarDelegate, NSOutlineViewDelegate,
                               NSOutlineViewDataSource, NSSplitViewDelegate>
@end

@class GMUDetailViewController;

@interface GMUDetailWindowController : NSWindowController <GMUWindowController>

@property(nonatomic, strong, readonly) GMUDetailViewController *primaryViewController;
@property(atomic, strong, readonly) NSDictionary<id, NSArray *> *sidebarItems;

@property(weak) IBOutlet NSSplitView *mainContentSplitView;
@property(weak) IBOutlet NSSplitView *sidebarSplitView;

@property(weak) IBOutlet NSView *sidebarContainerView;
@property(weak) IBOutlet NSOutlineView *sidebar;

@property(weak) IBOutlet NSView *sidebarCommitContainerView;

@property(weak) IBOutlet NSView *mainContentView;

@end
