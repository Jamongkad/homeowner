//
//  MWDetailViewController.m
//  Homeowner
//
//  Created by Mathew Wong on 8/26/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWDetailViewController.h"
#import "MWDateChangeViewController.h"
#import "MWImageStore.h"
#import "MWItem.h"

@interface MWDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic) UIPopoverController *popOverController;
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
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapped)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    if([[MWImageStore sharedStore] fetchImageByKey:self.item.itemKey]) {
        self.deleteButton.enabled = YES;
    } else {
        self.deleteButton.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
}

-(void) bgTapped {
    [self.nameField resignFirstResponder];
    [self.serialField resignFirstResponder];
    [self.valueField resignFirstResponder];
    [self.popOverController dismissPopoverAnimated:YES];
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
    self.valueField.text  = [NSString stringWithFormat:@"%.2f", self.item.valueInDollars];
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
    
    NSString *imageKey = self.item.itemKey;
    UIImage *imageToDisplay = [[MWImageStore sharedStore] fetchImageByKey:imageKey];
    self.imageView.image = imageToDisplay;
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
    MWItem *item = self.item;
    dateChangeController.item = item;
    
    [self.navigationController pushViewController:dateChangeController animated:YES];
}

- (IBAction)openCamera:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    //We assume that this is taken from the camera
    if(editedImage && originalImage) {
        self.imageView.image = editedImage;
        [[MWImageStore sharedStore] setImage:editedImage forKey:self.item.itemKey];
    } else {
    //this taken from the photo library
        self.imageView.image = originalImage;
        [[MWImageStore sharedStore] setImage:originalImage forKey:self.item.itemKey];
        [self.popOverController dismissPopoverAnimated:YES];
    }
    
    self.deleteButton.enabled = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deletePhoto:(id)sender {
    [[MWImageStore sharedStore] deleteImageByKey:self.item.itemKey];
    self.deleteButton.enabled = NO;
    self.imageView.image = nil;
}

- (IBAction)chooseFromPhotoLibrary:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    self.popOverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    self.popOverController.delegate = self;
    [self.popOverController presentPopoverFromRect:((UIButton *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end