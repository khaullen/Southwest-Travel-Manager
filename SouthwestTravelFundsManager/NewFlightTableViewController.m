//
//  NewFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "NewFlightTableViewController.h"
#import "Flight+Create.h"
#import "Fund+Create.h"

@interface NewFlightTableViewController ()

- (void)updatePlaceholderText;

@end

@implementation NewFlightTableViewController

@synthesize requiredFields = _requiredFields;
@synthesize delegate = _delegate;

- (NSDictionary *)requiredFields {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], ORIGIN, [NSIndexPath indexPathForRow:0 inSection:0], DESTINATION, [NSIndexPath indexPathForRow:1 inSection:0], CONFIRMATION_CODE, [NSIndexPath indexPathForRow:2 inSection:0], COST, [NSIndexPath indexPathForRow:3 inSection:0], EXPIRATION_DATE, [NSIndexPath indexPathForRow:0 inSection:2], CHECK_IN_REMINDER, [NSIndexPath indexPathForRow:0 inSection:1], ROUNDTRIP, [NSIndexPath indexPathForRow:1 inSection:1], OUTBOUND_DEPARTURE_DATE, self.roundtripSwitch.on ? [NSIndexPath indexPathForRow:2 inSection:1] : nil, RETURN_DEPARTURE_DATE, nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePlaceholderText];
    [self.flightTextField becomeFirstResponder];
}

- (void)updatePlaceholderText {
    self.expirationTextField.placeholder = [self.formatter stringForDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)] withFormat:DATE_FORMAT inTimeZone:[NSTimeZone localTimeZone]];
    self.outboundTextField.placeholder = [self.formatter stringForDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*31)] withFormat:DATE_TIME_FORMAT inTimeZone:[NSTimeZone localTimeZone]];
    self.returnTextField.placeholder = [self.formatter stringForDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*36)] withFormat:DATE_TIME_FORMAT inTimeZone:[NSTimeZone localTimeZone]];
    }

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    NSArray *textFields = [NSArray arrayWithObjects:self.confirmTextField, self.costTextField, self.notesTextField, nil];
    for (UITextField *field in textFields) {
        if ([field isFirstResponder]) [self textFieldDidEndEditing:field];
    }
    [self.fieldData setObject:[NSNumber numberWithBool:self.roundtripSwitch.on] forKey:ROUNDTRIP];
    [self.fieldData setObject:[NSNumber numberWithBool:self.checkInReminderSwitch.on] forKey:CHECK_IN_REMINDER];
    if (![self tableHasIncompleteRequiredFields:self.requiredFields]) [self.delegate newFlightTableViewController:self didEnterFlightInformation:self.fieldData];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}

@end
