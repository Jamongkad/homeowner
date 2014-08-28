//
//  MWDateChangeViewController.m
//  Homeowner
//
//  Created by Mathew Wong on 8/28/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWDateChangeViewController.h"
#import "MWItem.h"

@interface MWDateChangeViewController ()

@end

@implementation MWDateChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.datePicker setDate: self.item.dateCreated];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void) dateChanged:(id)sender {
    self.item.dateCreated = self.datePicker.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end