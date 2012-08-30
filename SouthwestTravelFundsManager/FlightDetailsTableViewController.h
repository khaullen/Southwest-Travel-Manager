//
//  FlightDetailsTableViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/24/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericDataInputTableViewController.h"
#import "Flight+Create.h"
#import "Fund+Create.h"
#import "Airport+Create.h"

@class FlightDetailsTableViewController;

@protocol FlightDetailsDelegate <NSObject>

- (void)flightDetailsTableViewController:(FlightDetailsTableViewController *)sender didCancelFlight:(Flight *)flight;

@end

@interface FlightDetailsTableViewController : GenericDataInputTableViewController

@property (nonatomic, strong) Flight *flight;
@property (nonatomic, weak) id <FlightDetailsDelegate> delegate;

@end

// TODO: Add editing capability

// TODO: Add field validation on pressing back button