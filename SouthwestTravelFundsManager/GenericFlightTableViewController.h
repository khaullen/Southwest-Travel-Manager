//
//  GenericFlightTableViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirportPickerViewController.h"

@interface GenericFlightTableViewController : UITableViewController <UITextFieldDelegate, AirportPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *flightTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;
@property (weak, nonatomic) IBOutlet UISwitch *roundtripSwitch;
@property (weak, nonatomic) IBOutlet UITextField *outboundTextField;
@property (weak, nonatomic) IBOutlet UITextField *returnTextField;
@property (weak, nonatomic) IBOutlet UISwitch *checkInReminderSwitch;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;

@property (nonatomic, strong) NSString *origin;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSString *confirmationCode;
@property (nonatomic, strong) NSNumber *cost;
@property (nonatomic, strong) NSDate *expirationDate;
@property (nonatomic, strong) NSNumber *roundtrip;
@property (nonatomic, strong) NSDate *outboundDepartureDate;
@property (nonatomic, strong) NSDate *returnDepartureDate;
@property (nonatomic, strong) NSNumber *checkInReminder;
@property (nonatomic, strong) NSString *notes;

@property (strong, nonatomic) UIPickerView *airportPicker;
@property (strong, nonatomic) AirportPickerViewController *airportPickerVC;

@end
