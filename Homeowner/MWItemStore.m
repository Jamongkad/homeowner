//
//  MWItemStore.m
//  Homeowner
//
//  Created by Mathew Wong on 8/24/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWItemStore.h"
#import "MWItem.h"

@interface MWItemStore()
@property (nonatomic) NSMutableArray *privateItems;
@end

@implementation MWItemStore

+(instancetype) sharedStore {
    static MWItemStore *sharedStore = nil;
    if(!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

-(instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[MWItemStore sharedStore] instead." userInfo:nil];
    return nil;
}

-(instancetype) initPrivate {
    if(self = [super init]) {
        _privateItems = [[NSMutableArray alloc] init];
        [_privateItems addObject:@"No more items"];
    }
    return self;
}

-(MWItem *) createItem {
    MWItem *item = [[MWItem alloc] init];
    [self.privateItems addObject:item];
    return item;
}

-(void) addItem:(MWItem *) item {
    //[self.privateItems addObject:item];
    [self.privateItems insertObject:item atIndex:0];
}

-(void) removeItem:(MWItem *)item {
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void) moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if(fromIndex == toIndex) {
        return;
    }
    
    MWItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

-(NSArray *) allItems {
    return self.privateItems;
}
@end