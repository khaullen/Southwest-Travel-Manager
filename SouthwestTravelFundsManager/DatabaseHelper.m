//
//  DatabaseHelper.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/29/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "DatabaseHelper.h"

static UIManagedDocument *sharedDatabase = nil;

@implementation DatabaseHelper

+ (UIManagedDocument *)sharedDatabase {
    if (!sharedDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"default_database"];
        sharedDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    return sharedDatabase;
}

@end
