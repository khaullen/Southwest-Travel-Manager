//
//  Fund.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/21/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flight;

@interface Fund : NSManagedObject

@property (nonatomic, retain) NSNumber * balance;
@property (nonatomic, retain) NSDate * expirationDate;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * unusedTicket;
@property (nonatomic, retain) Flight *originalFlight;
@property (nonatomic, retain) NSSet *flightsAppliedTo;
@end

@interface Fund (CoreDataGeneratedAccessors)

- (void)addFlightsAppliedToObject:(Flight *)value;
- (void)removeFlightsAppliedToObject:(Flight *)value;
- (void)addFlightsAppliedTo:(NSSet *)values;
- (void)removeFlightsAppliedTo:(NSSet *)values;

@end
