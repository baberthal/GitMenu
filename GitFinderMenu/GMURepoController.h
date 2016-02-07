//
//  GMURepoController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTRepository, GMUManagedRepo, GMUConfiguration;

@interface GMURepoController : NSObject

@property(strong) NSURL *rootURL;
@property(strong) GTRepository *repository;
@property(weak) GMUConfiguration *configuration;

- (instancetype)init NS_UNAVAILABLE;

/// Returns a repository controller at the given URL.
- (instancetype)initWithURL:(NSURL *)url;

/// Returns a repository controller for the given repository.
- (instancetype)initWithManagedRepo:(GMUManagedRepo *)managedRepo;

/// Returns a repository controller for the given repository.
- (instancetype)initWithRepository:(GTRepository *)repository NS_DESIGNATED_INITIALIZER;

/// Returns a repository controller at the given URL.
+ (instancetype)controllerAtURL:(NSURL *)url;

/// Returns a repository controller for the given repository.
+ (instancetype)controllerWithRepository:(GTRepository *)repository;

/// Returns a repository controller for the given repository.
+ (instancetype)controllerWithManagedRepo:(GMUManagedRepo *)managedRepo;

/**
 *  Returns whether or not the controller is equal to another, in terms of the repository it
 * controls
 *
 *  @param otherController the controller to compare
 *
 *  @return YES if they are equal, NO otherwise
 */
- (BOOL)isEqualToRepoController:(GMURepoController *)otherController;

/**
 *  Returns whether or not a controller is valid for a given URL
 *
 *  @param url the url to query
 *
 *  @return YES if it is valid, NO otherwise
 */
- (BOOL)isValidForURL:(NSURL *)url;

- (NSString *)badgeIdentifierForURL:(NSURL *)url;

@end

extern NSString *const GMUBadgeID_New;
extern NSString *const GMUBadgeID_Dirty;
extern NSString *const GMUBadgeID_Clean;
extern NSString *const GMUBadgeID_Renamed;
extern NSString *const GMUBadgeID_Ignored;
extern NSString *const GMUBadgeID_Conflicted;