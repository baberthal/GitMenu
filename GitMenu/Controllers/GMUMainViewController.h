//
//  GMUMainViewController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUSidebarController.h"
#import <Cocoa/Cocoa.h>

@class GMUMainWindowController;

@interface GMUMainViewController : NSViewController <GMUSidebarControllerDelegate>

@property(strong) IBOutlet GMUMainWindowController *mainWindowController;
@property(strong) IBOutlet GMUSidebarController *sidebarController;

@end
