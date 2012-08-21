//
//  NewFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "NewFlightTableViewController.h"

@interface NewFlightTableViewController ()

- (NSDictionary *)gatherDataFromTextFields;

@end

@implementation NewFlightTableViewController

@synthesize delegate = _delegate;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.flightTextField becomeFirstResponder];
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    //[self.delegate newFlightTableViewController:self didEnterFlightInformation:[self gatherDataFromTextFields]];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}

- (NSDictionary *)gatherDataFromTextFields {
    NSArray *objects = [NSArray arrayWithObjects:[self.flightTextField.text substringToIndex:3], [self.flightTextField.text substringFromIndex:4], self.confirmTextField.text, [[self.costTextField.text substringFromIndex:1] doubleValue], self.expirationTextField.text, [NSNumber numberWithBool:self.roundtripSwitch.on], self.outboundTextField.text, self.returnTextField.text, [NSNumber numberWithBool:self.checkInReminderSwitch.on], self.notesTextField.text, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"origin", @"destination", @"confirmationCode", @"cost", @"travelFund.expirationDate", @"roundtrip", @"outboundDepartureDate", @"returnDepartureDate", @"checkInReminder", @"notes", nil];
    NSDictionary *flightInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return flightInfo;
}


@end
