//
//  AboutViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/28/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataEntryTableViewController.h"

@interface AboutViewController ()

- (void)initializeCellBackground:(UIImageView *)cellBackground;
- (void)initializeDetailText:(NSArray *)cells;
- (NSArray *)detailData;

@end

@implementation AboutViewController

@synthesize cellBackground = _cellBackground;
@synthesize version = _version;
@synthesize name = _name;
@synthesize accountNumber = _accountNumber;


- (void)viewDidLoad {
    [self initializeCellBackground:self.cellBackground];
    [self initializeDetailText:[NSArray arrayWithObjects:self.version, self.name, self.accountNumber, nil]];
}

- (void)initializeCellBackground:(UIImageView *)cellBackground {
    cellBackground.image = [cellBackground.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, cellBackground.image.size.width - 1, 0, 0)];
    cellBackground.layer.masksToBounds = TRUE;
    cellBackground.layer.cornerRadius = 7.0;
}

- (void)initializeDetailText:(NSArray *)cells {
    NSArray *details = [self detailData];
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        NSString *detailText = [details objectAtIndex:i];
        cell.detailTextLabel.text = detailText;
    }
}

- (NSArray *)detailData {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSArray *name = [[NSUserDefaults standardUserDefaults] stringArrayForKey:@"name"];
    NSString *fullName = @"";
    for (NSString *namePart in name) {
        fullName = [fullName stringByAppendingFormat:@"%@ ", namePart];
    }
    NSString *acctNumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"accountNumber"];
    if (!acctNumber) acctNumber = @"";
    return [NSArray arrayWithObjects:appVersion, fullName, acctNumber, nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToName"]) {
        DataEntryTableViewController *viewController = segue.destinationViewController;
        viewController.fields = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"First", @"", @"Last", nil];
    }
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)viewDidUnload {
    [self setCellBackground:nil];
    [self setVersion:nil];
    [self setName:nil];
    [self setAccountNumber:nil];
    [super viewDidUnload];
}
@end
