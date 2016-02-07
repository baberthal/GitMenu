//
//  FinderSync.h
//  GitFinderMenu
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <FinderSync/FinderSync.h>

@class GMUConfiguration;

@interface GMUFinderSync : FIFinderSync

@property(nonatomic, readonly) GMUConfiguration *configuration;

@end
