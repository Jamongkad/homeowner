//
//  MWItemStore.h
//  Homeowner
//
//  Created by Mathew Wong on 8/24/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

@class MWItem;

#import <Foundation/Foundation.h>

@interface MWItemStore : NSObject
@property (nonatomic, readonly) NSArray *allItems;
+(instancetype)sharedStore;
-(MWItem *) createItem;
-(void) addItem:(MWItem *) item;
-(void) removeItem:(MWItem *) item;
-(void) moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end