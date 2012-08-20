//
//  TravelFundsTableViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface TravelFundsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *database;

@end

/*

 Database creation:
 
 First time the app runs (a database doesn't exist yet), we'll create an empty one in the documents directory.
 
*/