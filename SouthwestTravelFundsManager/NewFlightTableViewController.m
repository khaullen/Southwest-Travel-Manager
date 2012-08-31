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

- (NSArray *)allFundsWithContext:(NSManagedObjectContext *)context;
- (void)resignTextFieldFirstResponders;

@end

@implementation NewFlightTableViewController

@synthesize delegate = _delegate;
@synthesize context = _context;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePlaceholderText];
    [self.flightTextField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self resignTextFieldFirstResponders];
    if ([segue.identifier isEqualToString:@"segueToFundSelection"]) {
        FundSelectionTableViewController *fundSelectionTVC = segue.destinationViewController;
        fundSelectionTVC.formatter = self.formatter;
        fundSelectionTVC.travelFunds = [self allFundsWithContext:self.context];
        fundSelectionTVC.flightDetails = [NSString stringWithFormat:@"%@ to %@", [[self.fieldData objectForKey:ORIGIN] objectForKey:CITY], [[self.fieldData objectForKey:DESTINATION] objectForKey:CITY]];
        fundSelectionTVC.flightCost = [self.fieldData objectForKey:COST];
    }
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self resignTextFieldFirstResponders];
    [self.fieldData setObject:[NSNumber numberWithBool:self.roundtripSwitch.on] forKey:ROUNDTRIP];
    [self.fieldData setObject:[NSNumber numberWithBool:self.checkInReminderSwitch.on] forKey:CHECK_IN_REMINDER];
    if (![self tableHasIncompleteRequiredFields:self.flightRequiredFields]) [self.delegate newFlightTableViewController:self didEnterFlightInformation:self.fieldData];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissModalViewControllerAnimated:TRUE];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [super tableView:tableView numberOfRowsInSection:section] - 1 + self.roundtripSwitch.on;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (void)resignTextFieldFirstResponders {
    NSArray *textFields = [NSArray arrayWithObjects:self.confirmTextField, self.costTextField, self.notesTextField, nil];
    for (UITextField *field in textFields) {
        if ([field isFirstResponder]) [self textFieldDidEndEditing:field];
    }
}

- (NSArray *)allFundsWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fund"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"expirationDate" ascending:TRUE]];
    request.predicate = [NSPredicate predicateWithFormat:@"(balance > 0) AND (expirationDate > %@)", [NSDate date]];
    return [context executeFetchRequest:request error:nil];
}

- (void)switchDidEndEditing:(UISwitch *)sender {
    [super switchDidEndEditing:sender];
    if ([sender isEqual:self.roundtripSwitch]) [self.tableView reloadData];
}

@end
