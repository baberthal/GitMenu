//
//  GMUConfigureViewController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/1/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMUConfigureViewController.h"
#import "GMUUtilities.h"
@import GMUDataModel;

@interface GMUConfigureViewController ()

@property(nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong, readonly) IBOutlet GMUConfiguration *configuration;

@end

@implementation GMUConfigureViewController

@synthesize managedObjectContext = _context;
@synthesize configuration = _configuration;

- (NSManagedObjectContext *)managedObjectContext
{
    if (_context) {
        return _context;
    }

    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _context.persistentStoreCoordinator =
          [GMUCoreDataStackManager sharedManager].persistentStoreCoordinator;

    return _context;
}

- (GMUConfiguration *)configuration
{
    if (_configuration) {
        return _configuration;
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Configuration"];
    NSError *error;

    _configuration =
          [self.managedObjectContext executeFetchRequest:request error:&error].lastObject;

    if (error) {
        DDLogError(@"Failed to retrieve configuration. Creating one. (%@)",
                   error.localizedDescription);
    }

    if (!_configuration) {
        _configuration =
              [NSEntityDescription insertNewObjectForEntityForName:@"Configuration"
                                            inManagedObjectContext:self.managedObjectContext];
    }

    return _configuration;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
}

- (void)viewWillDisappear
{
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        [NSApp presentError:error];
    }

    [super viewWillDisappear];
}

@end
