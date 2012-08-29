//
//  GenericFlightTableViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirportPickerViewController.h"
#import "DateAndCurrencyFormatter.h"

@interface GenericDataInputTableViewController : UITableViewController <UITextFieldDelegate, AirportPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *flightTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;
@property (weak, nonatomic) IBOutlet UISwitch *roundtripSwitch;
@property (weak, nonatomic) IBOutlet UITextField *outboundTextField;
@property (weak, nonatomic) IBOutlet UITextField *returnTextField;
@property (weak, nonatomic) IBOutlet UISwitch *checkInReminderSwitch;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (weak, nonatomic) IBOutlet UISwitch *unusedTicketSwitch;

@property (nonatomic, strong) NSMutableDictionary *fieldData;

@property (strong, nonatomic) AirportPickerViewController *airportPickerVC;
@property (strong, nonatomic) UIDatePicker *expirationDatePicker;
@property (strong, nonatomic) UIDatePicker *outboundDatePicker;
@property (strong, nonatomic) UIDatePicker *returnDatePicker;

@property (strong, nonatomic) DateAndCurrencyFormatter *formatter;

@property (nonatomic) BOOL firstResponderTweaks;

- (BOOL)tableHasIncompleteRequiredFields:(NSDictionary *)requiredFields;
- (void)updatePlaceholderText;

@end