//
//  FundDetailsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "FundDetailsTableViewController.h"

@implementation FundDetailsTableViewController

@synthesize fund = _fund;

- (void)setFund:(Fund *)fund {
    _fund = fund;
    NSMutableDictionary *fundDetails = [NSMutableDictionary dictionaryWithCapacity:10];
    if (fund.originalFlight.origin) [fundDetails setObject:[NSDictionary dictionaryWithObjectsAndKeys:fund.originalFlight.origin.airportCode, AIRPORT_CODE, fund.originalFlight.origin.city, CITY, fund.originalFlight.origin.state, STATE, fund.originalFlight.origin.timeZone, TIME_ZONE, nil] forKey:ORIGIN];
    if (fund.originalFlight.destination) [fundDetails setObject:[NSDictionary dictionaryWithObjectsAndKeys:fund.originalFlight.destination.airportCode, AIRPORT_CODE, fund.originalFlight.destination.city, CITY, fund.originalFlight.destination.state, STATE, fund.originalFlight.destination.timeZone, TIME_ZONE, nil] forKey:DESTINATION];
    if (fund.originalFlight.confirmationCode) [fundDetails setObject:fund.originalFlight.confirmationCode forKey:CONFIRMATION_CODE];
    if (fund.balance) [fundDetails setObject:fund.balance forKey:COST];
    if (fund.expirationDate) [fundDetails setObject:fund.expirationDate forKey:EXPIRATION_DATE];
    if (fund.unusedTicket) [fundDetails setObject:fund.unusedTicket forKey:UNUSED_TICKET];
    if (fund.notes) [fundDetails setObject:fund.notes forKey:NOTES];
    self.fieldData = fundDetails;
}

- (void)airportPickerViewController:(AirportPickerViewController *)airportPickerVC selectedOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination {
    [super airportPickerViewController:airportPickerVC selectedOrigin:origin andDestination:destination];
    self.fund.originalFlight.origin = [Airport airportWithDictionary:[self.fieldData objectForKey:ORIGIN] inManagedObjectContext:self.fund.managedObjectContext];
    self.fund.originalFlight.destination = [Airport airportWithDictionary:[self.fieldData objectForKey:DESTINATION] inManagedObjectContext:self.fund.managedObjectContext];
    [DatabaseHelper saveDatabase];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *field;
    if ([textField isEqual:self.confirmTextField]) field = CONFIRMATION_CODE;
    if ([textField isEqual:self.costTextField]) field = COST;
    if ([textField isEqual:self.notesTextField]) field = NOTES;
    if ([self isInvalid:field]) {
        [self selectAnimated:[NSSet setWithObject:field] fromRequiredFields:self.fundRequiredFields];
        [self setDataInFields];
    } else {
        [super textFieldDidEndEditing:textField];
        if ([field isEqualToString:CONFIRMATION_CODE]) self.fund.originalFlight.confirmationCode = [self.fieldData objectForKey:CONFIRMATION_CODE];
        if ([field isEqualToString:COST]) self.fund.balance = [self.fieldData objectForKey:COST];
        if ([field isEqualToString:NOTES]) self.fund.notes = [self.fieldData objectForKey:NOTES];
        [DatabaseHelper saveDatabase];
    }
    
}

- (void)datePickerDidEndEditing:(UIDatePicker *)sender {
    NSString *field;
    if ([sender isEqual:self.expirationDatePicker]) field = EXPIRATION_DATE;
    if ([self isInvalid:field]) {
        [self selectAnimated:[NSSet setWithObject:field] fromRequiredFields:self.fundRequiredFields];
        [self setDataInFields];
    } else {
        [super datePickerDidEndEditing:sender];
        if ([field isEqualToString:EXPIRATION_DATE]) self.fund.expirationDate = [self.fieldData objectForKey:EXPIRATION_DATE];
        [DatabaseHelper saveDatabase];
    }
}

- (void)switchDidEndEditing:(UISwitch *)sender {
    [super switchDidEndEditing:sender];
    if ([sender isEqual:self.unusedTicketSwitch]) {
        self.fund.unusedTicket = [self.fieldData objectForKey:UNUSED_TICKET];
    }
    [DatabaseHelper saveDatabase];
}

@end
