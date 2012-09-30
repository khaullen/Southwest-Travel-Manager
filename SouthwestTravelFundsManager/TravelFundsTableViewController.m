//
//  TravelFundsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "TravelFundsTableViewController.h"
#import "Flight+Create.h"
#import "Airport+Create.h"
#import "NewFundTableViewController.h"
#import "FundDetailsTableViewController.h"

@interface TravelFundsTableViewController () <NewFundDelegate>

+ (BOOL)lastRow:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;

- (void)updateFundTotals:(UITableView *)tableView;

@end

@implementation TravelFundsTableViewController

@synthesize formatter = _formatter;

+ (BOOL)lastRow:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    return indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1;
}

- (DateAndCurrencyFormatter *)formatter {
    if (!_formatter) _formatter = [[DateAndCurrencyFormatter alloc] init];
    return _formatter;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"segueToNewFund"]) {
        NewFundTableViewController *newFund = (NewFundTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        newFund.delegate = self;
        newFund.formatter = self.formatter;
    } else if ([segue.identifier isEqualToString:@"segueToDetail"]) {
        FundDetailsTableViewController *fundDetails = (FundDetailsTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        fundDetails.fund = [self.fetchedResultsController objectAtIndexPath:indexPath];
        fundDetails.formatter = self.formatter;
    }
}

- (void)newFundTableViewController:(NewFundTableViewController *)sender didEnterFundInformation:(NSDictionary *)fundInfo {
    Fund *fund = [Fund fundWithDictionary:fundInfo inManagedObjectContext:self.database.managedObjectContext];
    [DatabaseHelper saveDatabase];
    [FlurryAnalytics logEvent:@"NEW_FUND_CREATED" withParameters:[self flurryParametersForFund:fund]];
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Fund *fund = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [FlurryAnalytics logEvent:@"FUND_DELETED" withParameters:[self flurryParametersForFund:fund]];
    }
    [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

- (void)setupFetchedResultsController {
    [super setupFetchedResultsController];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fund"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:EXPIRATION_DATE ascending:TRUE]];
    request.predicate = [NSPredicate predicateWithFormat:@"(balance > 0) AND (expirationDate > %@)", [NSDate date]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *fundCellIdentifier = @"fund";
    static NSString *totalCellIdentifier = @"total";
        
    UITableViewCell *cell;
    
    if ([[self class] lastRow:indexPath inTableView:tableView]) {
        cell = [tableView dequeueReusableCellWithIdentifier:totalCellIdentifier];
        double fundsTotal;
        for (Fund *fund in self.fetchedResultsController.fetchedObjects) {
            fundsTotal += fund.balance.doubleValue;
        }
        int fundCount = self.fetchedResultsController.fetchedObjects.count;
        cell.textLabel.text = [NSString stringWithFormat:@"%d Fund%@, %@", fundCount, fundCount == 1 ? @"" : @"s", [self.formatter stringForCost:[NSNumber numberWithDouble:fundsTotal]]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:fundCellIdentifier];
        Fund *fund = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [self.formatter stringForCost:fund.balance];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", fund.originalFlight.confirmationCode, [self.formatter stringForDate:fund.expirationDate withFormat:DATE_FORMAT inTimeZone:[NSTimeZone localTimeZone]]];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![[self class] lastRow:indexPath inTableView:tableView];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![[self class] lastRow:indexPath inTableView:tableView];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath {
    [super controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    [self updateFundTotals:self.tableView];
}

- (void)updateFundTotals:(UITableView *)tableView {
    int lastSection = [tableView numberOfSections] - 1;
    int lastRow = [tableView numberOfRowsInSection:lastSection] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:lastIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSDictionary *)flurryParametersForFund:(Fund *)fund {
    NSArray *keys = [NSArray arrayWithObjects:CONFIRMATION_CODE, BALANCE, EXPIRATION_DATE, ORIGIN, DESTINATION, UNUSED_TICKET, NOTES, nil];
    NSArray *objects = [NSArray arrayWithObjects:fund.originalFlight.confirmationCode, fund.balance.description, [self.formatter stringForDate:fund.expirationDate withFormat:DATE_FORMAT inTimeZone:[NSTimeZone localTimeZone]], fund.originalFlight.origin ? fund.originalFlight.origin : @"", fund.originalFlight.destination ? fund.originalFlight.destination : @"", fund.unusedTicket.description, fund.notes ? fund.notes : @"", nil];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}


@end
