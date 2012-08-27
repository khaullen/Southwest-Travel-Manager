//
//  Airport.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight;

@interface Airport : NSManagedObject

@property (nonatomic, retain) NSString * airportCode;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSSet *originFlights;
@property (nonatomic, retain) NSSet *destinationFlights;
@end

@interface Airport (CoreDataGeneratedAccessors)

- (void)addOriginFlightsObject:(Flight *)value;
- (void)removeOriginFlightsObject:(Flight *)value;
- (void)addOriginFlights:(NSSet *)values;
- (void)removeOriginFlights:(NSSet *)values;

- (void)addDestinationFlightsObject:(Flight *)value;
- (void)removeDestinationFlightsObject:(Flight *)value;
- (void)addDestinationFlights:(NSSet *)values;
- (void)removeDestinationFlights:(NSSet *)values;

@end
