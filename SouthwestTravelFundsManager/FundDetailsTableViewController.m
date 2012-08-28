//
//  FundDetailsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "FundDetailsTableViewController.h"

@implementation FundDetailsTableViewController

@synthesize fund = _fund;

- (void)setFund:(Fund *)fund {
    _fund = fund;
    NSMutableDictionary *fundDetails = [NSMutableDictionary dictionaryWithCapacity:10];
    if (fund.originalFlight.origin) [fundDetails setObject:[NSDictionary dictionaryWithObjectsAndKeys:fund.originalFlight.origin.airportCode, AIRPORT_CODE, fund.originalFlight.origin.city, CITY, fund.originalFlight.origin.state, STATE, fund.originalFlight.origin.timeZone, TIME_ZONE, nil] forKey:ORIGIN];
    if (fund.originalFlight.destination) [fundDetails setObject:[NSDictionary dictionaryWithObjectsAndKeys:fund.originalFlight.destination.airportCode, AIRPORT_CODE, fund.originalFlight.destination.city, CITY, fund.originalFlight.destination.state, STATE, fund.originalFlight.destination.timeZone, TIME_ZONE, nil] forKey:DESTINATION];
    if (fund.originalFlight.confirmationCode) [fundDetails setObject:fund.originalFlight.confirmationCode forKey:CONFIRMATION_CODE];
    if (fund.balance) [fundDetails setObject:fund.balance forKey:COST];
    if (fund.expirationDate) [fundDetails setObject:fund.expirationDate forKey:EXPIRATION_DATE];
    if (fund.notes) [fundDetails setObject:fund.notes forKey:NOTES];
    self.fieldData = fundDetails;
}

@end
