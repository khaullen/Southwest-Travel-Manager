//
//  GenericFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericFlightTableViewController.h"

@interface GenericFlightTableViewController ()

- (void)updatePlaceholderText;

@end

@implementation GenericFlightTableViewController

@synthesize flightTextField;
@synthesize confirmTextField;
@synthesize costTextField;
@synthesize expirationTextField;
@synthesize roundtripSwitch;
@synthesize outboundTextField;
@synthesize returnTextField;
@synthesize checkInReminderSwitch;
@synthesize notesTextField;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePlaceholderText];
}

- (void)updatePlaceholderText {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.expirationTextField.placeholder = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    self.outboundTextField.placeholder = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*30)]];
    self.returnTextField.placeholder = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*35)]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setFlightTextField:nil];
    [self setConfirmTextField:nil];
    [self setCostTextField:nil];
    [self setExpirationTextField:nil];
    [self setRoundtripSwitch:nil];
    [self setOutboundTextField:nil];
    [self setReturnTextField:nil];
    [self setCheckInReminderSwitch:nil];
    [self setNotesTextField:nil];
    [super viewDidUnload];
}
@end
