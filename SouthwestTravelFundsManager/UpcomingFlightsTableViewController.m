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

@interface UpcomingFlightsTableViewController () <NewFlightDelegate, FlightDetailsDelegate>

- (void)addLocalNotificationForFlight:(Flight *)flight withInfo:(NSDictionary *)flightInfo atDate:(NSDate *)departureDate returnFlight:(BOOL)returnFlight;

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
        flightDetails.delegate = self;
        flightDetails.formatter = self.formatter;
    }
}

- (void)newFlightTableViewController:(NewFlightTableViewController *)sender didEnterFlightInformation:(NSDictionary *)flightInfo {
    Flight *flight = [Flight flightWithDictionary:flightInfo inManagedObjectContext:self.database.managedObjectContext];
    [DatabaseHelper saveDatabase];
    if (flight.checkInReminder) {
        [self addLocalNotificationForFlight:flight withInfo:flightInfo atDate:flight.outboundDepartureDate returnFlight:FALSE];
        if (flight.roundtrip) [self addLocalNotificationForFlight:flight withInfo:flightInfo atDate:flight.returnDepartureDate returnFlight:TRUE];
    }
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)flightDetailsTableViewController:(FlightDetailsTableViewController *)sender didCancelFlight:(Flight *)flight {
    flight.cancelled = [NSNumber numberWithBool:TRUE];
    flight.travelFund.balance = flight.cost;
    flight.travelFund.unusedTicket = [NSNumber numberWithBool:TRUE];
    flight.travelFund.notes = flight.notes;
    [DatabaseHelper saveDatabase];
    [self.navigationController popViewControllerAnimated:TRUE];
}

#define FLIGHT_CHECK_IN_ALERT_BODY @"Check in for your Southwest flight from %@ to %@, confirmation #%@"

- (void)addLocalNotificationForFlight:(Flight *)flight 
                             withInfo:(NSDictionary *)flightInfo 
                               atDate:(NSDate *)departureDate 
                         returnFlight:(BOOL)returnFlight{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeInterval:-(60*60*24 + 90) sinceDate:departureDate];
    NSString *origin = [NSString stringWithFormat:@"%@, %@", flight.origin.city, flight.origin.state];
    NSString *destination = [NSString stringWithFormat:@"%@, %@", flight.destination.city, flight.destination.state];
    localNotification.alertBody = [NSString stringWithFormat:FLIGHT_CHECK_IN_ALERT_BODY, returnFlight ? destination : origin, returnFlight ? origin : destination, flight.confirmationCode];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.userInfo = flightInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)setupFetchedResultsController {
    [super setupFetchedResultsController];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"outboundDepartureDate" ascending:TRUE]];
    request.predicate = [NSPredicate predicateWithFormat:@"((outboundDepartureDate > %@) OR (returnDepartureDate > %@)) AND (cancelled == NO)", [NSDate date], [NSDate date]];
    
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
