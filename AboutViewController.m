//
//  AboutViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/28/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AboutViewController ()

- (void)initializeCellBackground:(UIImageView *)cellBackground;
- (void)initializeDetailText;
- (void)initializeMailCells:(NSArray *)mailCells;
- (NSArray *)detailData;
- (void)prepareDataEntryTVC:(DataEntryTableViewController *)viewController title:(NSString *)title cellLabels:(NSArray *)cellLabels placeholders:(NSDictionary *)placeholders details:(NSDictionary *)details keyboardTypes:(NSDictionary *)keyboardTypes;
- (void)openLink:(NSString *)link withBackup:(NSString *)backupLink;
- (void)presentMailComposeViewControllerTo:(NSString *)recipient subject:(NSString *)subject messageBody:(NSString *)body;

@end

@implementation AboutViewController

@synthesize cellBackground = _cellBackground;
@synthesize versionCell = _versionCell;
@synthesize nameCell = _nameCell;
@synthesize accountNumberCell = _accountNumberCell;
@synthesize tellAFriendCell = _tellAFriendCell;
@synthesize emailSupportCell = _emailSupportCell;
@dynamic passengerName;
@dynamic passengerAccountNumber;
@synthesize delegate = _delegate;

#define PASSENGER_NAME @"Passenger Name"
#define PASSENGER_ACCOUNT_NUMBER @"Account Number"

- (NSDictionary *)passengerName {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:PASSENGER_NAME];
}

- (void)setPassengerName:(NSDictionary *)passengerName {
    [[NSUserDefaults standardUserDefaults] setObject:passengerName forKey:PASSENGER_NAME];
    [self initializeDetailText];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)passengerAccountNumber {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:PASSENGER_ACCOUNT_NUMBER];
}

- (void)setPassengerAccountNumber:(NSDictionary *)passengerAccountNumber {
    [[NSUserDefaults standardUserDefaults] setObject:passengerAccountNumber forKey:PASSENGER_ACCOUNT_NUMBER];
    [self initializeDetailText];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [self initializeCellBackground:self.cellBackground];
    [self initializeDetailText];
    [self initializeMailCells:[NSArray arrayWithObjects:self.tellAFriendCell, self.emailSupportCell, nil]];
}

- (void)initializeCellBackground:(UIImageView *)cellBackground {
    cellBackground.image = [cellBackground.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, cellBackground.image.size.width - 1, 0, 0)];
    cellBackground.layer.masksToBounds = TRUE;
    cellBackground.layer.cornerRadius = 7.0;
}

- (void)initializeDetailText {
    NSArray *cells = [NSArray arrayWithObjects:self.versionCell, self.nameCell, self.accountNumberCell, nil];
    NSArray *details = [self detailData];
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        NSString *detailText = [details objectAtIndex:i];
        cell.detailTextLabel.text = detailText;
    }
}

- (NSArray *)detailData {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *fullName = self.passengerName ? [NSString stringWithFormat:@"%@ %@", [self.passengerName objectForKey:@"First"], [self.passengerName objectForKey:@"Last"]] : @"";
    NSString *acctNumber = self.passengerAccountNumber ? [self.passengerAccountNumber.allValues lastObject] : @"";
    return [NSArray arrayWithObjects:appVersion, fullName, acctNumber, nil];
}

- (void)initializeMailCells:(NSArray *)mailCells {
    if (![MFMailComposeViewController canSendMail]) {
        for (UITableViewCell *cell in mailCells) {
            cell.textLabel.textColor = [UIColor grayColor];
            cell.userInteractionEnabled = FALSE;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToName"]) {
        NSArray *cellLabels = [NSArray arrayWithObjects:@"First", @"Last", nil];
        NSDictionary *details = self.passengerName;
        [self prepareDataEntryTVC:segue.destinationViewController title:PASSENGER_NAME cellLabels:cellLabels placeholders:nil details:details keyboardTypes:nil];
    } else if ([segue.identifier isEqualToString:@"segueToAccountNumber"]) {
        NSArray *cellLabels = [NSArray arrayWithObject:@"Account #"];
        NSDictionary *details = self.passengerAccountNumber;
        NSDictionary *keyboardTypes = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:[NSNumber numberWithInt:UIKeyboardTypeNumberPad]] forKeys:cellLabels];
        [self prepareDataEntryTVC:segue.destinationViewController title:PASSENGER_ACCOUNT_NUMBER cellLabels:cellLabels placeholders:nil details:details keyboardTypes:keyboardTypes];
    }
}

- (void)prepareDataEntryTVC:(DataEntryTableViewController *)viewController
                      title:(NSString *)title
                 cellLabels:(NSArray *)cellLabels
               placeholders:(NSDictionary *)placeholders
                    details:(NSDictionary *)details
              keyboardTypes:(NSDictionary *)keyboardTypes {
    viewController.title = title;
    viewController.labels = cellLabels;
    viewController.placeholders = placeholders;
    viewController.details = details;
    viewController.keyboardTypes = keyboardTypes;
    
    viewController.delegate = self;
}

- (void)dataEntryTableViewController:(DataEntryTableViewController *)sender didEnterData:(NSDictionary *)data {
    if ([sender.title isEqualToString:PASSENGER_NAME]) self.passengerName = data;
    if ([sender.title isEqualToString:PASSENGER_ACCOUNT_NUMBER]) self.passengerAccountNumber = data;
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self.delegate aboutViewControllerDidReturn:self];
}

#define FACEBOOK_LINK @"fb://profile/117102751770408"
#define FACEBOOK_SAFARI_LINK @"http://www.facebook.com/SouthwestTravelManager"
#define ITUNES_LINK @"itms-apps://itunes.apple.com/us/app/sw-travel-manager/id559944769?ls=1&mt=8"
#define MESSAGE_BODY @"Hey check out this app:\n\nhttp://itunes.apple.com/us/app/sw-travel-manager/id559944769?ls=1&mt=8\n\nIt's a utility app for Southwest Airlines travelers that reminds you to check in for upcoming flights and manages your unused travel funds.\n\n\nRegards,\n%@"

#define REVIEW_LINK @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=559944769&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        switch (indexPath.row) {
            case 0: // Facebook
                [self openLink:FACEBOOK_LINK withBackup:FACEBOOK_SAFARI_LINK];
                break;
            case 1: // App store
                [self openLink:REVIEW_LINK withBackup:FACEBOOK_SAFARI_LINK];
                break;
            case 2: // Tell a friend
                [self presentMailComposeViewControllerTo:nil subject:@"SW Travel Manager app" messageBody:[NSString stringWithFormat:MESSAGE_BODY, [self.passengerName objectForKey:@"First"]]];
                break;
            case 3: // Email support
                [self presentMailComposeViewControllerTo:@"support@redcup.la" subject:nil messageBody:nil];
                // TODO: figure out how to add iOS version and device model to message body
                break;
        }
    }
}

- (void)openLink:(NSString *)link withBackup:(NSString *)backupLink {
    BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    if (!success) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:backupLink]];
}

- (void)presentMailComposeViewControllerTo:(NSString *)recipient
                                   subject:(NSString *)subject
                               messageBody:(NSString *)body {
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    [mailVC setToRecipients:[NSArray arrayWithObjects:recipient, nil]];
    [mailVC setSubject:subject];
    [mailVC setMessageBody:body isHTML:FALSE];
    mailVC.mailComposeDelegate = self;
    [self presentViewController:mailVC animated:TRUE completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:TRUE];
    // TODO: add Flurry event with result
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)viewDidUnload {
    [self setCellBackground:nil];
    [self setVersionCell:nil];
    [self setNameCell:nil];
    [self setAccountNumberCell:nil];
    [self setTellAFriendCell:nil];
    [self setEmailSupportCell:nil];
    [super viewDidUnload];
}

@end
