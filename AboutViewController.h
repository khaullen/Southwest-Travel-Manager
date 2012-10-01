//
//  AboutViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/28/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *cellBackground;
@property (weak, nonatomic) IBOutlet UITableViewCell *version;
@property (weak, nonatomic) IBOutlet UITableViewCell *name;
@property (weak, nonatomic) IBOutlet UITableViewCell *accountNumber;

@end
