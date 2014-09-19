//
//  MWItem.h
//  Homeowner
//
//  Created by Mathew Wong on 9/19/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MWItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * serialNumber;
@property (nonatomic) float valueInDollars;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * itemKey;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain) NSManagedObject *assetType;

-(void)setThumbnailFromImage:(UIImage *)image;

@end
