@import Quick;
@import Nimble;
#import <GMUDataModel/GMUDataModel.h>

@interface GMUCoreDataStackManager ()

@property(readwrite) NSString *storeType;

@end

QuickSpecBegin(GMUCoreDataManagerSpec)

    describe(@"The CoreData Manager", ^{
        [[GMUCoreDataStackManager sharedManager] setStoreType:NSInMemoryStoreType];
        __block GMUCoreDataStackManager *manager = [GMUCoreDataStackManager sharedManager];

        beforeEach(^{
            expect(manager.storeType).to(equal(NSInMemoryStoreType));
        });

        describe(@"It's store type", ^{
            it(@"is in memory", ^{
                expect(manager.storeType).to(equal(NSInMemoryStoreType));
            });
        });
    });

QuickSpecEnd
