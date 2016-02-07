//
//  GMURevealInTerminalController.m
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/2/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import "GMURevealInTerminalController.h"
@import Carbon;

@interface GMURevealInTerminalController ()

@property(readonly) GMUPreferredTerminalApp determinePreferredTerminal;
@property(atomic, readonly) NSURL *urlForScript;

@end

static NSString *const GMURevealInTermErrorDomain = @"REVEAL_IN_TERMINAL_ERROR_DOMAIN";

@implementation GMURevealInTerminalController

#pragma mark - Initializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _preferredTerminalApp = [self determinePreferredTerminal];
    }

    return self;
}

- (GMUPreferredTerminalApp)determinePreferredTerminal
{
    NSFileManager *fm = [NSFileManager defaultManager];
    GMUPreferredTerminalApp returnValue = GMUPreferredTerminalAppTerminal;

    if ([fm fileExistsAtPath:@"/Applications/iTerm.app"]) {
        returnValue = GMUPreferredTerminalAppiTerm;
    }

    if ([fm fileExistsAtPath:@"/Applications/iTerm2.app"]) {
        returnValue = GMUPreferredTerminalAppiTerm2;
    }

    return returnValue;
}

#pragma mark - Property Overrides

@synthesize preferredTerminalApp = _preferredTerminalApp;

- (NSURL *)urlForScript
{
    NSURL *url;
    switch (self.preferredTerminalApp) {
    case GMUPreferredTerminalAppTerminal:
        url = [[NSBundle mainBundle] URLForResource:@"OpenInTerminal" withExtension:@"scpt"];
        break;

    case GMUPreferredTerminalAppiTerm:
    case GMUPreferredTerminalAppiTerm2:
        url = [[NSBundle mainBundle] URLForResource:@"OpenIniTerm" withExtension:@"scpt"];

        break;
    }

    return url;
}

- (NSAppleScript *)revealInTerminalScriptWithErrors:
      (NSDictionary<NSString *, id> *_Nullable __autoreleasing *)errorInfo
{
    NSURL *url = self.urlForScript;

    NSAppleScript *scpt = [[NSAppleScript alloc] initWithContentsOfURL:url error:errorInfo];

    if (!scpt) {
        return nil;
    }

    return scpt;
}

#pragma mark - Methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullable-to-nonnull-conversion"

- (void)revealDirectoryInTerminalApp:(NSURL *)directory
{
    NSDictionary *asErrors = @{};
    NSAppleScript *appleScript = [self revealInTerminalScriptWithErrors:&asErrors];

    if (!appleScript) {
        NSString *desc =
              NSLocalizedString(asErrors[NSAppleScriptErrorBriefMessage], @"Apple Script Error.");
        NSString *message =
              NSLocalizedString(asErrors[NSAppleScriptErrorMessage], @"Error Message.");

        NSDictionary *dict =
              @{NSLocalizedDescriptionKey : desc, NSLocalizedFailureReasonErrorKey : message};
        NSError *appleScptError =
              [NSError errorWithDomain:GMURevealInTermErrorDomain code:103 userInfo:dict];

        [NSApp presentError:appleScptError];
        return;
    }

    NSAppleEventDescriptor *firstParam =
          [NSAppleEventDescriptor descriptorWithString:(NSString * _Nonnull)directory.path];

    NSAppleEventDescriptor *params = [NSAppleEventDescriptor listDescriptor];
    [params insertDescriptor:firstParam atIndex:1];

    ProcessSerialNumber psn = {0, kCurrentProcess};
    NSAppleEventDescriptor *target =
          [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
                                                         bytes:&psn
                                                        length:sizeof(ProcessSerialNumber)];

    // Create an NSAppleEventDescriptor with the script's method name to call
    NSAppleEventDescriptor *handler =
          [NSAppleEventDescriptor descriptorWithString:(@"reveal").lowercaseString];

    // Create the event for the AppleScript subroutine, set method name and list of parameters
    NSAppleEventDescriptor *event =
          [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                   eventID:kASSubroutineEvent
                                          targetDescriptor:target
                                                  returnID:kAutoGenerateReturnID
                                             transactionID:kAnyTransactionID];

    [event setParamDescriptor:handler forKeyword:keyASSubroutineName];
    [event setParamDescriptor:params forKeyword:keyDirectObject];

    if (![appleScript executeAppleEvent:event error:&asErrors]) {
        NSString *desc = (NSString * _Nonnull)NSLocalizedString(
              asErrors[NSAppleScriptErrorBriefMessage], @"AS Error.");
        NSString *msg = (NSString * _Nonnull)NSLocalizedString(asErrors[NSAppleScriptErrorMessage],
                                                               @"Error Message.");
        NSDictionary *dict =
              @{NSLocalizedDescriptionKey : desc, NSLocalizedFailureReasonErrorKey : msg};
        NSError *asErr =
              [NSError errorWithDomain:GMURevealInTermErrorDomain code:104 userInfo:dict];
        [NSApp presentError:asErr];
        return;
    }
}

#pragma clang diagnostic pop

@end
