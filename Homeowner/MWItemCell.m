//
//  MWItemCell.m
//  Homeowner
//
//  Created by Mathew Wong on 9/9/14.
//  Copyright (c) 2014 Mathew Wong. All rights reserved.
//

#import "MWItemCell.h"

@implementation MWItemCell

@synthesize thumbnailView = _thumbnailView;
@synthesize nameLabel = _nameLabel;
@synthesize serialNumberLabel = _serialNumberLabel;
@synthesize valueLabel = _valueLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
