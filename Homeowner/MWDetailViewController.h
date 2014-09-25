//
//  MWDetailViewController.h
//  Homeowner
//
//  Created by Mathew Wong on 8/26/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWItem;

@interface MWDetailViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIViewControllerRestoration>

@property (nonatomic, strong) MWItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

-(instancetype)initForNewItem:(BOOL)isNew;

@end
