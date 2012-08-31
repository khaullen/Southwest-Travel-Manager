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
    [self.confirmTextField becomeFirstResponder];
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    NSArray *textFields = [NSArray arrayWithObjects:self.confirmTextField, self.costTextField, self.notesTextField, nil];
    for (UITextField *field in textFields) {
        if ([field isFirstResponder]) [self textFieldDidEndEditing:field];
    }
    [self.fieldData setObject:[NSNumber numberWithBool:self.unusedTicketSwitch.on] forKey:UNUSED_TICKET];
    if (![self tableHasIncompleteRequiredFields:self.fundRequiredFields]) [self.delegate newFundTableViewController:self didEnterFundInformation:self.fieldData];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}


@end
