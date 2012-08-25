//
//  FlightDetailsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/24/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "FlightDetailsTableViewController.h"

@implementation FlightDetailsTableViewController

@synthesize flight = _flight;

- (void)setFlight:(Flight *)flight {
    _flight = flight;
    NSMutableDictionary *flightDetails = [NSMutableDictionary dictionaryWithCapacity:10];
    if (flight.origin) [flightDetails setObject:flight.origin forKey:ORIGIN];
    if (flight.destination) [flightDetails setObject:flight.destination forKey:DESTINATION];
    if (flight.confirmationCode) [flightDetails setObject:flight.confirmationCode forKey:CONFIRMATION_CODE];
    if (flight.cost) [flightDetails setObject:flight.cost forKey:COST];
    if (flight.travelFund.expirationDate) [flightDetails setObject:flight.travelFund.expirationDate forKey:EXPIRATION_DATE];
    if (flight.roundtrip) [flightDetails setObject:flight.roundtrip forKey:ROUNDTRIP];
    if (flight.outboundDepartureDate) [flightDetails setObject:flight.outboundDepartureDate forKey:OUTBOUND_DEPARTURE_DATE];
    if (flight.returnDepartureDate) [flightDetails setObject:flight.returnDepartureDate forKey:RETURN_DEPARTURE_DATE];
    if (flight.checkInReminder) [flightDetails setObject:flight.checkInReminder forKey:CHECK_IN_REMINDER];
    if (flight.notes) [flightDetails setObject:flight.notes forKey:FLIGHT_NOTES];
    self.flightData = flightDetails;
}

@end
