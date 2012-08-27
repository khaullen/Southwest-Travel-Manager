//
//  Airport+Create.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "Airport+Create.h"

@interface Airport (Private)

+ (Airport *)airport:(NSDictionary *)airportInfo inDatabase:(NSManagedObjectContext *)context;
+ (Airport *)createNewAirport:(NSDictionary *)airportInfo inDatabase:(NSManagedObjectContext *)context;

@end

@implementation Airport (Create)

+ (Airport *)airportWithDictionary:(NSDictionary *)airportInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    Airport *airport = [self airport:airportInfo inDatabase:context];
    if (!airport) airport = [self createNewAirport:airportInfo inDatabase:context];
    return airport;
}

+ (Airport *)airport:(NSDictionary *)airportInfo inDatabase:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Airport"];
    request.predicate = [NSPredicate predicateWithFormat:@"airportCode = %@", [airportInfo valueForKeyPath:AIRPORT_CODE]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:AIRPORT_CODE ascending:TRUE]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        // handle error
        return nil;
    }
    return [matches lastObject];
}

+ (Airport *)createNewAirport:(NSDictionary *)airportInfo inDatabase:(NSManagedObjectContext *)context {
    Airport *newAirport = [NSEntityDescription insertNewObjectForEntityForName:@"Airport" inManagedObjectContext:context];
    
    // populate fund attributes
    
    newAirport.airportCode = [airportInfo objectForKey:AIRPORT_CODE];
    newAirport.city = [airportInfo objectForKey:CITY];
    newAirport.state = [airportInfo objectForKey:STATE];
    newAirport.timeZone = [airportInfo objectForKey:TIME_ZONE];
        
    return newAirport;
}

@end
