//
//  MWDetailViewController.m
//  Homeowner
//
//  Created by Mathew Wong on 8/26/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWDetailViewController.h"
#import "MWDateChangeViewController.h"
#import "MWAssetTypeViewController.h"
#import "MWImageStore.h"
#import "MWItem.h"
#import "MWItemStore.h"

@interface MWDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic) UIPopoverController *popOverController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end

@implementation MWDetailViewController

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {

    BOOL isNew = NO;
    if([identifierComponents count] == 3) {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    self.item.name = self.nameField.text;
    self.item.serialNumber = self.serialField.text;
    self.item.valueInDollars = [self.valueField.text floatValue];

    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    for(MWItem *item in [[MWItemStore sharedStore] allItems]) {
        if([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    [super decodeRestorableStateWithCoder:coder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:@"Wrong Initializer" reason:@"Use initForNewItem" userInfo:nil];
    return nil;
}

-(void)setItem:(MWItem *)item {
    _item = item;
    self.navigationItem.title = _item.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapped)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    if([[MWImageStore sharedStore] fetchImageByKey:self.item.itemKey]) {
        self.deleteButton.enabled = YES;
    } else {
        self.deleteButton.enabled = NO;
    }
}

-(instancetype)initForNewItem:(BOOL)isNew {
    if(self = [super initWithNibName:nil bundle:nil]) {
        self.restorationClass = [self class];
        if(isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                                      action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    return self;
}

- (BOOL)shouldAutorotate
{
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(void)save:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

-(void)cancel:(id)sender{
    [[MWItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

-(void) bgTapped {
    [self.nameField resignFirstResponder];
    [self.serialField resignFirstResponder];
    [self.valueField resignFirstResponder];
    [self.popOverController dismissPopoverAnimated:YES];
}

- (void)didReceiveMemoryWarning {
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
    
    [self updateDateFormatter];
    
    NSString *imageKey = self.item.itemKey;
    UIImage *imageToDisplay = [[MWImageStore sharedStore] fetchImageByKey:imageKey];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = imageToDisplay;
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    if(!typeLabel) {
        typeLabel = @"None";
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
    
    [self updateFonts];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    MWItem *item = self.item;
    item.name = self.nameField.text;
    item.serialNumber = self.serialField.text;
    item.valueInDollars = [self.valueField.text floatValue];
}

-(void) updateDateFormatter {
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

-(IBAction)showDateChanger:(id)sender {
    
    if([self.popOverController isPopoverVisible]) {
        [self.popOverController dismissPopoverAnimated:YES];
        self.popOverController = nil;
        return;
    }
    
    MWDateChangeViewController *dateChangeController = [[MWDateChangeViewController alloc] init];
    MWItem *item = self.item;
    dateChangeController.item = item;

    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.popOverController = [[UIPopoverController alloc] initWithContentViewController:dateChangeController];
        self.popOverController.delegate = self;
        [self.popOverController presentPopoverFromRect:((UIButton *)sender).bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self.navigationController pushViewController:dateChangeController animated:YES];
    }
}

- (IBAction)openCamera:(id)sender {
    
    if([self.popOverController isPopoverVisible]) {
        [self.popOverController dismissPopoverAnimated:YES];
        self.popOverController = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.popOverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.popOverController.delegate = self;
        [self.popOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    //We assume that this is taken from the camera
    if(editedImage && originalImage) {
        self.imageView.image = editedImage;
        [self.item setThumbnailFromImage:editedImage];
        
        [[MWImageStore sharedStore] setImage:editedImage forKey:self.item.itemKey];
    } else {
    //this taken from the photo library
        self.imageView.image = originalImage;
        [self.item setThumbnailFromImage:originalImage];
        
        [[MWImageStore sharedStore] setImage:originalImage forKey:self.item.itemKey];
        [self.popOverController dismissPopoverAnimated:YES];
    }
    
    self.deleteButton.enabled = YES;
    
    if(self.popOverController) {
        [self.popOverController dismissPopoverAnimated:YES];
        self.popOverController = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)deletePhoto:(id)sender {
    [[MWImageStore sharedStore] deleteImageByKey:self.item.itemKey];
    //delete thumbnail so NSCoder can update its serialization
    self.item.thumbnail = nil;
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

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

-(void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation {
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"Rotation done");
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self updateDateFormatter];
    self.popOverController = nil;
}

-(void)updateFonts {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    self.nameField.font = font;
    self.serialField.font = font;
    self.valueField.font = font;
}
- (IBAction)showAssetTypePicker:(id)sender {
    [self.view endEditing:YES];
    MWAssetTypeViewController *avc = [[MWAssetTypeViewController alloc] init];
    avc.item = self.item;
    [self.navigationController pushViewController:avc animated:YES];
}

-(void)dealloc {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}
@end