//
//  DateAndCurrencyFormatter.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/27/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "DateAndCurrencyFormatter.h"

@interface DateAndCurrencyFormatter ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation DateAndCurrencyFormatter

@synthesize dateFormatter = _dateFormatter;
@synthesize numberFormatter = _numberFormatter;

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) _dateFormatter = [[NSDateFormatter alloc] init];
    return  _dateFormatter;
}

- (NSNumberFormatter *)numberFormatter {
    if (!_numberFormatter) _numberFormatter = [[NSNumberFormatter alloc] init];
    return  _numberFormatter;
}

- (NSString *)stringForDate:(NSDate *)date withFormat:(NSString *)format inTimeZone:(NSTimeZone *)timeZone{
    self.dateFormatter.dateFormat = format;
    self.dateFormatter.timeZone = timeZone;
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)stringForCost:(NSNumber *)cost {
    [self.numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [self.numberFormatter stringFromNumber:cost];
}

@end
