//
//  GenericFundTableViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/18/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericDataInputTableViewController.h"
#import "Flight+Create.h"
#import "Fund+Create.h"

@interface GenericFundTableViewController : GenericDataInputTableViewController

@property (nonatomic, readonly) NSDictionary *fundRequiredFields;

- (UITextField *)textFieldForIndexPath:(NSIndexPath *)indexPath;

@end
