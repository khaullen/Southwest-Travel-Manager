//
//  AirportPickerViewController.h
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/21/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Airport+Create.h"

@class AirportPickerViewController;

@protocol AirportPickerViewControllerDelegate <NSObject>

- (void)airportPickerViewController:(AirportPickerViewController *)airportPickerVC selectedOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination;

@end

@interface AirportPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *airportPicker;
@property (nonatomic, weak) id <AirportPickerViewControllerDelegate> delegate;

- (void)setSelectedOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination;
- (void)setSelectedDefaultAirports;

@end
