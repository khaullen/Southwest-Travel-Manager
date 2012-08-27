//
//  GenericFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericFlightTableViewController.h"
#import "Flight+Create.h"
#import "Fund+Create.h"

@interface GenericFlightTableViewController ()

- (void)setCustomInputViews;
- (void)setDataInFields;
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
@synthesize formatter = _formatter;

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
    [self setDataInFields];
}

- (NSMutableDictionary *)flightData {
    if (!_flightData) {
        _flightData = [[NSMutableDictionary alloc] initWithCapacity:10];
        [_flightData setObject:[NSNumber numberWithBool:self.roundtripSwitch.on] forKey:ROUNDTRIP];
        [_flightData setObject:[NSNumber numberWithBool:self.checkInReminderSwitch.on] forKey:CHECK_IN_REMINDER];
    }
    return _flightData;
}

- (void)setDataInFields {
    NSDictionary *aOrigin = [self.flightData objectForKey:ORIGIN];
    NSDictionary *aDestination = [self.flightData objectForKey:DESTINATION];
    if (aOrigin && aDestination) [self.airportPickerVC setSelectedOrigin:aOrigin andDestination:aDestination];
    NSString *aConfirmationCode = [self.flightData objectForKey:CONFIRMATION_CODE];
    if (aConfirmationCode) self.confirmTextField.text = aConfirmationCode;
    NSNumber *aCost = [self.flightData objectForKey:COST];
    if (aCost) self.costTextField.text = [self.formatter stringForCost:aCost];
    NSDate *aExpirationDate = [self.flightData objectForKey:EXPIRATION_DATE];
    if (aExpirationDate) {
        self.expirationDatePicker.date = aExpirationDate;
        [self datePickerDidEndEditing:self.expirationDatePicker];
    }
    NSNumber *aRoundtrip = [self.flightData objectForKey:ROUNDTRIP];
    if (aRoundtrip) self.roundtripSwitch.on = [aRoundtrip boolValue];
    NSDate *aOutboundDepartureDate = [self.flightData objectForKey:OUTBOUND_DEPARTURE_DATE];
    if (aOutboundDepartureDate) {
        self.outboundDatePicker.date = aOutboundDepartureDate;
        [self datePickerDidEndEditing:self.outboundDatePicker];
    }
    NSDate *aReturnDepartureDate = [self.flightData objectForKey:RETURN_DEPARTURE_DATE];
    if (aReturnDepartureDate) {
        self.returnDatePicker.date = aReturnDepartureDate;
        [self datePickerDidEndEditing:self.returnDatePicker];
    }
    NSNumber *aCheckInReminder = [self.flightData objectForKey:CHECK_IN_REMINDER];
    if (aCheckInReminder) self.checkInReminderSwitch.on = [aCheckInReminder boolValue];
    NSString *aNotes = [self.flightData objectForKey:FLIGHT_NOTES];
    if (aNotes) self.notesTextField.text = aNotes;
}

- (NSDictionary *)requiredFields {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], ORIGIN, [NSIndexPath indexPathForRow:0 inSection:0], DESTINATION, [NSIndexPath indexPathForRow:1 inSection:0], CONFIRMATION_CODE, [NSIndexPath indexPathForRow:2 inSection:0], COST, [NSIndexPath indexPathForRow:3 inSection:0], EXPIRATION_DATE, [NSIndexPath indexPathForRow:0 inSection:2], CHECK_IN_REMINDER, [NSIndexPath indexPathForRow:0 inSection:1], ROUNDTRIP, [NSIndexPath indexPathForRow:1 inSection:1], OUTBOUND_DEPARTURE_DATE, self.roundtripSwitch.on ? [NSIndexPath indexPathForRow:2 inSection:1] : nil, RETURN_DEPARTURE_DATE, nil];
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
        _expirationDatePicker.timeZone = [NSTimeZone localTimeZone];
        [_expirationDatePicker addTarget:self action:@selector(datePickerDidEndEditing:) forControlEvents:UIControlEventValueChanged];
    }
    return _expirationDatePicker;
}

- (UIDatePicker *)outboundDatePicker {
    if (!_outboundDatePicker) {
        _outboundDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 244, 320, 270)];
        _outboundDatePicker.minuteInterval = 5;
        _outboundDatePicker.timeZone = [NSTimeZone timeZoneWithName:[[self.flightData objectForKey:ORIGIN] objectForKey:TIME_ZONE]];
        [_outboundDatePicker addTarget:self action:@selector(datePickerDidEndEditing:) forControlEvents:UIControlEventValueChanged];
    }
    return _outboundDatePicker;
}

- (UIDatePicker *)returnDatePicker {
    if (!_returnDatePicker) {
        _returnDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 244, 320, 270)];
        _returnDatePicker.minuteInterval = 5;
        _returnDatePicker.timeZone = [NSTimeZone timeZoneWithName:[[self.flightData objectForKey:DESTINATION] objectForKey:TIME_ZONE]];
        [_returnDatePicker addTarget:self action:@selector(datePickerDidEndEditing:) forControlEvents:UIControlEventValueChanged];
    }
    return _returnDatePicker;
}

- (DateAndCurrencyFormatter *)formatter {
    if (!_formatter) _formatter = [[DateAndCurrencyFormatter alloc] init];
    return  _formatter;
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
        // disallow more than two digits after decimal point
        if ([newString rangeOfString:@"."].length && [newString rangeOfString:@"."].location < newString.length - 3) return FALSE;
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
        [self.flightData setObject:self.confirmTextField.text forKey:CONFIRMATION_CODE];
    } else if ([textField isEqual:self.costTextField]) {
        NSString *numberValue;
        if ([self.costTextField.text hasPrefix:@"$"]) numberValue = [self.costTextField.text substringFromIndex:1];
        if (![numberValue doubleValue] && ![self.costTextField isFirstResponder]) {
            self.costTextField.text = @"";
        } else {
            self.costTextField.text = [self.formatter stringForCost:[NSNumber numberWithDouble:[numberValue doubleValue]]];
        }
        [self.flightData setObject:[NSNumber numberWithDouble:[numberValue doubleValue]] forKey:@"cost"];
    } else if ([textField isEqual:self.notesTextField]) {
        [self.flightData setObject:self.notesTextField.text forKey:FLIGHT_NOTES];
    }
}

- (void)datePickerDidEndEditing:(UIDatePicker *)sender {
    // update corresponding property and update text field
    if ([sender isEqual:self.expirationDatePicker]) {
        [self.flightData setObject:self.expirationDatePicker.date forKey:EXPIRATION_DATE];
        self.expirationTextField.text = [self.formatter stringForDate:self.expirationDatePicker.date withFormat:DATE_FORMAT inTimeZone:self.expirationDatePicker.timeZone];
    } else if ([sender isEqual:self.outboundDatePicker]) {
        [self.flightData setObject:self.outboundDatePicker.date forKey:OUTBOUND_DEPARTURE_DATE];
        self.outboundTextField.text = [self.formatter stringForDate:self.outboundDatePicker.date withFormat:DATE_TIME_FORMAT inTimeZone:self.outboundDatePicker.timeZone];
    } else if ([sender isEqual:self.returnDatePicker]) {
        [self.flightData setObject:self.returnDatePicker.date forKey:RETURN_DEPARTURE_DATE];
        self.returnTextField.text = [self.formatter stringForDate:self.returnDatePicker.date withFormat:DATE_TIME_FORMAT inTimeZone:self.returnDatePicker.timeZone];
    }
}

- (void)switchDidEndEditing:(UISwitch *)sender {
    // update corresponding property
    if ([sender isEqual:self.roundtripSwitch]) {
        [self.flightData setObject:[NSNumber numberWithBool:self.roundtripSwitch.on] forKey:ROUNDTRIP];
    } else if ([sender isEqual:self.checkInReminderSwitch]) {
        [self.flightData setObject:[NSNumber numberWithBool:self.checkInReminderSwitch.on] forKey:CHECK_IN_REMINDER];
    }
}

- (void)airportPickerViewController:(AirportPickerViewController *)airportPickerVC selectedOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination {
    self.flightTextField.text = [NSString stringWithFormat:@"%@ - %@", [origin objectForKey:AIRPORT_CODE], [destination objectForKey:AIRPORT_CODE]];
    [self.flightData setObject:origin forKey:ORIGIN];
    [self.flightData setObject:destination forKey:DESTINATION];
    self.outboundDatePicker.timeZone = [NSTimeZone timeZoneWithName:[origin objectForKey:TIME_ZONE]];
    if (self.outboundTextField.text.length) self.outboundTextField.text = [self.formatter stringForDate:self.outboundDatePicker.date withFormat:DATE_TIME_FORMAT inTimeZone:self.outboundDatePicker.timeZone];
    self.returnDatePicker.timeZone = [NSTimeZone timeZoneWithName:[destination objectForKey:TIME_ZONE]];
    if (self.returnTextField.text.length) self.returnTextField.text = [self.formatter stringForDate:self.returnDatePicker.date withFormat:DATE_TIME_FORMAT inTimeZone:self.returnDatePicker.timeZone];
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
        if ([field isEqualToString:DESTINATION]) {
            if ([[self.flightData objectForKey:field] isEqualToDictionary:[self.flightData objectForKey:ORIGIN]]) [invalid addObject:field];
        } else if ([field isEqualToString:CONFIRMATION_CODE]) {
            if ([(NSString *)[self.flightData objectForKey:field] length] != 6) [invalid addObject:field];
        } else if ([field isEqualToString:COST]) {
            if ([(NSNumber *)[self.flightData objectForKey:field] doubleValue] == 0) [invalid addObject:field];
        } else if ([field isEqualToString:RETURN_DEPARTURE_DATE]) {
            if ([(NSDate *)[self.flightData objectForKey:field] compare:[self.flightData objectForKey:OUTBOUND_DEPARTURE_DATE]] == NSOrderedAscending) [invalid addObject:field];
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
