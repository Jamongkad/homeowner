//
//  MWAssetAdder.m
//  Homeowner
//
//  Created by Mathew Wong on 9/22/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWAssetAdder.h"
#import "MWAssetType.h"
#import "MWAssetStore.h"

@interface MWAssetAdder ()
@property (weak, nonatomic) IBOutlet UITextField *assetField;
@end

@implementation MWAssetAdder

@synthesize assetType = _assetType;

-(instancetype)init {
    if(self = [super init]) {
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        self.navigationItem.title = @"Add Asset Type";
        self.navigationItem.rightBarButtonItem = done;
        self.navigationItem.leftBarButtonItem = cancel;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) done:(id)sender {
    [[MWAssetStore sharedStore] createAsset:self.assetField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
