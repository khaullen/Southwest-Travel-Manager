//
//  Fund+Create.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/19/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "Fund.h"

@interface Fund (Create)

+ (Fund *)fundWithDictionary:(NSDictionary *)fundInfo inManagedObjectContext:(NSManagedObjectContext *)context;

#define BALANCE @"balance"
#define EXPIRATION_DATE @"expirationDate"
#define FUND_NOTES @"notes"
#define UNUSED_TICKET @"unusedTicket"

@end
