//
//  GMUConstants.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#ifndef GMUConstants_h
#define GMUConstants_h

@import Foundation;

#pragma mark - Identifiers

extern NSString *const GMUAppGroupIdentifier;
extern NSString *const GMUMainStoreFilename;
extern NSString *const kGMUBundleID;

#pragma mark - Entity Names

extern NSString *const kManagedRepoEntityName;
extern NSString *const kRepoGroupEntityName;

#pragma mark - Image Names
extern NSString *const GMUImageNameMenuIcon;
extern NSString *const GMUImageNameMenuIconAlt;

#pragma mark - Other Constants

extern NSString *const kGit;

#pragma mark - Git Statuses

typedef NS_ENUM(NSInteger, GMUGitRepositoryStatus) {
    GMUGitRepositoryStatusNew,
    GMUGitRepositoryStatusDirty,
    GMUGitRepositoryStatusClean,
    GMUGitRepositoryStatusRenamed,
    GMUGitRepositoryStatusIgnored,
    GMUGitRepositoryStatusConflicted
};

#endif /* GMUConstants_h */
