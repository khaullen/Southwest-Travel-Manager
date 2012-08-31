//
//  FundSelectionTableViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/31/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fund.h"
#import "Flight.h"
#import "DateAndCurrencyFormatter.h"

@interface FundSelectionTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *travelFunds;
@property (nonatomic, strong) NSString *flightDetails;
@property (nonatomic, strong) NSNumber *flightCost;
@property (nonatomic, strong) NSMutableDictionary *appliedFunds;
@property (nonatomic) double remainingBalance;

@property (nonatomic, strong) DateAndCurrencyFormatter *formatter;

@end
