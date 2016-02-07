//
//  GMURepoSidebarCellView.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMURepoTableCellView.h"
@import GMUDataModel;

@implementation GMURepoTableCellView

- (NSImage *)imageForRepo
{
    NSString *imageName;

    GMUManagedRepo *repo = (GMUManagedRepo *)self.objectValue;
    switch (repo.repoType.integerValue) {
    case GMUManagedRepositoryTypeFork:
        imageName = @"gh-repo-fork";
        break;

    case GMUManagedRepositoryTypeClone:
        imageName = @"gh-repo-clone";
        break;

    case GMUManagedRepositoryTypeSource:
    case GMUManagedRepositoryTypeUnknown:
    default:
        imageName = @"gh-repo-default";
        break;
    }

    return [NSImage imageNamed:imageName];
}

@end
