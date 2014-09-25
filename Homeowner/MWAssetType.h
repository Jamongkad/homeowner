//
//  MWAssetType.h
//  Homeowner
//
//  Created by Mathew Wong on 9/22/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MWItem;

@interface MWAssetType : NSManagedObject

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSSet *items;
@end

@interface MWAssetType (CoreDataGeneratedAccessors)

- (void)addItemsObject:(MWItem *)value;
- (void)removeItemsObject:(MWItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
