//
//  GMUManageViewController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/1/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

@class GMUManagedRepo;

@interface GMUManageViewController : NSViewController <NSTableViewDelegate>

@property(weak) IBOutlet NSTableView *tableView;
@property(weak) IBOutlet NSButton *addRepoButton;
@property(weak) IBOutlet NSButton *autodetectButton;
@property(weak) IBOutlet NSMenu *repoRightClickMenu;
@property(strong) IBOutlet NSArrayController *repoArrayController;

- (IBAction)addRepoButtonClicked:(id)sender;
- (IBAction)autodetectReposButtonClicked:(id)sender;

@end
