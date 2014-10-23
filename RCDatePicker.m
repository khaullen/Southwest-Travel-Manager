//
//  RCDatePicker.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 10/16/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "RCDatePicker.h"

@interface RCDatePicker ()

@property (strong, nonatomic) NSTimeZone *RCTimeZone;

- (NSDate *)fakeDateForTimeZone:(NSTimeZone *)timeZone forDate:(NSDate *)date;
- (NSDate *)trueDateInTimeZone:(NSTimeZone *)timeZone forDate:(NSDate *)date;

@end

@implementation RCDatePicker

@synthesize RCTimeZone = _RCTimeZone;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super setTimeZone:[NSTimeZone localTimeZone]];
    }
    return self;
}

- (void)setTimeZone:(NSTimeZone *)timeZone {
    self.RCTimeZone = timeZone;
}

- (NSTimeZone *)timeZone {
    return self.RCTimeZone;
}

- (void)setDate:(NSDate *)date {
    [super setDate:[self fakeDateForTimeZone:self.RCTimeZone forDate:date]];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    [super setDate:[self fakeDateForTimeZone:self.RCTimeZone forDate:date] animated:animated];
}

- (NSDate *)date {
    return [self trueDateInTimeZone:self.RCTimeZone forDate:[super date]];
}

- (NSDate *)fakeDateForTimeZone:(NSTimeZone *)timeZone forDate:(NSDate *)date {
    NSTimeInterval timeOffset = [timeZone secondsFromGMT] - [super.timeZone secondsFromGMT];
    return [date dateByAddingTimeInterval:timeOffset];
}

- (NSDate *)trueDateInTimeZone:(NSTimeZone *)timeZone forDate:(NSDate *)date {
    NSTimeInterval timeOffset = [super.timeZone secondsFromGMT] - [timeZone secondsFromGMT];
    return [date dateByAddingTimeInterval:timeOffset];
}

@end
