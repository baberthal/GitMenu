//
//  GMUUtilities.h
//  GitMenu
//
//  Created by Morgan Lieberthal on 1/26/16.
//  Copyright © 2016 J. Morgan Lieberthal. All rights reserved.
//

@import CoreData;
@import Foundation;

NSManagedObjectContext *GMU_privateQueueContext(NSError *__autoreleasing *error);

@interface GMUErrorFactory : NSObject

+ (void)presentCoreDataError:(NSError *)error
                 description:(NSString *)desc
                         key:(NSString *)key
                      domain:(NSString *)domain
                     andCode:(NSInteger)code;

@end