//
//  GMUSidebarController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GMUSidebarControllerDelegate;

@interface GMUSidebarController : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property(weak) IBOutlet NSOutlineView *sidebar;
@property(assign) IBOutlet id<GMUSidebarControllerDelegate> delegate;

@end

@protocol GMUSidebarControllerDelegate <NSObject>

@required
- (void)sidebarController:(GMUSidebarController *)controller didChangeSelectionWithItem:(id)item;

@end