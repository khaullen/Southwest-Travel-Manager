//
//  Flight.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/19/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fund;

@interface Flight : NSManagedObject

@property (nonatomic, retain) NSDate * outboundDepartureDate;
@property (nonatomic, retain) NSDecimalNumber * cost;
@property (nonatomic, retain) NSString * confirmationCode;
@property (nonatomic, retain) NSDate * bookingDate;
@property (nonatomic, retain) NSString * fareType;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) NSNumber * ticketNumber;
@property (nonatomic, retain) NSNumber * outboundFlightNumber;
@property (nonatomic, retain) NSNumber * returnFlightNumber;
@property (nonatomic, retain) NSString * passengerFirstName;
@property (nonatomic, retain) NSString * passengerLastName;
@property (nonatomic, retain) NSString * passengerMiddleName;
@property (nonatomic, retain) NSNumber * rapidRewardsNumber;
@property (nonatomic, retain) NSNumber * pointsEarned;
@property (nonatomic, retain) NSDate * outboundArrivalDate;
@property (nonatomic, retain) NSDate * returnDepartureDate;
@property (nonatomic, retain) NSDate * returnArrivalDate;
@property (nonatomic, retain) NSNumber * cancelled;
@property (nonatomic, retain) NSNumber * used;
@property (nonatomic, retain) NSSet *fundsUsed;
@property (nonatomic, retain) Fund *travelFund;
@end

@interface Flight (CoreDataGeneratedAccessors)

- (void)addFundsUsedObject:(Fund *)value;
- (void)removeFundsUsedObject:(Fund *)value;
- (void)addFundsUsed:(NSSet *)values;
- (void)removeFundsUsed:(NSSet *)values;

@end
