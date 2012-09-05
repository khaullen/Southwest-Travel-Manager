//
//  NewFlightTableViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericDataInputTableViewController.h"
#import "FundSelectionTableViewController.h"

@class NewFlightTableViewController;

@protocol NewFlightDelegate <NSObject>

- (void)newFlightTableViewController:(NewFlightTableViewController *)sender didEnterFlightInformation:(NSDictionary *)flightInfo;

@end

@interface NewFlightTableViewController : GenericDataInputTableViewController <FundSelectionDelegate>

@property (nonatomic, weak) id <NewFlightDelegate> delegate;
@property (nonatomic, weak) NSManagedObjectContext *context;

@end