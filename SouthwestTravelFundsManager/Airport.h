//
//  Airport.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/24/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight;

@interface Airport : NSManagedObject

@property (nonatomic, retain) NSString * airportCode;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * timeZone;
@property (nonatomic, retain) NSSet *destinationFlights;
@property (nonatomic, retain) NSSet *originFlights;
@end

@interface Airport (CoreDataGeneratedAccessors)

- (void)addDestinationFlightsObject:(Flight *)value;
- (void)removeDestinationFlightsObject:(Flight *)value;
- (void)addDestinationFlights:(NSSet *)values;
- (void)removeDestinationFlights:(NSSet *)values;

- (void)addOriginFlightsObject:(Flight *)value;
- (void)removeOriginFlightsObject:(Flight *)value;
- (void)addOriginFlights:(NSSet *)values;
- (void)removeOriginFlights:(NSSet *)values;

@end
