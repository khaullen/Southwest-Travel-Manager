//
//  Flight+Create.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/19/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "Flight+Create.h"
#import "Fund+Create.h"
#import "Airport+Create.h"

@interface Flight (Private)

+ (Flight *)flight:(NSDictionary *)flightInfo inDatabase:(NSManagedObjectContext *)context;
+ (Flight *)createNewFlight:(NSDictionary *)flightInfo inDatabase:(NSManagedObjectContext *)context;

@end

@implementation Flight (Create)

+ (Flight *)flightWithDictionary:(NSDictionary *)flightInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    // check for duplicate flight in database
    Flight *flight = [self flight:flightInfo inDatabase:context];
    if (!flight) flight = [self createNewFlight:flightInfo inDatabase:context];
    return flight;
}

+ (Flight *)flightWithFundInfo:(NSDictionary *)fundInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    Flight *newFlight = [NSEntityDescription insertNewObjectForEntityForName:@"Flight" inManagedObjectContext:context];
    newFlight.origin = [Airport airportWithDictionary:[fundInfo objectForKey:ORIGIN] inManagedObjectContext:context];
    newFlight.destination = [Airport airportWithDictionary:[fundInfo objectForKey:DESTINATION] inManagedObjectContext:context];
    newFlight.confirmationCode = [fundInfo objectForKey:CONFIRMATION_CODE];
    if ([[fundInfo objectForKey:UNUSED_TICKET] boolValue]) newFlight.cost = [fundInfo objectForKey:COST];
    newFlight.cancelled = [NSNumber numberWithBool:TRUE];
    return newFlight;
}

+ (Flight *)flight:(NSDictionary *)flightInfo inDatabase:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
    request.predicate = [NSPredicate predicateWithFormat:@"confirmationCode = %@ AND outboundDepartureDate = %@", [flightInfo objectForKey:CONFIRMATION_CODE], [flightInfo objectForKey:OUTBOUND_DEPARTURE_DATE]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:TICKET_NUMBER ascending:TRUE]];

    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        // handle error
        return nil;
    }
    return [matches lastObject];
}

+ (Flight *)createNewFlight:(NSDictionary *)flightInfo inDatabase:(NSManagedObjectContext *)context {
    Flight *newFlight = [NSEntityDescription insertNewObjectForEntityForName:@"Flight" inManagedObjectContext:context];

    // populate flight attributes
    
    newFlight.origin = [Airport airportWithDictionary:[flightInfo objectForKey:ORIGIN] inManagedObjectContext:context];
    newFlight.destination = [Airport airportWithDictionary:[flightInfo objectForKey:DESTINATION] inManagedObjectContext:context];
    newFlight.confirmationCode = [flightInfo objectForKey:CONFIRMATION_CODE];
    newFlight.cost = [flightInfo objectForKey:COST];
    newFlight.travelFund = [Fund fundWithExpirationDate:[flightInfo objectForKey:EXPIRATION_DATE] inManagedObjectContext:context];
    newFlight.roundtrip = [flightInfo objectForKey:ROUNDTRIP];
    newFlight.outboundDepartureDate = [flightInfo objectForKey:OUTBOUND_DEPARTURE_DATE];
    newFlight.returnDepartureDate = [flightInfo objectForKey:RETURN_DEPARTURE_DATE];
    newFlight.checkInReminder = [flightInfo objectForKey:CHECK_IN_REMINDER];
    newFlight.notes = [flightInfo objectForKey:NOTES];
    newFlight.cancelled = [NSNumber numberWithBool:FALSE];
    
    // modify funds used balances
    
    NSMutableSet *fundsUsed = [NSMutableSet set];
    for (NSArray *array in [[flightInfo objectForKey:FUNDS_USED] allValues]) {
        Fund *fund = array.lastObject;
        double amountApplied = [[array objectAtIndex:0] doubleValue];
        fund.balance = [NSNumber numberWithDouble:[fund.balance doubleValue] - amountApplied];
        if (amountApplied) fund.unusedTicket = [NSNumber numberWithBool:FALSE];
        [fundsUsed addObject:fund];
    }
    newFlight.fundsUsed = [fundsUsed copy];
    
    return newFlight;
}


@end
