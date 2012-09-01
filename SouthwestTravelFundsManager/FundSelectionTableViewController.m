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
@dynamic remainingBalance;
@synthesize formatter = _formatter;
@synthesize delegate = _delegate;

- (NSMutableDictionary *)appliedFunds {
    if (!_appliedFunds) _appliedFunds = [NSMutableDictionary dictionaryWithCapacity:self.travelFunds.count];
    return _appliedFunds;
}

- (double)remainingBalance {
    double remainingBalance = [self.flightCost doubleValue];
    for (NSArray *array in [self.appliedFunds allValues]) {
        remainingBalance -= [[array objectAtIndex:0] doubleValue];
    }
    return remainingBalance;
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
    double amountApplied;
        
    switch (indexPath.section) {
        case 0:
            fund = [self.travelFunds objectAtIndex:indexPath.row];
            amountApplied = [[[self.appliedFunds objectForKey:fund.originalFlight.confirmationCode] objectAtIndex:0] doubleValue];
            if (amountApplied) cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = [self.formatter stringForCost:[NSNumber numberWithDouble:[fund.balance doubleValue] - amountApplied]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", fund.originalFlight.confirmationCode, [self.formatter stringForDate:fund.expirationDate withFormat:DATE_FORMAT inTimeZone:[NSTimeZone localTimeZone]]];
            break;
        case 1:
            cell.textLabel.text = [self.formatter stringForCost:[NSNumber numberWithDouble:self.remainingBalance]];
            cell.detailTextLabel.text = @"Remaining balance";
            break;
        default:
            break;
    }    
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]] ? nil : indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:TRUE];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Fund *selectedFund = [self.travelFunds objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.appliedFunds setObject:[NSArray arrayWithObjects:[NSNumber numberWithDouble:0],selectedFund, nil] forKey:selectedFund.originalFlight.confirmationCode];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.appliedFunds removeObjectForKey:selectedFund.originalFlight.confirmationCode];
    }
    [self rebalanceFundDistribution];
    [self.tableView reloadData];
}

- (void)rebalanceFundDistribution {
    NSSortDescriptor *unusedTicketSort = [NSSortDescriptor sortDescriptorWithKey:UNUSED_TICKET ascending:FALSE];
    NSSortDescriptor *expirationDateSort = [NSSortDescriptor sortDescriptorWithKey:EXPIRATION_DATE ascending:TRUE];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:unusedTicketSort, expirationDateSort, nil];
    NSMutableArray *orderedFunds = [NSMutableArray arrayWithCapacity:self.appliedFunds.count];
    for (NSArray *array in [self.appliedFunds allValues]) {
        [orderedFunds addObject:array.lastObject];
    }
    [orderedFunds sortUsingDescriptors:sortDescriptors];
    for (Fund *fund in orderedFunds) {
        [self.appliedFunds setObject:[NSArray arrayWithObjects:[NSNumber numberWithDouble:0], fund, nil] forKey:fund.originalFlight.confirmationCode];
    }
    NSDate *earliestExpiration;
    for (Fund *fund in orderedFunds) {
        if (self.remainingBalance > 0) {
            double amountApplied = MIN([fund.balance doubleValue], self.remainingBalance);
            [self.appliedFunds setObject:[NSArray arrayWithObjects:[NSNumber numberWithDouble:amountApplied], fund, nil] forKey:fund.originalFlight.confirmationCode];
            if (amountApplied) {
                if (!earliestExpiration) {
                    earliestExpiration = fund.expirationDate;
                } else {
                    earliestExpiration = [earliestExpiration earlierDate:fund.expirationDate];
                }
            }
        }
    }
    [self.delegate fundSelectionTableViewController:self didSelectFunds:[self.appliedFunds copy] withExpirationDate:earliestExpiration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
