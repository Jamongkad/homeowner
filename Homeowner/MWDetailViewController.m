//
//  MWDetailViewController.m
//  Homeowner
//
//  Created by Mathew Wong on 8/26/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWDetailViewController.h"
#import "MWDateChangeViewController.h"
#import "MWItem.h"

@interface MWDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation MWDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)setItem:(MWItem *)item {
    _item = item;
    self.navigationItem.title = _item.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.nameField.text   = self.item.name;
    self.serialField.text = self.item.serialNumber;
    self.valueField.text  = [NSString stringWithFormat:@"%f", self.item.valueInDollars];
    [self.valueField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.nameField.delegate = self;
    self.serialField.delegate = self;
    self.valueField.delegate = self;
    
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.dateLabel.text = [dateFormatter stringFromDate:self.item.dateCreated];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    MWItem *item = self.item;
    item.name = self.nameField.text;
    item.serialNumber = self.serialField.text;
    item.valueInDollars = [self.valueField.text floatValue];
}

-(IBAction)showDateChanger:(id)sender {
    MWDateChangeViewController *dateChangeController = [[MWDateChangeViewController alloc] init];
    
    dateChangeController.item = self.item;
    
    [self.navigationController pushViewController:dateChangeController animated:YES];
}

@end
