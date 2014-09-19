//
//  MWItem.m
//  Homeowner
//
//  Created by Mathew Wong on 8/24/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWItem.h"

@implementation MWItem

@synthesize name = _name;
@synthesize serialNumber = _serialNumber;
@synthesize valueInDollars = _valueInDollars;
@synthesize dateCreated = _dateCreated;
@synthesize thumbnail = _thumbnail;

-(instancetype) initWithName:(NSString *)name andSerialNumber:(NSString *)sn andPrice:(float)price andDateCreated:(NSDate *)dc {
    if(self = [super init]) {
        _name = name;
        _serialNumber = sn;
        _valueInDollars = price;
        _dateCreated = dc;
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    return self;
}

-(instancetype) init {
    @throw [NSException exceptionWithName:@"Initialization" reason:@"Cannot use init use [initWithName:andSerialNumber:andPrice:andDateCreated:]." userInfo:nil];
    return nil;
}

-(NSString *) description {
    
    NSDateFormatter *properDate = [[NSDateFormatter alloc] init];
    [properDate setDateFormat: @"yyyy-MM-dd h:mm:ss a"];
    NSString *theDate = [properDate stringFromDate:self.dateCreated];
    NSString *descriptionText = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%.2f, recorded on %@", self.name
                                                                                                        , self.serialNumber
                                                                                                        , self.valueInDollars
                                                                                                        , theDate];
    return descriptionText;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeFloat:self.valueInDollars forKey:@"valueInDollars"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if(self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _valueInDollars = [aDecoder decodeFloatForKey:@"valueInDollars"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
    }
    
    return self;
}

-(void)setThumbnailFromImage:(UIImage *)image {
    CGSize origImageSize = image.size;
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    float ratio = MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    [path addClip];
    
    CGRect projectRect;
    
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    UIGraphicsEndImageContext();
}

@end
