//
//  MWAssetStore.h
//  Homeowner
//
//  Created by Mathew Wong on 9/22/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWAssetType;

@interface MWAssetStore : NSObject
@property (nonatomic,copy) dispatch_block_t completionBlock;
+(instancetype)sharedStore;
-(NSArray *)fetchAllAssets;
-(void)createAsset:(NSString *)text;
-(BOOL)removeAsset:(MWAssetType *)asset;
@end
