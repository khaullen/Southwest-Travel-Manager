//
//  TravelFundsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "TravelFundsTableViewController.h"
#import "Fund+Create.h"
#import "Flight+Create.h"
#import "Airport+Create.h"
#import "NewFundTableViewController.h"
#import "FundDetailsTableViewController.h"

@interface TravelFundsTableViewController () <NewFundDelegate>

@end

@implementation TravelFundsTableViewController

@synthesize formatter = _formatter;

- (DateAndCurrencyFormatter *)formatter {
    if (!_formatter) _formatter = [[DateAndCurrencyFormatter alloc] init];
    return _formatter;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
    [Fund fundWithDictionary:fundInfo inManagedObjectContext:self.database.managedObjectContext];
    [DatabaseHelper saveDatabase];
    [self dismissModalViewControllerAnimated:TRUE];
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
    
    BOOL lastRow = indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1;
    
    UITableViewCell *cell;
    
    if (lastRow) {
        cell = [tableView dequeueReusableCellWithIdentifier:totalCellIdentifier];
        double fundsTotal;
        for (Fund *fund in self.fetchedResultsController.fetchedObjects) {
            fundsTotal += fund.balance.doubleValue;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%1$d Funds, $%2$.*3$f", self.fetchedResultsController.fetchedObjects.count, fundsTotal, 2];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:fundCellIdentifier];
        Fund *fund = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [self.formatter stringForCost:fund.balance];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", fund.originalFlight.confirmationCode, [self.formatter stringForDate:fund.expirationDate withFormat:DATE_FORMAT inTimeZone:[NSTimeZone localTimeZone]]];
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL lastRow = indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1;
    return lastRow ? nil : indexPath;
}



@end
