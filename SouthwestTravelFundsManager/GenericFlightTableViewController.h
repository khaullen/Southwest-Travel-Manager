//
//  GenericFlightTableViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/18/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericDataInputTableViewController.h"
#import "Flight+Create.h"
#import "Fund+Create.h"

@interface GenericFlightTableViewController : GenericDataInputTableViewController

@property (nonatomic, readonly) NSDictionary *flightRequiredFields;

@end
