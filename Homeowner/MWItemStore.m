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
    double order;
    if([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    
    MWItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"MWItem" inManagedObjectContext:self.context];
    item.orderingValue = order;
    [self.privateItems addObject:item];
    return item;
}

-(void) removeItem:(MWItem *)item {
    NSString *key = item.itemKey;
    [[MWImageStore sharedStore] deleteImageByKey:key];
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void) moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if(fromIndex == toIndex) { return; }
    
    MWItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    double lowerBound = 0.0;
    
    if(toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    if(toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    } else {
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    item.orderingValue = newOrderValue;
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

-(NSArray *)allItems {
    return self.privateItems;
}

-(NSArray *)allAssetTypes {
    if(!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"MWAssetType" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if(!result) {
            [NSException raise:@"Fetch failed!" format:@"Reason: %@", [error localizedDescription]];
            _allAssetTypes = [result mutableCopy];
        }
        
        if([_allAssetTypes count] == 0) {
            NSManagedObject *type;
            type = [NSEntityDescription insertNewObjectForEntityForName:@"MWAssetType" inManagedObjectContext:self.context];
            [type setValue:@"Furniture" forKey:@"label"];
            [_allAssetTypes addObject:type];
        
            type = [NSEntityDescription insertNewObjectForEntityForName:@"MWAssetType" inManagedObjectContext:self.context];
            [type setValue:@"Jewelry" forKey:@"label"];
            [_allAssetTypes addObject:type];
            
            type = [NSEntityDescription insertNewObjectForEntityForName:@"MWAssetType" inManagedObjectContext:self.context];
            [type setValue:@"Electronics" forKey:@"label"];
            [_allAssetTypes addObject:type];
        }
    }
    return _allAssetTypes;
}
@end