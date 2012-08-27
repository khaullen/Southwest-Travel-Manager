//
//  NewFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "NewFlightTableViewController.h"

@interface NewFlightTableViewController ()

- (void)updatePlaceholderText;

@end

@implementation NewFlightTableViewController

@synthesize delegate = _delegate;

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
    if (![self flightTableViewControllerHasIncompleteRequiredFields]) [self.delegate newFlightTableViewController:self didEnterFlightInformation:self.flightData];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}

@end
