//
//  FlightDetailsTableViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/24/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericFlightTableViewController.h"
#import "Flight+Create.h"
#import "Fund+Create.h"
#import "Airport+Create.h"

@interface FlightDetailsTableViewController : GenericFlightTableViewController

@property (nonatomic, strong) Flight *flight;

@end

// TODO: Add editing capability

// TODO: Add field validation on pressing back button

// TODO: add cancel flight button

// TODO: think about adding rebook flight button