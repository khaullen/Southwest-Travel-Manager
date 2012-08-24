//
//  UpcomingFlightsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/17/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "UpcomingFlightsTableViewController.h"
#import "Flight+Create.h"
#import "Fund.h"
#import "NewFlightTableViewController.h"

@interface UpcomingFlightsTableViewController () <NewFlightDelegate>

@end

@implementation UpcomingFlightsTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newFlight"]) {
        NewFlightTableViewController *newFlight = (NewFlightTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        newFlight.delegate = self;
    }
}

- (void)newFlightTableViewController:(NewFlightTableViewController *)sender didEnterFlightInformation:(NSDictionary *)flightInfo {
    [Flight flightWithDictionary:flightInfo inManagedObjectContext:self.database.managedObjectContext];
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)setupFetchedResultsController {
    [super setupFetchedResultsController];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"outboundDepartureDate" ascending:TRUE]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"flight";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Flight *flight = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@)", flight.origin, flight.destination, flight.outboundDepartureDate];
    cell.detailTextLabel.text = flight.confirmationCode;
    return cell;
}

@end
