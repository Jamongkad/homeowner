//
//  MWImageTransformer.m
//  Homeowner
//
//  Created by Mathew Wong on 9/19/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWImageTransformer.h"

@implementation MWImageTransformer

+(Class)transformedValueClass {
    return [NSDate class];
}

-(id)transformedValue:(id)value {
    if(!value) {
        return nil;
    }
    
    if([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:value];
}

@end
