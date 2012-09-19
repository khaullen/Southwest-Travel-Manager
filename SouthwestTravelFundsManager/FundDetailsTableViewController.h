//
//  FundDetailsTableViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericFundTableViewController.h"
#import "Flight+Create.h"
#import "Fund+Create.h"
#import "Airport+Create.h"

@interface FundDetailsTableViewController : GenericFundTableViewController

@property (nonatomic, strong) Fund *fund;

@end
