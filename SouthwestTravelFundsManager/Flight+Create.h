//
//  Flight+Create.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/19/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "Flight.h"

@interface Flight (Create)

+ (Flight *)flightWithDictionary:(NSDictionary *)flightInfo inManagedObjectContext:(NSManagedObjectContext *)context;

#define BOOKING_DATE @"bookingDate"
#define CANCELLED @"cancelled"
#define CHECK_IN_REMINDER @"checkInReminder"
#define CONFIRMATION_CODE @"confirmationCode"
#define COST @"cost"
#define DESTINATION @"destination"
#define FARE_TYPE @"fareType"
#define FLIGHT_NOTES @"notes"
#define ORIGIN @"origin"
#define OUTBOUND_ARRIVAL_DATE @"outboundArrivalDate"
#define OUTBOUND_DEPARTURE_DATE @"outboundDepartureDate"
#define OUTBOUND_FLIGHT_NUMBER @"outboundFlightNumber"
#define POINTS_EARNED @"pointsEarned"
#define RETURN_ARRIVAL_DATE @"returnArrivalDate"
#define RETURN_DEPARTURE_DATE @"returnDepartureDate"
#define RETURN_FLIGHT_NUMBER @"returnFlightNumber"
#define ROUNDTRIP @"roundtrip"
#define TICKET_NUMBER @"ticketNumber"
#define USED @"used"

@end
