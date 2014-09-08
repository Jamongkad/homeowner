//
//  MWImageStore.m
//  Homeowner
//
//  Created by Mathew Wong on 8/29/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWImageStore.h"

@interface MWImageStore()
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end

@implementation MWImageStore

+(instancetype)sharedStore {
    static MWImageStore *sharedStore = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

-(instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[MWImageStore sharedStore]" userInfo:nil];
    return nil;
}

-(instancetype) initPrivate {
    
    if(self = [super init]) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return  self;

}

-(void) setImage:(UIImage *)image forKey:(id)key {
    self.dictionary[key] = image;
}

-(void) deleteImageByKey:(id)key {
    [self.dictionary removeObjectForKey:key];
}

-(UIImage *) fetchImageByKey:(id)key {
    return self.dictionary[key];
}

@end
