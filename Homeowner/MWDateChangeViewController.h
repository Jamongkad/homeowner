//
//  MWDateChangeViewController.h
//  Homeowner
//
//  Created by Mathew Wong on 8/28/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWItem;

@interface MWDateChangeViewController : UIViewController
@property (nonatomic, strong) MWItem *item;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end
