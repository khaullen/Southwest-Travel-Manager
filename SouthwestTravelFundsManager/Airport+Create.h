//
//  Airport+Create.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "Airport.h"

@interface Airport (Create)

+ (Airport *)airportWithDictionary:(NSDictionary *)airportInfo inManagedObjectContext:(NSManagedObjectContext *)context;

#define AIRPORT_CODE @"airportCode"
#define CITY @"city"
#define STATE @"state"

@end
