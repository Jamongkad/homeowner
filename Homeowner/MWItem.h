//
//  MWItem.h
//  Homeowner
//
//  Created by Mathew Wong on 8/24/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWItem : NSObject <NSCoding>
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *serialNumber;
@property (nonatomic) float valueInDollars;
@property (nonatomic) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;

-(instancetype) initWithName:(NSString *) name andSerialNumber:(NSString *) sn andPrice:(float) price andDateCreated:(NSDate *) dc;
-(NSString *) description;
-(void)setThumbnailFromImage:(UIImage *)image;
@end
