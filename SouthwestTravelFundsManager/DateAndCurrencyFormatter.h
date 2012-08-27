//
//  DateAndCurrencyFormatter.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateAndCurrencyFormatter : NSObject

#define DATE_FORMAT @"MM/dd/yyyy"
#define DATE_TIME_FORMAT @"MM/dd/yyyy h:mm a"
#define DAY_DATE_TIME_FORMAT @"EEEE, MMMM d, yyyy, h:mm a"

- (NSString *)stringForDate:(NSDate *)date withFormat:(NSString *)format inTimeZone:(NSTimeZone *)timeZone;
- (NSString *)stringForCost:(NSNumber *)cost;

@end
