//
//  GMUSidebarController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMUSidebarController : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property(weak) IBOutlet NSOutlineView *sidebar;

@end
