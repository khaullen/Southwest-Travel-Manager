//
//  FundSelectionTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/31/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "FundSelectionTableViewController.h"

@interface FundSelectionTableViewController ()

- (void)rebalanceFundDistribution;

@end

@implementation FundSelectionTableViewController

@synthesize travelFunds = _travelFunds;
@synthesize flightDetails = _flightDetails;
@synthesize flightCost = _flightCost;
@synthesize appliedFunds = _appliedFunds;
@synthesize remainingBalance = _remainingBalance;
@synthesize formatter = _formatter;

- (NSMutableDictionary *)appliedFunds {
    if (!_appliedFunds) _appliedFunds = [NSMutableDictionary dictionaryWithCapacity:self.travelFunds.count];
    return _appliedFunds;
}

- (double)remainingBalance {
    if (!_remainingBalance) _remainingBalance = [self.flightCost doubleValue];
    return _remainingBalance;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.travelFunds.count;    
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return self.flightDetails;
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"fund";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Fund *fund;
    double remainingBalance = [self.flightCost doubleValue];
        
    switch (indexPath.section) {
        case 0:
            fund = [self.travelFunds objectAtIndex:indexPath.row];
            cell.textLabel.text = [self.formatter stringForCost:fund.balance];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", fund.originalFlight.confirmationCode, [self.formatter stringForDate:fund.expirationDate withFormat:DATE_FORMAT inTimeZone:[NSTimeZone localTimeZone]]];
            break;
        case 1:
            for (NSNumber *num in [self.appliedFunds allValues]) {
                remainingBalance -= [num doubleValue];
            }
            cell.textLabel.text = [self.formatter stringForCost:[NSNumber numberWithDouble:remainingBalance]];
            cell.detailTextLabel.text = @"Remaining balance";
            break;
        default:
            break;
    }    
    
    return cell;
}

#pragma mark - Table view delegate

// Disallow selection of balance row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:TRUE];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Fund *selectedFund = [self.travelFunds objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.appliedFunds setObject:selectedFund.balance forKey:selectedFund.originalFlight.confirmationCode];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.appliedFunds removeObjectForKey:selectedFund.originalFlight.confirmationCode];
    }
    [self rebalanceFundDistribution];
    [self.tableView reloadData];
}

- (void)rebalanceFundDistribution {

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
