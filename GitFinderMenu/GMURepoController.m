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

NSString *const GMUBadgeID_New = @"New";
NSString *const GMUBadgeID_Dirty = @"Dirty";
NSString *const GMUBadgeID_Clean = @"Clean";
NSString *const GMUBadgeID_Renamed = @"Renamed";
NSString *const GMUBadgeID_Ignored = @"Ignored";
NSString *const GMUBadgeID_Conflicted = @"Conflicted";

@implementation GMURepoController

#pragma mark - Properties and Initializers

@synthesize repository = _repository;
@synthesize rootURL = _rootURL;

- (instancetype)initWithRepository:(GTRepository *)repository
{
    self = [super init];
    if (self) {
        _repository = repository;
        _rootURL = repository.gitDirectoryURL;
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
    NSLog(@"Initializing with URL %@", url);
    NSError *error;
    NSURL *repoURL;
    if ([url.lastPathComponent isEqualToString:kGit]) {
        repoURL = url;
    }
    else if ([url.lastPathComponent hasSuffix:kGit]) {
        repoURL = url;
    }
    else if ([[NSFileManager defaultManager]
                   fileExistsAtPath:[url URLByAppendingPathComponent:kGit].path]) {
        repoURL = url;
    }

    NSLog(@"Repo URL: %@", repoURL);
    NSLog(@"File System Representation: %s", repoURL.path.fileSystemRepresentation);

    NSString *path = repoURL.path;
    NSLog(@"Is readable?  %@", @([[NSFileManager defaultManager] isReadableFileAtPath:path]));

    GTRepository *repo =
          [[GTRepository alloc] initWithURL:[NSURL fileURLWithPath:path] error:&error];
    if (error) {
        NSLog(@"Error creating repo: %@", error.localizedDescription);
        return nil;
    }

    return [self initWithRepository:repo];
}

#pragma mark - Factory Methods

+ (instancetype)controllerAtURL:(NSURL *)url
{
    DDLogFunction();
    return [[self alloc] initWithURL:url];
}

+ (instancetype)controllerWithRepository:(GTRepository *)repository
{
    DDLogFunction();
    return [[self alloc] initWithRepository:repository];
}

+ (instancetype)controllerWithManagedRepo:(GMUManagedRepo *)managedRepo
{
    DDLogFunction();
    return [[self alloc] initWithManagedRepo:managedRepo];
}

#pragma mark - Methods for FinderSync

- (NSString *)badgeIdentifierForURL:(NSURL *)url
{
    DDLogFunction();
    if ((self.repository).workingDirectoryClean) {
        return GMUBadgeID_Clean;
    }

    BOOL success;
    NSError *error;
    GTFileStatusFlags flags =
          [self.repository statusForFile:url.path success:&success error:&error];

    if (!success) {
        [NSApp presentError:error];
        return @"";
    }

    BOOL inIndex = self.configuration.statusRelativeToIndex.boolValue;
    BOOL inWorktree = self.configuration.statusRelativeToWorktree.boolValue;

    return [self badgeIdentifierForGTFileStatusFlags:flags inIndex:inIndex andWorktree:inWorktree];
}

- (NSString *)badgeIdentifierForGTFileStatusFlags:(GTFileStatusFlags)flags
                                          inIndex:(BOOL)index
                                      andWorktree:(BOOL)worktree
{
    DDLogFunction();
    if (flags & GTFileStatusCurrent) {
        return GMUBadgeID_Clean;
    }

    if (flags & GTFileStatusIgnored) {
        return GMUBadgeID_Ignored;
    }

    if (index && !worktree) {
        return [self _badgeIDRelativeToIndexForFlags:flags];
    }

    if (!index && worktree) {
        return [self _badgeIDRelativeToWorktreeForFlags:flags];
    }

    return [self _badgeIDRelativeToEitherForFlags:flags];
}

- (NSString *)_badgeIDRelativeToEitherForFlags:(GTFileStatusFlags)flags
{
    if (flags & GTFileStatusNewInIndex || flags & GTFileStatusNewInWorktree) {
        return GMUBadgeID_New;
    }

    if (flags & GTFileStatusModifiedInIndex || flags & GTFileStatusModifiedInWorktree) {
        return GMUBadgeID_Dirty;
    }

    if (flags & GTFileStatusRenamedInIndex || flags & GTFileStatusRenamedInWorktree) {
        return GMUBadgeID_Renamed;
    }

    if (flags & GTFileStatusTypeChangedInIndex || flags & GTFileStatusTypeChangedInWorktree) {
        return GMUBadgeID_Renamed;
    }

    return @"";
}

- (NSString *)_badgeIDRelativeToIndexForFlags:(GTFileStatusFlags)flags
{
    if (flags & GTFileStatusNewInIndex) {
        return GMUBadgeID_New;
    }

    if (flags & GTFileStatusModifiedInIndex) {
        return GMUBadgeID_Dirty;
    }

    if (flags & GTFileStatusRenamedInIndex) {
        return GMUBadgeID_Renamed;
    }

    if (flags & GTFileStatusTypeChangedInIndex) {
        return GMUBadgeID_Renamed;
    }

    return @"";
}

- (NSString *)_badgeIDRelativeToWorktreeForFlags:(GTFileStatusFlags)flags
{
    if (flags & GTFileStatusNewInWorktree) {
        return GMUBadgeID_New;
    }

    if (flags & GTFileStatusModifiedInWorktree) {
        return GMUBadgeID_Dirty;
    }

    if (flags & GTFileStatusTypeChangedInWorktree || flags & GTFileStatusRenamedInWorktree) {
        return GMUBadgeID_Renamed;
    }

    return @"";
}

#pragma mark - Equality

- (BOOL)isEqualToRepoController:(GMURepoController *)otherController
{
    if ([self.rootURL isEqual:otherController.rootURL]) {
        return YES;
    }

    return NO;
}

- (BOOL)isValidForURL:(NSURL *)url
{
    return [self.rootURL isEqual:url];
}

#pragma mark - NSObject Overrides

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[GMURepoController class]]) {
        return NO;
    }

    return [self isEqualToRepoController:object];
}

- (NSUInteger)hash
{
    return (self.rootURL).hash;
}

@end
