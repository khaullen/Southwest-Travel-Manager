//
//  DataEntryTableViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/28/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryCell.h"

@class DataEntryTableViewController;

@protocol DataEntryDelegate <NSObject>

- (void)dataEntryTableViewController:(DataEntryTableViewController *)sender didEnterData:(NSDictionary *)data;

@end

@interface DataEntryTableViewController : UITableViewController <DataEntryCellDelegate>

@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) NSDictionary *placeholders;
@property (strong, nonatomic) NSDictionary *details;
@property (strong, nonatomic) NSDictionary *keyboardTypes;

@property (weak, nonatomic) id <DataEntryDelegate> delegate;

@end
