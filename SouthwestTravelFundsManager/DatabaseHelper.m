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
        NSLog(@"sharedDatabase: %@", sharedDatabase);
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"default_database"];
        sharedDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setObject:[NSNumber numberWithBool:TRUE] forKey:NSMigratePersistentStoresAutomaticallyOption];
        [options setObject:[NSNumber numberWithBool:TRUE] forKey:NSInferMappingModelAutomaticallyOption];
        sharedDatabase.persistentStoreOptions = options;
    }
    return sharedDatabase;
}

+ (void)saveDatabase {
    [[DatabaseHelper sharedDatabase] saveToURL:sharedDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (!success) NSLog(@"failed to save document %@", sharedDatabase.localizedName);
    }];
}

@end
