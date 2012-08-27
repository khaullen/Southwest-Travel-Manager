//
//  Passenger.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight;

@interface Passenger : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) NSNumber * rapidRewardsNumber;
@property (nonatomic, retain) NSSet *flights;
@end

@interface Passenger (CoreDataGeneratedAccessors)

- (void)addFlightsObject:(Flight *)value;
- (void)removeFlightsObject:(Flight *)value;
- (void)addFlights:(NSSet *)values;
- (void)removeFlights:(NSSet *)values;

@end
