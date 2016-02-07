//
//  NSURL+Subpaths.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 2/4/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

@import Foundation;

@interface NSURL (Subpaths)

@property(readonly) BOOL jml_hasDirectoryPath;
- (BOOL)jml_isSubpathOfURL:(NSURL *)aURL;

@end

@interface NSString (Subpaths)

- (BOOL)jml_isSubpathOfPath:(NSString *)aPath;

@end