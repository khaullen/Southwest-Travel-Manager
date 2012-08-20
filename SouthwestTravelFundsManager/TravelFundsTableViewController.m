//
//  TravelFundsTableViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/15/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "TravelFundsTableViewController.h"
#import "Fund+Create.h"
#import "Flight.h"

@interface TravelFundsTableViewController ()

- (void)useDocument;
- (void)setupFetchedResultsController;
- (void)addTestDataIntoDocument:(UIManagedDocument *)document;

@end

@implementation TravelFundsTableViewController

@synthesize database = _database;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.database) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"default_database"];
        self.database = [[UIManagedDocument alloc] initWithFileURL:url];
    }
}

- (void)setDatabase:(UIManagedDocument *)database {
    if (database != _database) {
        _database = database;
        [self useDocument];
    }
}

- (void)useDocument {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.database.fileURL path]]) {
        // Create database
        [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            [self addTestDataIntoDocument:self.database];
        }];
    } else if (self.database.documentState == UIDocumentStateClosed) {
        [self.database openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.database.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setupFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fund"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"expirationDate" ascending:TRUE]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.database.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)addTestDataIntoDocument:(UIManagedDocument *)document {
    // consider converting flickr data into flight data
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fund";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Fund *fund = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", fund.balance];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@)", fund.originalFlight.origin, fund.originalFlight.destination, fund.originalFlight.outboundDepartureDate];
    return cell;
}



@end
