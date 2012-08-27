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
#import "Airport.h"
#import "NewFlightTableViewController.h"
#import "FlightDetailsTableViewController.h"

@interface UpcomingFlightsTableViewController () <NewFlightDelegate>

@end

@implementation UpcomingFlightsTableViewController

@synthesize formatter = _formatter;

- (DateAndCurrencyFormatter *)formatter {
    if (!_formatter) _formatter = [[DateAndCurrencyFormatter alloc] init];
    return _formatter;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToNewFlight"]) {
        NewFlightTableViewController *newFlight = (NewFlightTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        newFlight.delegate = self;
        newFlight.formatter = self.formatter;
    } else if ([segue.identifier isEqualToString:@"segueToDetail"]) {
        FlightDetailsTableViewController *flightDetails = (FlightDetailsTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        flightDetails.flight = [self.fetchedResultsController objectAtIndexPath:indexPath];
        flightDetails.formatter = self.formatter;
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@ - %@, %@", flight.origin.city, flight.origin.state, flight.destination.city, flight.destination.state];
    cell.detailTextLabel.text = [self.formatter stringForDate:flight.outboundDepartureDate withFormat:DAY_DATE_TIME_FORMAT inTimeZone:[NSTimeZone timeZoneWithName:flight.origin.timeZone]];
    return cell;
}

@end
