//
//  GMURevealInTerminalController.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/2/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

typedef NS_ENUM(NSInteger, GMUPreferredTerminalApp) {
    GMUPreferredTerminalAppTerminal,
    GMUPreferredTerminalAppiTerm,
    GMUPreferredTerminalAppiTerm2
};

NS_ASSUME_NONNULL_BEGIN

@interface GMURevealInTerminalController : NSObject

@property(readonly, assign) GMUPreferredTerminalApp preferredTerminalApp;

- (NSAppleScript *_Nullable)revealInTerminalScriptWithErrors:
      (NSDictionary<NSString *, id> *__autoreleasing _Nullable *_Nullable)errorInfo;

- (void)revealDirectoryInTerminalApp:(NSURL *)directory;

@end

NS_ASSUME_NONNULL_END