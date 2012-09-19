//
//  GenericFundTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/18/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericFundTableViewController.h"

@implementation GenericFundTableViewController

@dynamic fundRequiredFields;

- (NSDictionary *)fundRequiredFields {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], CONFIRMATION_CODE, [NSIndexPath indexPathForRow:1 inSection:0], COST, [NSIndexPath indexPathForRow:2 inSection:0], EXPIRATION_DATE, nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    NSString *fieldName = [self nameForPicker:textField];
    if (fieldName) {
        NSIndexPath *cellPath = [self.fundRequiredFields objectForKey:fieldName];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellPath];
        [self selectPickerFieldCell:cell withTextField:textField selected:TRUE];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    NSString *fieldName = [self nameForPicker:textField];
    if (fieldName) {
        NSIndexPath *cellPath = [self.fundRequiredFields objectForKey:fieldName];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellPath];
        [self selectPickerFieldCell:cell withTextField:textField selected:FALSE];
    }
}

@end
