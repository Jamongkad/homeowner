//
//  MWItemsViewController.m
//  Homeowner
//
//  Created by Mathew Wong on 8/24/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWDetailViewController.h"
#import "MWItemsViewController.h"
#import "MWItemStore.h"
#import "MWItem.h"

@interface MWItemsViewController()

@end

@implementation MWItemsViewController


-(instancetype) init {
    if(self = [super initWithStyle:UITableViewStylePlain]) {

        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homeowner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
        
        MWItem *megz = [[MWItem alloc] initWithName:@"Megz" andSerialNumber:@"131415-161718" andPrice:100 andDateCreated:[NSDate date]];
        [[MWItemStore sharedStore] addItem: megz];

    }
    return self;
}

-(instancetype) initWithStyle:(UITableViewStyle)style {
    return [self init];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}

-(NSInteger) getLastRowIndex {
    NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
    return lastRowIndex;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row != [self getLastRowIndex]) {
        
        MWDetailViewController *detailViewController = [[MWDetailViewController alloc] init];
        MWItem *item = [[MWItemStore sharedStore] allItems][indexPath.row];
        detailViewController.item = item;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[MWItemStore sharedStore] allItems] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];

    NSArray *items = [[MWItemStore sharedStore] allItems];
    MWItem *item = items[indexPath.row];
    
    cell.textLabel.text = [item description];
    
    if(indexPath.row == [self getLastRowIndex]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if([[[MWItemStore sharedStore] allItems] count] == (indexPath.row+1)) {
            //item is last
            cell.accessoryType = UITableViewCellAccessoryNone;//UITableViewCellAccessoryDetailDisclosureButton;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

-(IBAction) addNewItem:(id)sender {

    MWItem *bee = [[MWItem alloc] initWithName:@"bee" andSerialNumber:@"1234-5678" andPrice:20 andDateCreated:[NSDate date]];
    [[MWItemStore sharedStore] addItem: bee];
    
    NSInteger lastRow = [[[MWItemStore sharedStore] allItems] indexOfObject:bee];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[MWItemStore sharedStore] allItems];
        MWItem *item = items[indexPath.row];
        [[MWItemStore sharedStore] removeItem:item];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[MWItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove Item";
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if(proposedDestinationIndexPath.row == [self getLastRowIndex]) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        return NO;
    }
    
    return YES;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    UILabel *headerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, headerSection.frame.size.width, 25.0)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment   = NSTextAlignmentCenter;
    
    [headerLabel setFont:[UIFont fontWithName:@"Verdana" size:20.0]];
    
    [headerSection addSubview:headerLabel];
    
    headerLabel.text = @"Your Items";
   
    return headerSection;
}
@end