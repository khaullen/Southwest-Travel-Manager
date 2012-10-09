//
//  DataEntryTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 9/28/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "DataEntryTableViewController.h"

@interface DataEntryTableViewController ()

@end

@implementation DataEntryTableViewController

@synthesize labels = _labels;
@synthesize placeholders = _placeholders;
@synthesize details = _details;
@synthesize keyboardTypes = _keyboardTypes;

- (void)viewDidAppear:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    DataEntryCell *firstCell = (DataEntryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [firstCell.textField becomeFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.labels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dataCell";
    DataEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    NSString *cellLabel = [self.labels objectAtIndex:indexPath.row];
    cell.label.text = cellLabel;
    cell.textField.placeholder = [self.placeholders objectForKey:cellLabel];
    cell.textField.text = [self.details objectForKey:cellLabel];
    cell.textField.keyboardType = [[self.keyboardTypes objectForKey:cellLabel] intValue];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataEntryCell *cell = (DataEntryCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.textField becomeFirstResponder];
}

#pragma mark - Data entry delegate usage

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    NSMutableArray *dataEntered = [NSMutableArray arrayWithCapacity:self.labels.count];
    for (int i = 0; i < self.labels.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        DataEntryCell *cell = (DataEntryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [dataEntered addObject:cell.textField.text];
    }
    NSDictionary *dataDictionary = [NSDictionary dictionaryWithObjects:dataEntered forKeys:self.labels];
    [self.delegate dataEntryTableViewController:self didEnterData:dataDictionary];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - Data entry cell delegate

- (void)dataEntryCell:(DataEntryCell *)sender textFieldDidReturn:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    DataEntryCell *nextCell = (DataEntryCell *)[self.tableView cellForRowAtIndexPath:nextIndexPath];
    if (nextCell) {
        [nextCell.textField becomeFirstResponder];
    } else {
        [self donePressed:self.navigationItem.rightBarButtonItem];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


@end
