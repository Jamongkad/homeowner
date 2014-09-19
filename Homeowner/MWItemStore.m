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
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;
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
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
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
    NSError *error = nil;
    BOOL successful = [self.context save:&error];
    if(!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

-(void)loadAllItems {
    if(!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"MWItem" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if(!result) {
            [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

-(NSArray *) allItems {
    return self.privateItems;
}
@end