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

@end
