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
- (void)finalizeEnteredData;

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
    if ([segue.identifier isEqualToString:@"segueToFundSelection"]) {
        FundSelectionTableViewController *fundSelectionTVC = segue.destinationViewController;
        fundSelectionTVC.formatter = self.formatter;
        fundSelectionTVC.travelFunds = [self allFundsWithContext:self.context];
        fundSelectionTVC.flightDetails = [NSString stringWithFormat:@"%@ to %@ %@", [[self.fieldData objectForKey:ORIGIN] objectForKey:CITY], [[self.fieldData objectForKey:DESTINATION] objectForKey:CITY], [[self.fieldData objectForKey:ROUNDTRIP] boolValue] ? @"roundtrip" : @"one way"];
        fundSelectionTVC.flightCost = [self.fieldData objectForKey:COST];
        fundSelectionTVC.appliedFunds = [[self.fieldData objectForKey:FUNDS_USED] mutableCopy];
        fundSelectionTVC.delegate = self;
    }
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self finalizeEnteredData];
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

- (void)finalizeEnteredData {
    NSArray *textFields = [NSArray arrayWithObjects:self.confirmTextField, self.costTextField, self.notesTextField, nil];
    for (UITextField *field in textFields) {
        if ([field isFirstResponder]) [self textFieldDidEndEditing:field];
    }
    [self.fieldData setObject:[NSNumber numberWithBool:self.roundtripSwitch.on] forKey:ROUNDTRIP];
    [self.fieldData setObject:[NSNumber numberWithBool:self.checkInReminderSwitch.on] forKey:CHECK_IN_REMINDER];
}

- (NSArray *)allFundsWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fund"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"expirationDate" ascending:TRUE]];
    request.predicate = [NSPredicate predicateWithFormat:@"(balance > 0) AND (expirationDate > %@)", [NSDate date]];
    return [context executeFetchRequest:request error:nil];
}

- (void)fundSelectionTableViewController:(FundSelectionTableViewController *)sender didSelectFunds:(NSDictionary *)appliedFunds withExpirationDate:(NSDate *)expirationDate {
    [self.fieldData setObject:appliedFunds forKey:FUNDS_USED];
    
    // Update label text
    
    NSMutableSet *fundSet = [NSMutableSet set];
    for (NSArray *array in [appliedFunds allValues]) {
        [fundSet addObject:array.lastObject];
    }
    [self updateFundsUsedLabel:fundSet];
    
    // Update expiration date
    
    if (expirationDate) {
        self.expirationDatePicker.date = [expirationDate earlierDate:self.expirationDatePicker.date];
        [self datePickerDidEndEditing:self.expirationDatePicker];
    }
}

- (void)switchDidEndEditing:(UISwitch *)sender {
    [super switchDidEndEditing:sender];
    if ([sender isEqual:self.roundtripSwitch]) [self.tableView reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self finalizeEnteredData];
    return ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:3]] && ![self tableHasIncompleteRequiredFields:self.flightRequiredFields]) ? indexPath : nil;
}

@end
