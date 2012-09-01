//
//  Fund+Create.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/19/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "Fund+Create.h"
#import "Flight+Create.h"

@interface Fund (Private)

+ (Fund *)fund:(NSDictionary *)fundInfo inDatabase:(NSManagedObjectContext *)context;
+ (Fund *)createNewFund:(NSDictionary *)fundInfo inDatabase:(NSManagedObjectContext *)context;

@end

@implementation Fund (Create)

+ (Fund *)fundWithDictionary:(NSDictionary *)fundInfo inManagedObjectContext:(NSManagedObjectContext *)context {
    Fund *fund = [self fund:fundInfo inDatabase:context];
    if (!fund) fund = [self createNewFund:fundInfo inDatabase:context];
    return fund;
}

+ (Fund *)fundWithExpirationDate:(NSDate *)expirationDate inManagedObjectContext:(NSManagedObjectContext *)context {
    Fund *newFund = [NSEntityDescription insertNewObjectForEntityForName:@"Fund" inManagedObjectContext:context];
    newFund.expirationDate = expirationDate;
    return newFund;
}

+ (Fund *)fund:(NSDictionary *)fundInfo inDatabase:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fund"];
    request.predicate = [NSPredicate predicateWithFormat:@"originalFlight.confirmationCode = %@ AND expirationDate = %@", [fundInfo objectForKey:CONFIRMATION_CODE], [fundInfo objectForKey:EXPIRATION_DATE]];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"balance" ascending:TRUE]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || matches.count > 1) {
        // handle error
        return nil;
    }
    return [matches lastObject];
}

+ (Fund *)createNewFund:(NSDictionary *)fundInfo inDatabase:(NSManagedObjectContext *)context {
    Fund *newFund = [NSEntityDescription insertNewObjectForEntityForName:@"Fund" inManagedObjectContext:context];
    
    // populate fund attributes
    
    newFund.originalFlight = [Flight flightWithFundInfo:fundInfo inManagedObjectContext:context];
    newFund.balance = [fundInfo objectForKey:COST];
    newFund.expirationDate = [fundInfo objectForKey:EXPIRATION_DATE];
    newFund.notes = [fundInfo objectForKey:NOTES];
    newFund.unusedTicket = [fundInfo objectForKey:UNUSED_TICKET];
    
    return newFund;
}

@end
