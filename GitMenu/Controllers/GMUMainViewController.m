//
//  GMUMainViewController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUMainViewController.h"
#import "GMUMainWindowController.h"
#import "GMURepoDetailViewController.h"

@interface GMUMainViewController ()

@end

static NSString *MAIN_VIEW_ERROR_DOMAIN = @"MAIN_VIEW_ERROR_DOMAIN";

enum {
    GMUMainViewRepoCreateFailedError = 102,
};

@implementation GMUMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (void)sidebarController:(GMUSidebarController *)controller didChangeSelectionWithItem:(id)item
{
    if (![controller isEqual:self.sidebarController]) {
        return;
    }

    GMUManagedRepo *repo = (GMUManagedRepo *)item;
    if (!repo) {
        NSString *desc =
              NSLocalizedString(@"Failed to cast item to GMUManagedRepo.", @"Repo Create Failed.");
        NSDictionary *dict = @{NSLocalizedDescriptionKey : desc};
        NSError *error = [NSError errorWithDomain:MAIN_VIEW_ERROR_DOMAIN
                                             code:GMUMainViewRepoCreateFailedError
                                         userInfo:dict];
        [NSApp presentError:error];
        return;
    }

    GMURepoDetailViewController *detailVC = [[GMURepoDetailViewController alloc] init];
    [detailVC setCurrentRepo:repo];
    [detailVC setDelegate:self.mainWindowController];
    [self addChildViewController:detailVC];
    [self.view addSubview:detailVC.view];
}

@end
