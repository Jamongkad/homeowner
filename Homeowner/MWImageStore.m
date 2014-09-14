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
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return  self;
}

-(void) setImage:(UIImage *)image forKey:(id)key {
    self.dictionary[key] = image;
    NSString *imagePath = [self imagePathForKey:key];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [data writeToFile:imagePath atomically:YES];
}

-(void) deleteImageByKey:(id)key {
    if(!key) { return; }
    [self.dictionary removeObjectForKey:key];
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

-(UIImage *)fetchImageByKey:(id)key {
    
    UIImage *result = self.dictionary[key];
    
    if(!result) {
        NSString *imagePath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if(result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to fetch %@", [self imagePathForKey:key]);
        }
    }
    
    return result;
}

-(NSString *)imagePathForKey:(NSString *)key {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentaryDirectory = [documentDirectories firstObject];
    return [documentaryDirectory stringByAppendingPathComponent:key];
}

-(void)clearCache:(NSNotification *)n{
    [self.dictionary removeAllObjects];
}

@end
