//
//  AboutViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/28/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryTableViewController.h"
#import <MessageUI/MessageUI.h>

@class AboutViewController;

@protocol AboutViewControllerDelegate <NSObject>

- (void)aboutViewControllerDidReturn:(AboutViewController *)sender;

@end

@interface AboutViewController : UITableViewController <DataEntryDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cellBackground;
@property (weak, nonatomic) IBOutlet UITableViewCell *versionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *accountNumberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *tellAFriendCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailSupportCell;

@property (nonatomic) NSString *appVersion;
@property (nonatomic) NSDictionary *passengerName;
@property (nonatomic) NSDictionary *passengerAccountNumber;

@property (nonatomic, weak) id <AboutViewControllerDelegate> delegate;

@end
