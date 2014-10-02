//
//  UpcomingFlightsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/17/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "UpcomingFlightsTableViewController.h"
#import "Fund.h"
#import "Airport.h"
#import "NewFlightTableViewController.h"
#import "FlightDetailsTableViewController.h"

@interface UpcomingFlightsTableViewController () <NewFlightDelegate, FlightDetailsDelegate>

- (void)addLocalNotificationsForFlight:(Flight *)flight withInfo:(NSDictionary *)flightInfo;
- (void)removeLocalNotificationsForFlight:(Flight *)flight;

@end

@implementation UpcomingFlightsTableViewController

@synthesize formatter = _formatter;

#pragma mark - Initialization

- (DateAndCurrencyFormatter *)formatter {
    if (!_formatter) _formatter = [[DateAndCurrencyFormatter alloc] init];
    return _formatter;
}

#pragma mark - Table view setup

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"segueToNewFlight"]) {
        NewFlightTableViewController *newFlight = (NewFlightTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
        newFlight.delegate = self;
        newFlight.formatter = self.formatter;
        newFlight.context = self.database.managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"segueToDetail"]) {
        FlightDetailsTableViewController *flightDetails = (FlightDetailsTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        flightDetails.flight = [self.fetchedResultsController objectAtIndexPath:indexPath];
        flightDetails.delegate = self;
        flightDetails.formatter = self.formatter;
    }
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Flight *flight = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self removeLocalNotificationsForFlight:flight];
    }
    [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

#pragma mark - Delegate methods

- (void)newFlightTableViewController:(NewFlightTableViewController *)sender didEnterFlightInformation:(NSDictionary *)flightInfo {
    Flight *flight = [Flight flightWithDictionary:flightInfo inManagedObjectContext:self.database.managedObjectContext];
    [DatabaseHelper saveDatabase];
    if (flight.checkInReminder.boolValue) [self addLocalNotificationsForFlight:flight withInfo:flightInfo];
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)flightDetailsTableViewController:(FlightDetailsTableViewController *)sender didCancelFlight:(Flight *)flight {
    flight.cancelled = [NSNumber numberWithBool:TRUE];
    flight.travelFund.balance = flight.cost;
    flight.travelFund.unusedTicket = [NSNumber numberWithBool:TRUE];
    flight.travelFund.notes = flight.notes;    
    [self.navigationController popViewControllerAnimated:TRUE];
    [DatabaseHelper saveDatabase];
    [self removeLocalNotificationsForFlight:flight];
}

- (void)flightDetailsTableViewController:(FlightDetailsTableViewController *)sender didModifyNotificationParametersForFlight:(Flight *)flight withInfo:(NSDictionary *)flightInfo {
    [self removeLocalNotificationsForFlight:flight];
    if (flight.checkInReminder.boolValue) [self addLocalNotificationsForFlight:flight withInfo:flightInfo];
}

#pragma mark - Local Notification Scheduling

#define FLIGHT_CHECK_IN_ALERT_BODY @"Check in for your Southwest flight from %@ to %@, confirmation #%@"

- (void)addLocalNotificationsForFlight:(Flight *)flight withInfo:(NSDictionary *)flightInfo {
    for (int outbound = 1; outbound >= 1 - flight.roundtrip.intValue; outbound--) {
        NSDate *departureDate = outbound ? flight.outboundDepartureDate : flight.returnDepartureDate;
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeInterval:-(60*60*24 + 90) sinceDate:departureDate];
        NSString *origin = [NSString stringWithFormat:@"%@, %@", flight.origin.city, flight.origin.state];
        NSString *destination = [NSString stringWithFormat:@"%@, %@", flight.destination.city, flight.destination.state];
        localNotification.alertBody = [NSString stringWithFormat:FLIGHT_CHECK_IN_ALERT_BODY, outbound ? origin : destination, outbound ? destination : origin, flight.confirmationCode];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        NSMutableDictionary *mutableFlightInfo = [flightInfo mutableCopy];
        [mutableFlightInfo removeObjectForKey:FUNDS_USED];
        localNotification.userInfo = [mutableFlightInfo copy];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (void)removeLocalNotificationsForFlight:(Flight *)flight {
    UIApplication *application = [UIApplication sharedApplication];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
    for (UILocalNotification *notification in application.scheduledLocalNotifications) {
        if ([[notification.userInfo objectForKey:CONFIRMATION_CODE] isEqualToString:flight.confirmationCode]) [array addObject:notification];
    }
    for (UILocalNotification *notification in array) {
        [application cancelLocalNotification:notification];
    }
}

#pragma mark - Flurry helper code

- (NSDictionary *)flurryParametersForFlight:(Flight *)flight {
    NSArray *keys = [NSArray arrayWithObjects:ORIGIN, DESTINATION, OUTBOUND_DEPARTURE_DATE, RETURN_DEPARTURE_DATE, CONFIRMATION_CODE, COST, EXPIRATION_DATE, CHECK_IN_REMINDER, NOTES, nil];
    NSArray *objects = [NSArray arrayWithObjects:flight.origin.airportCode, flight.destination.airportCode, [self.formatter stringForDate:flight.outboundDepartureDate withFormat:DATE_TIME_FORMAT inTimeZone:[NSTimeZone timeZoneWithName:flight.origin.timeZone]], flight.roundtrip.boolValue ? [self.formatter stringForDate:flight.returnDepartureDate withFormat:DATE_TIME_FORMAT inTimeZone:[NSTimeZone timeZoneWithName:flight.destination.timeZone]] : @"", flight.confirmationCode, flight.cost.description, [self.formatter stringForDate:flight.travelFund.expirationDate withFormat:DATE_FORMAT inTimeZone:[NSTimeZone localTimeZone]], flight.checkInReminder.description, flight.notes ? flight.notes : @"", nil];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

@end
