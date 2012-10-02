//
//  AboutViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/28/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryTableViewController.h"

@interface AboutViewController : UITableViewController <DataEntryDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cellBackground;
@property (weak, nonatomic) IBOutlet UITableViewCell *versionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *accountNumberCell;

@property (nonatomic) NSDictionary *passengerName;
@property (nonatomic) NSDictionary *passengerAccountNumber;

@end
