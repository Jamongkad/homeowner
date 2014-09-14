//
//  MWItemStore.m
//  Homeowner
//
//  Created by Mathew Wong on 8/24/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWItemStore.h"
#import "MWImageStore.h"
#import "MWItem.h"

@interface MWItemStore()
@property (nonatomic) NSMutableArray *privateItems;
@end

@implementation MWItemStore

+(instancetype) sharedStore {
    static MWItemStore *sharedStore = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

-(instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[MWItemStore sharedStore] instead." userInfo:nil];
    return nil;
}

-(instancetype) initPrivate {
    if(self = [super init]) {
        
        NSString *path = [self itemArchivePath];
        
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if(!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

-(MWItem *) createItem {
    MWItem *item = [[MWItem alloc] init];
    [self.privateItems addObject:item];
    return item;
}

-(void) addItem:(MWItem *) item {
    [self.privateItems insertObject:item atIndex:0];
}

-(void) removeItem:(MWItem *)item {
    NSString *key = item.itemKey;
    [[MWImageStore sharedStore] deleteImageByKey:key];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void) moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if(fromIndex == toIndex) { return; }
    
    MWItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

-(BOOL)saveChanges {
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}


-(NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

-(NSArray *) allItems {
    return self.privateItems;
}
@end