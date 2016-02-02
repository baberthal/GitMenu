//
//  GMURepoDetailViewController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GMUManagedRepo;

@protocol GMURepoDetailViewControllerDelegate;

@interface GMURepoDetailViewController
      : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property(nonatomic) GMUManagedRepo *currentRepo;

@property(weak) IBOutlet NSView *commitView;
@property(strong, readonly) NSArray *commits;
@property(weak) IBOutlet NSTableView *commitTableView;

@property(weak) IBOutlet NSView *filesView;
@property(weak) IBOutlet NSOutlineView *filesOutlineView;

@property(assign) IBOutlet id<GMURepoDetailViewControllerDelegate> delegate;

@end

@protocol GMURepoDetailViewControllerDelegate <NSObject>

@required
- (void)detailViewControllerChangedCurrentRepo:(GMUManagedRepo *)repo;

@end
