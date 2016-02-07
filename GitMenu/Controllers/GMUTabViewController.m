//
//  GMUTabViewController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/1/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUTabViewController.h"
#import "GMUConfigureViewController.h"
#import "GMUManageViewController.h"

@interface GMUTabViewController ()

@end

@implementation GMUTabViewController

@synthesize manageViewController = _manageViewController;
@synthesize configureViewController = _configureViewController;

- (void)awakeFromNib
{
    NSTabViewItem *item;
    item = [self.tabView tabViewItemAtIndex:0];
    item.view = self.manageViewController.view;

    item = [self.tabView tabViewItemAtIndex:1];
    item.view = self.configureViewController.view;
}

- (GMUManageViewController *)manageViewController
{
    if (_manageViewController) {
        return _manageViewController;
    }

    _manageViewController = [[GMUManageViewController alloc] initWithNibName:nil bundle:nil];

    return _manageViewController;
}

- (GMUConfigureViewController *)configureViewController
{
    if (_configureViewController) {
        return _configureViewController;
    }

    _configureViewController = [[GMUConfigureViewController alloc] initWithNibName:nil bundle:nil];

    return _configureViewController;
}

@end
