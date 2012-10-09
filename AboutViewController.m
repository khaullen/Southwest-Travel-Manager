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
- (NSArray *)detailData;
- (void)prepareDataEntryTVC:(DataEntryTableViewController *)viewController title:(NSString *)title cellLabels:(NSArray *)cellLabels placeholders:(NSDictionary *)placeholders details:(NSDictionary *)details keyboardTypes:(NSDictionary *)keyboardTypes;

@end

@implementation AboutViewController

@synthesize cellBackground = _cellBackground;
@synthesize versionCell = _versionCell;
@synthesize nameCell = _nameCell;
@synthesize accountNumberCell = _accountNumberCell;
@dynamic passengerName;
@dynamic passengerAccountNumber;

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
    [[self presentingViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Buttons at bottom of view
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)viewDidUnload {
    [self setCellBackground:nil];
    [self setVersionCell:nil];
    [self setNameCell:nil];
    [self setAccountNumberCell:nil];
    [super viewDidUnload];
}

@end
