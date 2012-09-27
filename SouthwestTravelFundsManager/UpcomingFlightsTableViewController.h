//
//  UpcomingFlightsTableViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/17/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "DateAndCurrencyFormatter.h"
#import "Flight+Create.h"

@interface UpcomingFlightsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) DateAndCurrencyFormatter *formatter;

- (NSDictionary *)flurryParametersForFlight:(Flight *)flight;

@end
