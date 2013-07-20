//
//  DatabaseHelper.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/29/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DatabaseHelper : NSObject

+ (UIManagedDocument *)sharedDatabase;
+ (void)saveDatabase;

@end
