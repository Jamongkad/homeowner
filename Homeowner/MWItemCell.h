//
//  MWItemCell.h
//  Homeowner
//
//  Created by Mathew Wong on 9/9/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic, copy) void(^actionBlock)(void);
@end
