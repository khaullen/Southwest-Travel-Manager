//
//  AirportPickerViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/21/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AIRPORT_CODE @"airportCode"

@class AirportPickerViewController;

@protocol AirportPickerViewControllerDelegate <NSObject>

- (void)airportPickerViewController:(AirportPickerViewController *)airportPickerVC selectedOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination;

@end

@interface AirportPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UIPickerView *airportPicker;
@property (nonatomic, weak) id <AirportPickerViewControllerDelegate> delegate;

- (NSTimeZone *)timeZoneForAirport:(NSString *)airport;
- (void)setSelectedOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination;

@end
