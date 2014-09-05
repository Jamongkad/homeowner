//
//  MWImageStore.h
//  Homeowner
//
//  Created by Mathew Wong on 8/29/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWImageStore : NSObject

+(instancetype) sharedStore;
-(void)setImage: (UIImage *)image forKey:(NSString *) key;
-(UIImage *)fetchImageByKey:(NSString *) key;
-(void)deleteImageByKey:(NSString *) key;
@end
