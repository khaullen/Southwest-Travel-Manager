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
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField.delegate = self;
    }
    return self;
}

- (void)awakeFromNib {
    self.textField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate dataEntryCell:self textFieldDidReturn:textField];
    return TRUE;
}

@end
