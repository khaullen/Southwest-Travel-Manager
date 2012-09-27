//
//  GenericFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/18/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericFlightTableViewController.h"

@implementation GenericFlightTableViewController

@dynamic flightRequiredFields;

- (NSDictionary *)flightRequiredFields {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], ORIGIN, [NSIndexPath indexPathForRow:0 inSection:0], DESTINATION, [NSIndexPath indexPathForRow:1 inSection:0], CONFIRMATION_CODE, [NSIndexPath indexPathForRow:2 inSection:0], COST, [NSIndexPath indexPathForRow:3 inSection:0], EXPIRATION_DATE, [NSIndexPath indexPathForRow:0 inSection:2], CHECK_IN_REMINDER, [NSIndexPath indexPathForRow:0 inSection:1], ROUNDTRIP, [NSIndexPath indexPathForRow:1 inSection:1], OUTBOUND_DEPARTURE_DATE, [[self.fieldData objectForKey:ROUNDTRIP] boolValue] ? [NSIndexPath indexPathForRow:2 inSection:1] : nil, RETURN_DEPARTURE_DATE, nil];
}

- (UITextField *)textFieldForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: return self.flightTextField;
            case 1: return self.confirmTextField;
            case 2: return self.costTextField;
            case 3: return self.expirationTextField;
            default: return nil;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: return nil;
            case 1: return self.outboundTextField;
            case 2: return self.returnTextField;
            default: return nil;
        }
    }
    if (indexPath.section == 2) return nil;
    if (indexPath.section == 3) return nil;
    if (indexPath.section == 4) return self.notesTextField;
    return [super textFieldForIndexPath:indexPath];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    NSString *fieldName = [self nameForPicker:textField];
    if (fieldName) {
        NSIndexPath *cellPath = [self.flightRequiredFields objectForKey:fieldName];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellPath];
        [self selectPickerFieldCell:cell withTextField:textField selected:TRUE];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    NSString *fieldName = [self nameForPicker:textField];
    if (fieldName) {
        NSIndexPath *cellPath = [self.flightRequiredFields objectForKey:fieldName];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:cellPath];
        [self selectPickerFieldCell:cell withTextField:textField selected:FALSE];
    }
}

@end
