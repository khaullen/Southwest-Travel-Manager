//
//  NewFundTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "NewFundTableViewController.h"
#import "Flight+Create.h"
#import "Fund+Create.h"

@implementation NewFundTableViewController

@synthesize delegate = _delegate;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePlaceholderText];
    //[self.confirmTextField becomeFirstResponder];
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self finalizeEnteredData];
    if (![self tableHasIncompleteRequiredFields:self.fundRequiredFields]) [self.delegate newFundTableViewController:self didEnterFundInformation:self.fieldData];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}


@end
