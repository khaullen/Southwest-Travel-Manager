//
//  TravelFundsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "TravelFundsTableViewController.h"
#import "Fund+Create.h"
#import "Flight.h"

@interface TravelFundsTableViewController ()

@end

@implementation TravelFundsTableViewController

- (void)setupFetchedResultsController {
    [super setupFetchedResultsController];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fund"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"expirationDate" ascending:TRUE]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fund";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Fund *fund = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", fund.balance];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@)", fund.originalFlight.origin, fund.originalFlight.destination, fund.originalFlight.outboundDepartureDate];
    return cell;
}



@end
