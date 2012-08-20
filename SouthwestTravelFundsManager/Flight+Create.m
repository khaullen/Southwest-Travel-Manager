//
//  Flight+Create.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/19/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "Flight+Create.h"

@interface Flight (Private)

+ (Flight *)flight:(NSDictionary *)flightInfo inDatabase:(NSManagedObjectContext *)context;
+ (Flight *)createNewFlight:(NSDictionary *)flightInfo inDatabase:(NSManagedObjectContext *)context;

@end

@implementation Flight (Create)

+ (Flight *)flightWithDictionary:(NSDictionary *)flightInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    Flight *flight = [self flight:flightInfo inDatabase:context];
    if (!flight) flight = [self createNewFlight:flightInfo inDatabase:context];
    return flight;
}

+ (Flight *)flight:(NSDictionary *)flightInfo inDatabase:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
    request.predicate = [NSPredicate predicateWithFormat:@"ticketNumber = %@", [flightInfo objectForKey:@"ticketNumber"]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"ticketNumber" ascending:TRUE]];

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
    
    
    
    return newFlight;
}


@end
