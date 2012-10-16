//
//  GenericDataInputTableViewController.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirportPickerViewController.h"
#import "DateAndCurrencyFormatter.h"
#import "DatabaseHelper.h"
#import "RCDatePicker.h"

@interface GenericDataInputTableViewController : UITableViewController <UITextFieldDelegate, AirportPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *flightTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;
@property (weak, nonatomic) IBOutlet UISwitch *roundtripSwitch;
@property (weak, nonatomic) IBOutlet UITextField *outboundTextField;
@property (weak, nonatomic) IBOutlet UITextField *returnTextField;
@property (weak, nonatomic) IBOutlet UISwitch *checkInReminderSwitch;
@property (weak, nonatomic) IBOutlet UILabel *fundsUsedLabel;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (weak, nonatomic) IBOutlet UISwitch *unusedTicketSwitch;

@property (nonatomic, strong) NSMutableDictionary *fieldData;

@property (strong, nonatomic) AirportPickerViewController *airportPickerVC;
@property (strong, nonatomic) RCDatePicker *expirationDatePicker;
@property (strong, nonatomic) RCDatePicker *outboundDatePicker;
@property (strong, nonatomic) RCDatePicker *returnDatePicker;

@property (strong, nonatomic) DateAndCurrencyFormatter *formatter;

@property (nonatomic) BOOL firstResponderTweaks;

- (void)setDataInFields;
- (void)datePickerDidEndEditing:(UIDatePicker *)sender;
- (void)switchDidEndEditing:(UISwitch *)sender;
- (BOOL)tableHasIncompleteRequiredFields:(NSDictionary *)requiredFields;
- (BOOL)isInvalid:(NSString *)field;
- (void)selectAnimated:(NSSet *)incompleteFields fromRequiredFields:(NSDictionary *)requiredFields;
- (NSString *)nameForPicker:(UITextField *)field;
- (void)selectPickerFieldCell:(UITableViewCell *)cell withTextField:(UITextField *)textField selected:(BOOL)selected;
- (void)updatePlaceholderText;
- (void)updateFundsUsedLabel:(NSSet *)fundsUsed;
- (void)finalizeEnteredData;
- (UITextField *)textFieldForIndexPath:(NSIndexPath *)indexPath;


@end