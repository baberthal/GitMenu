//
//  GitMenuTests.m
//  GitMenuTests
//
//  Created by Morgan Lieberthal on 1/22/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//
#import "JMLLogging.h"

#import "JMLLoggerColors.h"
#import <XCTest/XCTest.h>

@interface GitMenuTests : XCTestCase

@end

// static NSDirectoryEnumerator<NSURL *> *GMU_GitDirEnumerator(void)
//{
//    NSURL *homeDir = [NSURL URLWithString:NSHomeDirectory()];
//    NSDirectoryEnumerator<NSURL *> *result = [[NSFileManager defaultManager]
//                     enumeratorAtURL:homeDir
//          includingPropertiesForKeys:@[ NSURLIsDirectoryKey ]
//                             options:NSDirectoryEnumerationSkipsPackageDescendants
//                        errorHandler:^BOOL(NSURL *url, NSError *error) {
//                            NSLog(@"An error occured at %@. (%@).", url, error);
//                            return YES;
//                        }];
//
//    return result;
//}

@implementation GitMenuTests

+ (void)initialize
{
    [super initialize];
    setenv("XcodeColors", "YES", 0);
    JML_InitializeCocoaLumberjack();
    JML_InitializeXCodeConsoleColors();
    //    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the
    // class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the
    // class.
    [super tearDown];
}

- (void)testExample
{
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample
{
    [self measureBlock:^{
    }];
}

// static NSInteger whileLoopCallCount = 0;

- (void)testFindGitDirWithEnumeratorAtURLAndWhileLoop
{
    //    [self measureBlock:^{
    //        whileLoopCallCount++;
    //        DDLogInfo(@"%s - Call Count: %@", __PRETTY_FUNCTION__, @(whileLoopCallCount));
    //        NSDirectoryEnumerator<NSURL *> *gitRepoEnumerator = GMU_GitDirEnumerator();
    //
    //        NSURL *thisURL;
    //        NSMutableArray<NSURL *> *gitRepoURLs = [NSMutableArray array];
    //        int i = 0;
    //        while ((thisURL = [gitRepoEnumerator nextObject])) {
    //            if ([[thisURL lastPathComponent] isEqualToString:@".git"]) {
    //                i++;
    //                NSLog(@"This is a git repository, number %d.", i);
    //                [gitRepoURLs addObject:thisURL];
    //            }
    //
    //            if (i >= 100) {
    //                break;
    //            }
    //        }
    //    }];
}

// static NSInteger forInCallCount = 0;
- (void)testFindGitDirWithEnumeratorAtURLAndForInLoop
{
    //    [self measureBlock:^{
    //        forInCallCount++;
    //        DDLogInfo(@"%s - Call Count: %@", __PRETTY_FUNCTION__, @(forInCallCount));
    //        NSDirectoryEnumerator<NSURL *> *dirEnum = GMU_GitDirEnumerator();
    //        NSMutableArray<NSURL *> *gitRepos = [NSMutableArray array];
    //        int i = 0;
    //        for (NSURL *thisURL in dirEnum) {
    //            if ([[thisURL lastPathComponent] isEqualToString:@".git"]) {
    //                i++;
    //                NSLog(@"This is a git repository, number %d.", i);
    //                [gitRepos addObject:thisURL];
    //            }
    //
    //            if (i >= 100) {
    //                break;
    //            }
    //        }
    //    }];
}

- (void)testFindGitDirWithConcurrentFastEnumeration
{
    //    [self measureBlock:^{
    //        NSError *error;
    //        NSArray<NSURL *> *contentsOfHomeDirectory = [[NSFileManager defaultManager]
    //                contentsOfDirectoryAtURL:[NSURL URLWithString:NSHomeDirectory()]
    //              includingPropertiesForKeys:@[ NSURLIsDirectoryKey ]
    //                                 options:0
    //                                   error:&error];
    //
    //        if (!contentsOfHomeDirectory) {
    //            DDLogError(@"Error: %@", error);
    //        }
    //
    //        NSMutableArray<NSURL *> *dirsToSearch = [NSMutableArray array];
    //        for (NSURL *homeDirSubdir in contentsOfHomeDirectory) {
    //            NSDictionary *properties =
    //                  [homeDirSubdir resourceValuesForKeys:@[ NSURLIsDirectoryKey ] error:&error];
    //
    //            if (properties) {
    //                NSNumber *isDirNumber = properties[NSURLIsDirectoryKey];
    //
    //                if (isDirNumber && isDirNumber.boolValue) {
    //                    [dirsToSearch addObject:homeDirSubdir];
    //                }
    //            }
    //            else {
    //                DDLogError(@"Error fetching properties for URL %@ -- (%@)", homeDirSubdir,
    //                error);
    //            }
    //        }
    //
    //        __block NSMutableArray<NSURL *> *finalGitDirs = [NSMutableArray array];
    //
    //        void (^dirEnumBlock)(NSURL *url, NSUInteger idx, BOOL *stop) = ^(NSURL *url,
    //        NSUInteger idx,
    //                                                                         BOOL *stop) {
    //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
    //            ^{
    //
    //                NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager]
    //                                 enumeratorAtURL:url
    //                      includingPropertiesForKeys:nil
    //                                         options:0
    //                                    errorHandler:^BOOL(NSURL *url, NSError *error) {
    //                                        return YES;
    //                                    }];
    //
    //                NSURL *thisURL;
    //                while ((thisURL = dirEnum.nextObject)) {
    //                    if ([[thisURL lastPathComponent] isEqualToString:@".git"]) {
    //                        dispatch_sync(dispatch_get_main_queue(), ^{
    //                            DDLogInfo(@"Adding %@ to final git dirs.", thisURL);
    //                            [finalGitDirs addObject:thisURL];
    //                        });
    //                    }
    //                }
    //            });
    //        };
    //
    //        [dirsToSearch enumerateObjectsWithOptions:NSEnumerationConcurrent
    //        usingBlock:dirEnumBlock];
    //    }];
}

@end
