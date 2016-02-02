//
//  GMUMainWindowController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMURepoDetailViewController.h"
#import <Cocoa/Cocoa.h>

@interface GMUMainWindowController
      : NSWindowController <NSSplitViewDelegate, NSWindowDelegate, NSOpenSavePanelDelegate,
                            GMURepoDetailViewControllerDelegate>

- (IBAction)addNewRepository:(id)sender;

- (NSURL *)gitRepositoryURLforURL:(NSURL *)url;

@end
