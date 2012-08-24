//
//  NewFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "NewFlightTableViewController.h"

@interface NewFlightTableViewController ()

@end

@implementation NewFlightTableViewController

@synthesize delegate = _delegate;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.flightTextField becomeFirstResponder];
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
