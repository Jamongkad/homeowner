//
//  MWAssetTypeViewController.h
//  Homeowner
//
//  Created by Mathew Wong on 9/19/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWItem;

@interface MWAssetTypeViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) MWItem *item;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSArray *allAssets;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end
