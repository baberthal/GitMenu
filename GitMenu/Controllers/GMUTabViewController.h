//
//  GMUTabViewController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/1/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

@class GMUManageViewController, GMUConfigureViewController;

@interface GMUTabViewController : NSViewController

@property(weak) IBOutlet NSTabView *tabView;
@property(atomic, readonly, strong) GMUManageViewController *manageViewController;
@property(atomic, readonly, strong) GMUConfigureViewController *configureViewController;

@end
