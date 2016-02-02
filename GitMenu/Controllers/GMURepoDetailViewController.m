//
//  GMURepoDetailViewController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMURepoDetailViewController.h"
#import "GMUCommitTableCellView.h"
#import <ObjectiveGit/ObjectiveGit.h>
@import GMUDataModel;

@interface GMURepoDetailViewController ()

@property(readonly) GTReference *currentRepoHEAD;

@end

static NSString *REPO_DETAIL_ERROR_DOMAIN = @"REPO_DETAIL_ERROR_DOMAIN";

@implementation GMURepoDetailViewController

- (instancetype)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        [self addObserver:self forKeyPath:@keypath(self, currentRepo) options:0 context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@keypath(self, currentRepo)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@keypath(self, currentRepo)]) {
        DDLogInfo(@"CurrentRepo is now %@", self.currentRepo);
        _commits = nil;
        if (self.delegate) {
            [self.delegate detailViewControllerChangedCurrentRepo:self.currentRepo];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Property Overrides

@synthesize delegate = _delegate;
@synthesize commits = _commits;

- (NSArray *)commits
{
    if (_commits) {
        return _commits;
    }

    if (!self.currentRepo) {
        return @[];
    }

    NSError *error;
    GTEnumerator *enumerator =
          [[GTEnumerator alloc] initWithRepository:self.currentRepo.underlyingRepo error:&error];

    if (!enumerator) {
        [NSApp presentError:error];
    }

    _commits = [enumerator allObjects];

    return _commits;
}

- (GTReference *)currentRepoHEAD
{
    if (!self.currentRepo) {
        return nil;
    }

    NSError *error;
    GTReference *head = [self.currentRepo.underlyingRepo headReferenceWithError:&error];

    if (!head) {
        NSString *desc = NSLocalizedString(@"Error retrieving HEAD for repo", @"Failed ref - HEAD");
        NSDictionary *dict = @{NSLocalizedDescriptionKey : desc, NSUnderlyingErrorKey : error};
        NSError *headError =
              [NSError errorWithDomain:REPO_DETAIL_ERROR_DOMAIN code:102 userInfo:dict];
        [NSApp presentError:headError];
    }

    return head;
}

#pragma mark - View Lifecycle Events

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

#pragma mark - NSTableViewDelegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 52.0;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    GMUCommitTableCellView *result = [tableView makeViewWithIdentifier:@"CommitCell" owner:self];
    [result setRepresentedCommit:[self.commits objectAtIndex:row]];
    return result;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.commits.count;
}

- (id)tableView:(NSTableView *)tableView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
                            row:(NSInteger)row
{
    return [self.commits objectAtIndex:row];
}

@end
