//
//  AppDelegate.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "AppDelegate.h"
#import "JMLLoggerColors.h"

@interface AppDelegate ()

@property(weak) IBOutlet NSWindow *window;
@property(weak) IBOutlet NSTextField *myNumberField;
@property(atomic, strong, readonly) NSUserDefaults *sharedUserDefaults;

@end

@implementation AppDelegate

@synthesize sharedUserDefaults = _sharedUserDefaults;

+ (void)initialize
{
    [super initialize];
    JML_InitializeCocoaLumberjack();
    JML_InitializeXCodeConsoleColors();
}

- (NSUserDefaults *)sharedUserDefaults
{
    if (_sharedUserDefaults) {
        return _sharedUserDefaults;
    }

    _sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:GMUAppGroupIdentifier];

    return _sharedUserDefaults;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSInteger myNumber = [self.sharedUserDefaults integerForKey:@"MyNumberKey"];
    if (myNumber) {
        (self.myNumberField).integerValue = myNumber;
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (IBAction)saveButtonHit:(id)sender
{
    [self.sharedUserDefaults setInteger:(self.myNumberField).integerValue forKey:@"MyNumberKey"];
    [self.sharedUserDefaults synchronize];
}

@end
