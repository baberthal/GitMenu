//
//  GMUManagedRepo.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUManagedRepo.h"
#import "EXTKeyPathCoding.h"
#import "GMUConstants.h"
#import "GMURepoGroup.h"
#import <ObjectiveGit/ObjectiveGit.h>

@implementation GMUManagedRepo

@synthesize underlyingRepo = _underlyingRepo;

- (NSString *)effectiveName
{
    [self willAccessValueForKey:@keypath(self, repoName)];
    NSString *effectiveName = [self primitiveValueForKey:@keypath(self, repoName)];
    [self didAccessValueForKey:@keypath(self, repoName)];

    if (effectiveName == nil) {
        [self willAccessValueForKey:@keypath(self, repoURL)];
        NSURL *repoURL = (NSURL *)[self primitiveValueForKey:@keypath(self, repoURL)];
        [self didAccessValueForKey:@keypath(self, repoURL)];
        if ([repoURL.lastPathComponent isEqualToString:kGit]) {
            NSUInteger idx = repoURL.pathComponents.count - 2;
            effectiveName = repoURL.pathComponents[idx];
        }
        else {
            effectiveName = repoURL.lastPathComponent;
        }

        [self setPrimitiveValue:effectiveName forKey:@keypath(self, effectiveName)];
    }

    return effectiveName;
}

- (GTRepository *)underlyingRepo
{
    if (_underlyingRepo) {
        return _underlyingRepo;
    }

    NSError *error;
    GTRepository *repo = [GTRepository repositoryWithURL:(NSURL *)self.repoURL error:&error];
    if (!repo) {
        NSLog(@"Error creating git repository at %@: %@\n%@", self.repoURL,
              error.localizedDescription, error.userInfo);
        return nil;
    }

    _underlyingRepo = repo;

    return _underlyingRepo;
}

- (NSURL *)repoGitDirectoryURL
{
    NSURL *internal = [self primitiveValueForKey:@keypath(self, repoGitDirectoryURL)];
    if (!internal) {
        if ([[self.repoURL lastPathComponent] hasSuffix:kGit] ||
            [[self.repoURL lastPathComponent] isEqualToString:kGit]) {
            internal = [self.repoURL copy];
        }
        else if ([[NSFileManager defaultManager]
                       fileExistsAtPath:[self.repoURL URLByAppendingPathComponent:kGit].path]) {
            internal = [self.repoURL URLByAppendingPathComponent:kGit];
        }

        [self setPrimitiveValue:internal forKey:@keypath(self, repoGitDirectoryURL)];
    }

    return internal;
}

- (NSString *)displayPath
{
    NSString *path = [self.repoURL path];
    NSString *home = NSHomeDirectory();

    NSString *displayPath = [path stringByReplacingOccurrencesOfString:home withString:@"~"];

    return displayPath;
}

- (NSString *)displayGitDirectoryPath
{
    NSString *path =
          [[self.repoGitDirectoryURL path] stringByReplacingOccurrencesOfString:NSHomeDirectory()
                                                                     withString:@"~"];
    return path;
}

- (NSString *)displayName
{
    return self.effectiveName;
}

- (NSOrderedSet<GMUItem *> *)children
{
    return nil;
}

- (NSNumber *)isGroupItem
{
    return @NO;
}

- (GMUItem *)parent
{
    if (self.repoGroups && self.repoGroups.count) {
        return (self.repoGroups).firstObject;
    }

    return nil;
}

@end
