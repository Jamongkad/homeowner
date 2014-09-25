//
//  MWAssetTypeViewController.m
//  Homeowner
//
//  Created by Mathew Wong on 9/19/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWAssetTypeViewController.h"
#import "MWAssetType.h"

#import "MWItemStore.h"
#import "MWItem.h"
#import "MWAssetAdder.h"

@implementation MWAssetTypeViewController

-(instancetype)init {
    if(self = [super initWithStyle:UITableViewStylePlain]) {
        UINavigationItem *navItem = self.navigationItem;
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAsset:)];
        navItem.rightBarButtonItem = bbi;
    }
    
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(void)refresh {
    [self.dataArray removeAllObjects];
    self.allAssets = [[MWItemStore sharedStore] allAssetTypes];
    [self.dataArray addObjectsFromArray:self.allAssets];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allAssets count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
   
    NSManagedObject *assetType = [self.allAssets objectAtIndex:indexPath.row];

    NSString *assetLabel = [assetType valueForKey:@"label"];
    cell.textLabel.text = assetLabel;
    
    if(assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSManagedObject *assetType = [self.allAssets objectAtIndex:indexPath.row];

    self.item.assetType = assetType;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addAsset:(id)sender {
    MWAssetAdder *maa = [[MWAssetAdder alloc] init];
    [self.navigationController pushViewController:maa animated:YES];
}
@end
