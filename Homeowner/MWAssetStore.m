//
//  MWAssetStore.m
//  Homeowner
//
//  Created by Mathew Wong on 9/22/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWAssetStore.h"
#import "MWAssetType.h"

@interface MWAssetStore()

@end

@implementation MWAssetStore

+(instancetype) sharedStore {
    static MWAssetStore *sharedStore = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

-(instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[MWAssetStore sharedStore] instead." userInfo:nil];
    return nil;
}

-(instancetype) initPrivate {
    if(self = [super init]) {
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"store.data"];
    }
    return self;
}

-(void)createAsset:(NSString *)text {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        MWAssetType *asset = [MWAssetType MR_createInContext:localContext];
        asset.label = text;
    } completion:^(BOOL success, NSError *error) {}];
}


-(BOOL)removeAsset:(MWAssetType *)asset {
    return YES;
}

-(NSArray *) fetchAllAssets {
    NSArray *assets = [MWAssetType MR_findAll];
    return assets;
}

-(NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

@end