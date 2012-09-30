//
//  AboutViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/28/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize cellBackground = _cellBackground;

- (void)viewDidLoad {
    self.cellBackground.image = [self.cellBackground.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, self.cellBackground.image.size.width - 1, 0, 0)];
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [[self presentingViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)viewDidUnload {
    [self setCellBackground:nil];
    [super viewDidUnload];
}
@end
