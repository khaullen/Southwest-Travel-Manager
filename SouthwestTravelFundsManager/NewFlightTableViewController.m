//
//  NewFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "NewFlightTableViewController.h"

@interface NewFlightTableViewController ()

- (NSDictionary *)gatherData;

@end

@implementation NewFlightTableViewController

@synthesize delegate = _delegate;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.flightTextField becomeFirstResponder];
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    //[self.delegate newFlightTableViewController:self didEnterFlightInformation:[self gatherData]];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}

- (NSDictionary *)gatherData {
    NSArray *objects = [NSArray arrayWithObjects:self.origin, self.destination, self.confirmationCode, self.cost, self.expirationDate, self.roundtrip, self.outboundDepartureDate, self.returnDepartureDate, self.checkInReminder, self.notes, [NSNumber numberWithBool:FALSE], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"origin", @"destination", @"confirmationCode", @"cost", @"travelFund.expirationDate", @"roundtrip", @"outboundDepartureDate", @"returnDepartureDate", @"checkInReminder", @"notes", @"used", nil];
    
    // Also add in passenger info from NSUserDefaults
    
    NSDictionary *flightInfo = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return flightInfo;
}


@end
