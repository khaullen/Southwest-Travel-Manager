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

- (UITextField *)textFieldForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: return self.confirmTextField;
            case 1: return self.costTextField;
            case 2: return self.expirationTextField;
            case 3: return self.flightTextField;
            default: return nil;
        }
    }
    if (indexPath.section == 1) return nil;
    if (indexPath.section == 2) return self.notesTextField;
    return [super textFieldForIndexPath:indexPath];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    NSString *fieldName = [self nameForPicker:textField];
    if (fieldName) {
        NSIndexPath *cellPath = [self.fundRequiredFields objectForKey:fieldName];
        if (!cellPath && [fieldName isEqualToString:ORIGIN]) cellPath = [NSIndexPath indexPathForRow:3 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellPath];
        [self selectPickerFieldCell:cell withTextField:textField selected:TRUE];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    NSString *fieldName = [self nameForPicker:textField];
    if (fieldName) {
        NSIndexPath *cellPath = [self.fundRequiredFields objectForKey:fieldName];
        if (!cellPath && [fieldName isEqualToString:ORIGIN]) cellPath = [NSIndexPath indexPathForRow:3 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellPath];
        [self selectPickerFieldCell:cell withTextField:textField selected:FALSE];
    }
}

@end
