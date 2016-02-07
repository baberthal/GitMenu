//
//  GMUDetailViewController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/3/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUDetailViewController.h"
@import ObjectiveGit;

@interface GMUDetailViewController ()

- (void)representedRepoDidChange;

@end

@implementation GMUDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@keypath(self, representedRepo) options:0 context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@keypath(self, representedRepo)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@keypath(self, representedRepo)]) {
        [self representedRepoDidChange];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)representedRepoDidChange
{
    [self.repoPathControl setURL:(self.representedRepo).underlyingRepo.fileURL];
}

@end
