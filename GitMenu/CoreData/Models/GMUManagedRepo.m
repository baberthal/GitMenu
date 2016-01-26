//
//  GMUManagedRepo.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/23/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUManagedRepo.h"
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
        if ([[repoURL lastPathComponent] isEqualToString:kGit]) {
            NSUInteger idx = [[repoURL pathComponents] count] - 2;
            effectiveName = [[repoURL pathComponents] objectAtIndex:idx];
        }
        else {
            effectiveName = [repoURL lastPathComponent];
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
        DDLogError(@"Error creating git repository at %@: %@\n%@", self.repoURL,
                   error.localizedDescription, error.userInfo);
        return nil;
    }

    _underlyingRepo = repo;

    return _underlyingRepo;
}

@end
