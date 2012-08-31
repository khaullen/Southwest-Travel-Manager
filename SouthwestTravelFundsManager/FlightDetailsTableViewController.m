//
//  FlightDetailsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/24/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "FlightDetailsTableViewController.h"

@interface FlightDetailsTableViewController () <UIActionSheetDelegate>

@end

@implementation FlightDetailsTableViewController

@synthesize flight = _flight;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setFlight:(Flight *)flight {
    _flight = flight;
    NSMutableDictionary *flightDetails = [NSMutableDictionary dictionaryWithCapacity:10];
    if (flight.origin) [flightDetails setObject:[NSDictionary dictionaryWithObjectsAndKeys:flight.origin.airportCode, AIRPORT_CODE, flight.origin.city, CITY, flight.origin.state, STATE, flight.origin.timeZone, TIME_ZONE, nil] forKey:ORIGIN];
    if (flight.destination) [flightDetails setObject:[NSDictionary dictionaryWithObjectsAndKeys:flight.destination.airportCode, AIRPORT_CODE, flight.destination.city, CITY, flight.destination.state, STATE, flight.destination.timeZone, TIME_ZONE, nil] forKey:DESTINATION];
    if (flight.confirmationCode) [flightDetails setObject:flight.confirmationCode forKey:CONFIRMATION_CODE];
    if (flight.cost) [flightDetails setObject:flight.cost forKey:COST];
    if (flight.travelFund.expirationDate) [flightDetails setObject:flight.travelFund.expirationDate forKey:EXPIRATION_DATE];
    if (flight.roundtrip) [flightDetails setObject:flight.roundtrip forKey:ROUNDTRIP];
    if (flight.outboundDepartureDate) [flightDetails setObject:flight.outboundDepartureDate forKey:OUTBOUND_DEPARTURE_DATE];
    if (flight.returnDepartureDate) [flightDetails setObject:flight.returnDepartureDate forKey:RETURN_DEPARTURE_DATE];
    if (flight.checkInReminder) [flightDetails setObject:flight.checkInReminder forKey:CHECK_IN_REMINDER];
    if (flight.notes) [flightDetails setObject:flight.notes forKey:NOTES];
    self.fieldData = flightDetails;
}

- (IBAction)actionPressed:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Cancel Flight" otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self.delegate flightDetailsTableViewController:self didCancelFlight:self.flight];
    }
}

- (void)airportPickerViewController:(AirportPickerViewController *)airportPickerVC selectedOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination {
    if ([(NSString *)[origin objectForKey:AIRPORT_CODE] isEqualToString:[destination objectForKey:AIRPORT_CODE]]) {
        [self selectAnimated:[NSSet setWithObject:DESTINATION] fromRequiredFields:self.flightRequiredFields];
        [self setDataInFields];
    } else {
        [super airportPickerViewController:airportPickerVC selectedOrigin:origin andDestination:destination];
        self.flight.origin = [Airport airportWithDictionary:[self.fieldData objectForKey:ORIGIN] inManagedObjectContext:self.flight.managedObjectContext];
        self.flight.destination = [Airport airportWithDictionary:[self.fieldData objectForKey:DESTINATION] inManagedObjectContext:self.flight.managedObjectContext];
        [DatabaseHelper saveDatabase];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *field;
    if ([textField isEqual:self.confirmTextField]) field = CONFIRMATION_CODE;
    if ([textField isEqual:self.costTextField]) field = COST;
    if ([textField isEqual:self.notesTextField]) field = NOTES;
    if ([self isInvalid:field]) {
        [self selectAnimated:[NSSet setWithObject:field] fromRequiredFields:self.flightRequiredFields];
        [self setDataInFields];
    } else {
        [super textFieldDidEndEditing:textField];
        if ([field isEqualToString:CONFIRMATION_CODE]) self.flight.confirmationCode = [self.fieldData objectForKey:CONFIRMATION_CODE];
        if ([field isEqualToString:COST]) self.flight.cost = [self.fieldData objectForKey:COST];
        if ([field isEqualToString:NOTES]) self.flight.notes = [self.fieldData objectForKey:NOTES];
        [DatabaseHelper saveDatabase];
    }
    
}

- (void)datePickerDidEndEditing:(UIDatePicker *)sender {
    NSString *field;
    if ([sender isEqual:self.expirationDatePicker]) field = EXPIRATION_DATE;
    if ([sender isEqual:self.outboundDatePicker]) field = OUTBOUND_DEPARTURE_DATE;
    if ([sender isEqual:self.returnDatePicker]) field = RETURN_DEPARTURE_DATE;
    if ([self isInvalid:field]) {
        [self selectAnimated:[NSSet setWithObject:field] fromRequiredFields:self.flightRequiredFields];
        [self setDataInFields];
    } else {
        [super datePickerDidEndEditing:sender];
        if ([field isEqualToString:EXPIRATION_DATE]) self.flight.travelFund.expirationDate = [self.fieldData objectForKey:EXPIRATION_DATE];
        if ([field isEqualToString:OUTBOUND_DEPARTURE_DATE]) self.flight.outboundDepartureDate = [self.fieldData objectForKey:OUTBOUND_DEPARTURE_DATE];
        if ([field isEqualToString:RETURN_DEPARTURE_DATE]) self.flight.returnDepartureDate = [self.fieldData objectForKey:RETURN_DEPARTURE_DATE];
        [DatabaseHelper saveDatabase];
    }
}

- (void)switchDidEndEditing:(UISwitch *)sender {
    [super switchDidEndEditing:sender];
    if ([sender isEqual:self.roundtripSwitch]) {
        self.flight.roundtrip = [self.fieldData objectForKey:ROUNDTRIP];
        if (!sender.on) self.flight.returnDepartureDate = nil;
    } else if ([sender isEqual:self.checkInReminderSwitch]) {
        self.flight.checkInReminder = [self.fieldData objectForKey:CHECK_IN_REMINDER];
    }
    [DatabaseHelper saveDatabase];
}

@end
