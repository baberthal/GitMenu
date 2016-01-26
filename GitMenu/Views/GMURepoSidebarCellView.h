//
//  GMURepoSidebarCellView.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class GMUManagedRepo;

@interface GMURepoSidebarCellView : NSTableCellView

@property(nonatomic, strong) GMUManagedRepo *repoValue;
@property(nonatomic, strong, readonly) NSImage *imageForRepo;

@end
