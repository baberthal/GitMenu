//
//  GMURepoController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMURepoController.h"
#import <GMUDataModel/GMUDataModel.h>
#import <ObjectiveGit/ObjectiveGit.h>

@implementation GMURepoController

@synthesize repository = _repository;
@synthesize rootURL = _rootURL;

- (instancetype)initWithRepository:(GTRepository *)repository
{
    self = [super init];
    if (self) {
        _repository = repository;
        _rootURL = [repository gitDirectoryURL];
    }

    return self;
}

- (instancetype)initWithManagedRepo:(GMUManagedRepo *)managedRepo
{
    NSURL *repoURL = managedRepo.repoURL;
    return [self initWithURL:repoURL];
}

- (instancetype)initWithURL:(NSURL *)url
{
    NSError *error;
    GTRepository *repo = [GTRepository repositoryWithURL:url error:&error];
    if (error) {
        NSLog(@"Error creating repo: %@", error.localizedDescription);
        return nil;
    }

    return [self initWithRepository:repo];
}

+ (instancetype)controllerAtURL:(NSURL *)url
{
    return [[self alloc] initWithURL:url];
}

+ (instancetype)controllerWithRepository:(GTRepository *)repository
{
    return [[self alloc] initWithRepository:repository];
}

+ (instancetype)controllerWithManagedRepo:(GMUManagedRepo *)managedRepo
{
    return [[self alloc] initWithManagedRepo:managedRepo];
}

@end
