//
//  MWItemsViewController.m
//  Homeowner
//
//  Created by Mathew Wong on 8/24/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWDetailViewController.h"
#import "MWItemsViewController.h"
#import "MWImageStore.h"
#import "MWItemStore.h"
#import "MWNavigationController.h"
#import "MWItem.h"
#import "MWItemCell.h"
#import "MWImageViewController.h"

@interface MWItemsViewController() <UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController *imagePopover;
@end

@implementation MWItemsViewController


-(instancetype) init {
    if(self = [super initWithStyle:UITableViewStylePlain]) {

        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homeowner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

-(instancetype) initWithStyle:(UITableViewStyle)style {
    return [self init];
}

-(void) viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"MWItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MWItemCell"];
}

-(NSInteger) getLastRowIndex {
    NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
    NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
    return lastRowIndex;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MWDetailViewController *detailViewController = [[MWDetailViewController alloc] initForNewItem:NO];
    MWItem *item = [[MWItemStore sharedStore] allItems][indexPath.row];
    detailViewController.item = item;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[MWItemStore sharedStore] allItems] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MWItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MWItemCell" forIndexPath:indexPath];

    NSArray *items = [[MWItemStore sharedStore] allItems];
    MWItem *item = items[indexPath.row];
    
    cell.nameLabel.text =[NSString stringWithFormat:@"pwet %@", item.name];
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%.2f", item.valueInDollars];
    
    if(item.thumbnail) {
        cell.thumbnailView.image = item.thumbnail;
    } else {
        UIImage *defaultImage = [UIImage imageNamed:@"nophoto.jpg"];
        cell.thumbnailView.image = defaultImage;
    }
  
    __weak MWItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
        
        MWItemCell *strongCell = weakCell;
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            UIImage *img = [[MWImageStore sharedStore] fetchImageByKey:itemKey];
            if(!img) {
                return;
            }
            
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            MWImageViewController *ivc = [[MWImageViewController alloc] init];
            ivc.image = img;
            
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };

    return cell;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.imagePopover = nil;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if([[[MWItemStore sharedStore] allItems] count] == (indexPath.row+1)) {
            //item is last
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

-(IBAction) addNewItem:(id)sender {
    
    NSDate *today = [[NSDate alloc] init];
    MWItem *newItem = [[MWItem alloc] initWithName:@"" andSerialNumber:@"" andPrice:0 andDateCreated:today];
    MWDetailViewController *dvc = [[MWDetailViewController alloc] initForNewItem:YES];
    [dvc setItem:newItem];
    
    dvc.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    MWNavigationController *navController = [[MWNavigationController alloc] initWithRootViewController:dvc];
    [self presentViewController:navController animated:YES completion:nil];
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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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