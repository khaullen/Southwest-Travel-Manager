//
//  GenericFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericFlightTableViewController.h"

@interface GenericFlightTableViewController ()

- (void)setCustomInputViews;
- (void)datePickerDidEndEditing:(UIDatePicker *)sender;
- (void)switchDidEndEditing:(UISwitch *)sender;
- (void)selectAnimated:(NSSet *)incompleteFields;
- (NSSet *)validateFields:(NSMutableSet *)enteredData;

@end

@implementation GenericFlightTableViewController

@synthesize flightTextField = _flightTextField;
@synthesize confirmTextField = _confirmTextField;
@synthesize costTextField = _costTextField;
@synthesize expirationTextField = _expirationTextField;
@synthesize roundtripSwitch = _roundtripSwitch;
@synthesize outboundTextField = _outboundTextField;
@synthesize returnTextField = _returnTextField;
@synthesize checkInReminderSwitch = _checkInReminderSwitch;
@synthesize notesTextField = _notesTextField;
@synthesize flightData = _flightData;
@synthesize requiredFields = _requiredFields;
@synthesize airportPicker = _airportPicker;
@synthesize airportPickerVC = _airportPickerVC;
@synthesize expirationDatePicker = _expirationDatePicker;
@synthesize outboundDatePicker = _outboundDatePicker;
@synthesize returnDatePicker = _returnDatePicker;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flightTextField.delegate = self;
    self.confirmTextField.delegate = self;
    self.costTextField.delegate = self;
    self.expirationTextField.delegate = self;
    self.outboundTextField.delegate = self;
    self.returnTextField.delegate = self;
    self.notesTextField.delegate = self;
    [self setCustomInputViews];
}

- (NSMutableDictionary *)flightData {
    if (!_flightData) {
        _flightData = [[NSMutableDictionary alloc] initWithCapacity:10];
        [_flightData setObject:[NSNumber numberWithBool:self.roundtripSwitch.on] forKey:@"roundtrip"];
        [_flightData setObject:[NSNumber numberWithBool:self.checkInReminderSwitch.on] forKey:@"checkInReminder"];
    }
    return _flightData;
}

- (void)setFlightData:(NSMutableDictionary *)flightData {
    // TODO: complete implementation
}

- (NSDictionary *)requiredFields {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], @"origin", [NSIndexPath indexPathForRow:0 inSection:0], @"destination", [NSIndexPath indexPathForRow:1 inSection:0], @"confirmationCode", [NSIndexPath indexPathForRow:2 inSection:0], @"cost", [NSIndexPath indexPathForRow:3 inSection:0], @"expirationDate", [NSIndexPath indexPathForRow:0 inSection:2], @"checkInReminder", [NSIndexPath indexPathForRow:0 inSection:1], @"roundtrip", [NSIndexPath indexPathForRow:1 inSection:1], @"outboundDepartureDate", self.roundtripSwitch.on ? [NSIndexPath indexPathForRow:2 inSection:1] : nil, @"returnDepartureDate", nil];
}

- (UIPickerView *)airportPicker {
    if (!_airportPicker) {
        _airportPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 244, 320, 270)];
        _airportPicker.delegate = self.airportPickerVC;
        _airportPicker.dataSource = self.airportPickerVC;
    }
    return _airportPicker;
}

- (AirportPickerViewController *)airportPickerVC {
    if (!_airportPickerVC) {
        _airportPickerVC = [[AirportPickerViewController alloc] init];
        _airportPickerVC.airportPicker = self.airportPicker;
        _airportPickerVC.delegate = self;
    }
    return _airportPickerVC;
}

- (UIDatePicker *)expirationDatePicker {
    if (!_expirationDatePicker) {
        _expirationDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 244, 320, 270)];
        _expirationDatePicker.datePickerMode = UIDatePickerModeDate;
        [_expirationDatePicker addTarget:self action:@selector(datePickerDidEndEditing:) forControlEvents:UIControlEventValueChanged];
    }
    return _expirationDatePicker;
}

- (UIDatePicker *)outboundDatePicker {
    if (!_outboundDatePicker) {
        _outboundDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 244, 320, 270)];
        _outboundDatePicker.minuteInterval = 5;
        _outboundDatePicker.timeZone = [self.airportPickerVC timeZoneForAirport:[self.flightData valueForKey:@"origin"]];
        [_outboundDatePicker addTarget:self action:@selector(datePickerDidEndEditing:) forControlEvents:UIControlEventValueChanged];
    }
    return _outboundDatePicker;
}

- (UIDatePicker *)returnDatePicker {
    if (!_returnDatePicker) {
        _returnDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 244, 320, 270)];
        _returnDatePicker.minuteInterval = 5;
        _returnDatePicker.timeZone = [self.airportPickerVC timeZoneForAirport:[self.flightData valueForKey:@"destination"]];
        [_returnDatePicker addTarget:self action:@selector(datePickerDidEndEditing:) forControlEvents:UIControlEventValueChanged];
    }
    return _returnDatePicker;
}

- (void)setCustomInputViews {
    self.flightTextField.inputView = self.airportPicker;
    self.costTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.expirationTextField.inputView = self.expirationDatePicker;
    [self.roundtripSwitch addTarget:self action:@selector(switchDidEndEditing:) forControlEvents:UIControlEventValueChanged];
    self.outboundTextField.inputView = self.outboundDatePicker;
    self.returnTextField.inputView = self.returnDatePicker;
    [self.checkInReminderSwitch addTarget:self action:@selector(switchDidEndEditing:) forControlEvents:UIControlEventValueChanged];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // move first responder to next text field
    if ([textField isEqual:self.confirmTextField]) {
        if (!self.costTextField.text.length) {
            [self.costTextField becomeFirstResponder];
        } else {
            [self.confirmTextField resignFirstResponder];
        }
    }
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:self.confirmTextField]) {
        // move first responder after 6 characters in confirmation code
        if (newString.length == 6) {
            self.confirmTextField.text = newString;
            [self.costTextField becomeFirstResponder];
            return FALSE;
        }
    } else if ([textField isEqual:self.costTextField]) {
        // disallow deletion of "$" character
        if (range.location == 0) return FALSE;
        // disallow multiple decimal points
        if ([string isEqualToString:@"."] && [textField.text rangeOfString:@"."].length) return FALSE;
        // move first responder with two digits after decimal point
        if (newString.length >= 3 && [newString characterAtIndex:newString.length - 3] == '.') {
            self.costTextField.text = newString;
            [self.expirationTextField becomeFirstResponder];
            return FALSE;
        }
    }
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.costTextField]) {
        // add currency symbol when empty
        if (!self.costTextField.text.length) self.costTextField.text = @"$";
    } else if ([textField isEqual:self.expirationTextField]) {
        if (!self.expirationTextField.text.length) {
            [self.expirationDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)] animated:TRUE];
            [self datePickerDidEndEditing:self.expirationDatePicker];
        }
    } else if ([textField isEqual:self.returnTextField]) {
        // update date to departure date
        if (!self.returnTextField.text.length) [self.returnDatePicker setDate:self.outboundDatePicker.date animated:TRUE];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // update corresponding property
    if ([textField isEqual:self.confirmTextField]) {
        [self.flightData setObject:self.confirmTextField.text forKey:@"confirmationCode"];
    } else if ([textField isEqual:self.costTextField]) {
        NSString *numberValue;
        if ([self.costTextField.text hasPrefix:@"$"]) numberValue = [self.costTextField.text substringFromIndex:1];
        if (![numberValue doubleValue] && ![self.costTextField isFirstResponder]) self.costTextField.text = @"";
        [self.flightData setObject:[NSNumber numberWithDouble:[numberValue doubleValue]] forKey:@"cost"];
        // TODO: use NSNumberFormatter to update text display
    } else if ([textField isEqual:self.notesTextField]) {
        [self.flightData setObject:self.notesTextField.text forKey:@"notes"];
    }
}

- (void)datePickerDidEndEditing:(UIDatePicker *)sender {
    // update corresponding property and update text field
    if ([sender isEqual:self.expirationDatePicker]) {
        [self.flightData setObject:self.expirationDatePicker.date forKey:@"expirationDate"];
        self.expirationTextField.text = [self stringForDate:self.expirationDatePicker.date withFormat:DATE_FORMAT];
    } else if ([sender isEqual:self.outboundDatePicker]) {
        [self.flightData setObject:self.outboundDatePicker.date forKey:@"outboundDepartureDate"];
        self.outboundTextField.text = [self stringForDate:self.outboundDatePicker.date withFormat:DATE_TIME_FORMAT];
    } else if ([sender isEqual:self.returnDatePicker]) {
        [self.flightData setObject:self.returnDatePicker.date forKey:@"returnDepartureDate"];
        self.returnTextField.text = [self stringForDate:self.returnDatePicker.date withFormat:DATE_TIME_FORMAT];
    }
}

- (void)switchDidEndEditing:(UISwitch *)sender {
    // update corresponding property
    if ([sender isEqual:self.roundtripSwitch]) {
        [self.flightData setObject:[NSNumber numberWithBool:self.roundtripSwitch.on] forKey:@"roundtrip"];
    } else if ([sender isEqual:self.checkInReminderSwitch]) {
        [self.flightData setObject:[NSNumber numberWithBool:self.checkInReminderSwitch.on] forKey:@"checkInReminder"];
    }
}

- (void)airportPickerViewController:(AirportPickerViewController *)airportPickerVC selectedOrigin:(NSString *)origin andDestination:(NSString *)destination {
    self.flightTextField.text = [NSString stringWithFormat:@"%@ - %@", origin, destination];
    [self.flightData setObject:origin forKey:@"origin"];
    [self.flightData setObject:destination forKey:@"destination"];
}

- (BOOL)flightTableViewControllerHasIncompleteRequiredFields {
    NSSet *completedFields = [self validateFields:[NSMutableSet setWithArray:[self.flightData allKeys]]];
    NSMutableSet *incompleteRequiredFields = [NSMutableSet setWithArray:[self.requiredFields allKeys]];
    [incompleteRequiredFields minusSet:completedFields];
    [self selectAnimated:incompleteRequiredFields];
    return incompleteRequiredFields.count;
}

- (NSSet *)validateFields:(NSMutableSet *)enteredData {
    NSMutableSet *invalid = [[NSMutableSet alloc] initWithCapacity:8];
    for (NSString *field in enteredData) {
        if ([field isEqualToString:@"confirmationCode"]) {
            if ([(NSString *)[self.flightData objectForKey:field] length] != 6) [invalid addObject:field];
        } else if ([field isEqualToString:@"cost"]) {
            if ([(NSNumber *)[self.flightData objectForKey:field] doubleValue] == 0) [invalid addObject:field];
        } else if ([field isEqualToString:@"returnDepartureDate"]) {
            if ([(NSDate *)[self.flightData objectForKey:field] compare:[self.flightData objectForKey:@"outboundDepartureDate"]] == NSOrderedAscending) [invalid addObject:field];
        }
    }
    [enteredData minusSet:invalid];
    return enteredData;
}

- (void)selectAnimated:(NSSet *)incompleteFields {
    NSIndexPath *topIndex = [NSIndexPath indexPathForRow:0 inSection:3];
    for (NSString *field in incompleteFields) {
        NSIndexPath *indexPath = [self.requiredFields objectForKey:field];
        if ([indexPath compare:topIndex] == NSOrderedAscending) topIndex = indexPath;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:TRUE];
        [cell setSelected:FALSE animated:TRUE];
    }
    [self.tableView scrollToRowAtIndexPath:topIndex atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
}

- (NSString *)stringForDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setFlightTextField:nil];
    [self setConfirmTextField:nil];
    [self setCostTextField:nil];
    [self setExpirationTextField:nil];
    [self setRoundtripSwitch:nil];
    [self setOutboundTextField:nil];
    [self setReturnTextField:nil];
    [self setCheckInReminderSwitch:nil];
    [self setNotesTextField:nil];
    [super viewDidUnload];
}
@end
