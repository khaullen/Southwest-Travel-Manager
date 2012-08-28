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
    if (flight.origin) [flightDetails setObject:[NSDictionary dictionaryWithObjectsAndKeys:flight.origin.airportCode, AIRPORT_CODE, flight.origin.city, CITY, flight.origin.state, STATE, flight.origin.timeZone, TIME_ZONE, nil] forKey:ORIGIN];
    if (flight.destination) [flightDetails setObject:[NSDictionary dictionaryWithObjectsAndKeys:flight.destination.airportCode, AIRPORT_CODE, flight.destination.city, CITY, flight.destination.state, STATE, flight.destination.timeZone, TIME_ZONE, nil] forKey:DESTINATION];
    if (flight.confirmationCode) [flightDetails setObject:flight.confirmationCode forKey:CONFIRMATION_CODE];
    if (flight.cost) [flightDetails setObject:flight.cost forKey:COST];
    if (flight.travelFund.expirationDate) [flightDetails setObject:flight.travelFund.expirationDate forKey:EXPIRATION_DATE];
    if (flight.roundtrip) [flightDetails setObject:flight.roundtrip forKey:ROUNDTRIP];
    if (flight.outboundDepartureDate) [flightDetails setObject:flight.outboundDepartureDate forKey:OUTBOUND_DEPARTURE_DATE];
    if (flight.returnDepartureDate) [flightDetails setObject:flight.returnDepartureDate forKey:RETURN_DEPARTURE_DATE];
    if (flight.checkInReminder) [flightDetails setObject:flight.checkInReminder forKey:CHECK_IN_REMINDER];
    if (flight.notes) [flightDetails setObject:flight.notes forKey:FLIGHT_NOTES];
    self.fieldData = flightDetails;
}

@end
