//
//  MWDetailViewController.h
//  Homeowner
//
//  Created by Mathew Wong on 8/26/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWItem;

@interface MWDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) MWItem *item;

@end
