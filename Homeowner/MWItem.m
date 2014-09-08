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
    [aCoder encodeFloat:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {

    if(self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _valueInDollars = [aDecoder decodeFloatForKey:@"valueInDollars"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
    }
    
    return self;
}

@end
