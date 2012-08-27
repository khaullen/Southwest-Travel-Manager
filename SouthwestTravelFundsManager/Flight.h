//
//  Flight.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Airport, Fund, Passenger;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSDate * bookingDate;
@property (nonatomic, retain) NSNumber * cancelled;
@property (nonatomic, retain) NSNumber * checkInReminder;
@property (nonatomic, retain) NSString * confirmationCode;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSString * fareType;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * outboundArrivalDate;
@property (nonatomic, retain) NSDate * outboundDepartureDate;
@property (nonatomic, retain) NSNumber * outboundFlightNumber;
@property (nonatomic, retain) NSNumber * pointsEarned;
@property (nonatomic, retain) NSDate * returnArrivalDate;
@property (nonatomic, retain) NSDate * returnDepartureDate;
@property (nonatomic, retain) NSNumber * returnFlightNumber;
@property (nonatomic, retain) NSNumber * roundtrip;
@property (nonatomic, retain) NSNumber * ticketNumber;
@property (nonatomic, retain) Airport *destination;
@property (nonatomic, retain) NSSet *fundsUsed;
@property (nonatomic, retain) Airport *origin;
@property (nonatomic, retain) Passenger *passenger;
@property (nonatomic, retain) Fund *travelFund;
@end

@interface Flight (CoreDataGeneratedAccessors)

- (void)addFundsUsedObject:(Fund *)value;
- (void)removeFundsUsedObject:(Fund *)value;
- (void)addFundsUsed:(NSSet *)values;
- (void)removeFundsUsed:(NSSet *)values;

@end
