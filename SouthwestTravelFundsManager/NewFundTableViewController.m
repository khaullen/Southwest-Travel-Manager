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

@synthesize requiredFields = _requiredFields;
@synthesize delegate = _delegate;

- (NSDictionary *)requiredFields {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], CONFIRMATION_CODE, [NSIndexPath indexPathForRow:1 inSection:0], COST, [NSIndexPath indexPathForRow:2 inSection:0], EXPIRATION_DATE, nil];
}

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
    if (![self tableHasIncompleteRequiredFields:self.requiredFields]) [self.delegate newFundTableViewController:self didEnterFundInformation:self.fieldData];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}


@end
