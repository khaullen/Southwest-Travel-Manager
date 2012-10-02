//
//  DataEntryCell.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 10/1/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "DataEntryCell.h"

@implementation DataEntryCell

@synthesize label = _label;
@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
