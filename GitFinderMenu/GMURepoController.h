//
//  GMURepoController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTRepository, GMUManagedRepo;

@interface GMURepoController : NSObject

@property(strong) NSURL *rootURL;
@property(strong) GTRepository *repository;

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

@end
