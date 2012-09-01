//
//  FundSelectionTableViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/31/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fund+Create.h"
#import "Flight+Create.h"
#import "DateAndCurrencyFormatter.h"

@class FundSelectionTableViewController;

@protocol FundSelectionDelegate <NSObject>

- (void)fundSelectionTableViewController:(FundSelectionTableViewController *)sender didSelectFunds:(NSDictionary *)appliedFunds withExpirationDate:(NSDate *)expirationDate;

@end

@interface FundSelectionTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *travelFunds;
@property (nonatomic, strong) NSString *flightDetails;
@property (nonatomic, strong) NSNumber *flightCost;
@property (nonatomic, strong) NSMutableDictionary *appliedFunds;
@property (nonatomic) double remainingBalance;

@property (nonatomic, strong) DateAndCurrencyFormatter *formatter;
@property (nonatomic, weak) id <FundSelectionDelegate> delegate;

@end
