//
//  TravelFundsTableViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "DateAndCurrencyFormatter.h"

@interface TravelFundsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) DateAndCurrencyFormatter *formatter;

@end