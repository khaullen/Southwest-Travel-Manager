//
//  RCDatePicker.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 10/16/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This class is a drop-in replacement for UIDatePicker that addresses the Apple bug that wrecks havoc when there are multiple instances in memory, set to different time zones.
 *
 *  The interface is identical, but the implementation overrides all UIDate/NSTimeZone-related methods and properties to allow the underlying UIDatePicker instance to use the local time zone, while mimicking the correct behavior of pickers in different time zones. This is accomplished by adjusting every UIDate instance by the difference between the desired time zone and the underlying local time zone.
 */
@interface RCDatePicker : UIDatePicker

@end
