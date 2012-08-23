//
//  GenericFlightTableViewController.m
//  SouthwestTravelManager
//
//  Created by Colin Regan on 8/20/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "GenericFlightTableViewController.h"

@interface GenericFlightTableViewController ()

- (void)updatePlaceholderText;
- (void)setCustomInputViews;

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
@synthesize airportPicker = _airportPicker;
@synthesize airportPickerVC = _airportPickerVC;
@synthesize origin = _origin;
@synthesize destination = _destination;
@synthesize confirmationCode = _confirmationCode;
@synthesize cost = _cost;
@synthesize expirationDate = _expirationDate;
@synthesize roundtrip = _roundtrip;
@synthesize outboundDepartureDate = _outboundDepartureDate;
@synthesize returnDepartureDate = _returnDepartureDate;
@synthesize checkInReminder = _checkInReminder;
@synthesize notes = _notes;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePlaceholderText];
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

- (void)setOrigin:(NSString *)origin {
    _origin = origin;
    if (self.destination) self.flightTextField.text = [NSString stringWithFormat:@"%@ - %@", origin, self.destination];
}

- (void)setDestination:(NSString *)destination {
    _destination = destination;
    if (self.origin) self.flightTextField.text = [NSString stringWithFormat:@"%@ - %@", self.origin, destination];
}

- (void)updatePlaceholderText {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.expirationTextField.placeholder = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    self.outboundTextField.placeholder = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*31)]];
    self.returnTextField.placeholder = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*36)]];
}

- (void)setCustomInputViews {
    self.flightTextField.inputView = self.airportPicker;
    self.costTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    // set up date pickers
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // move first responder to next text field
    if ([textField isEqual:self.confirmTextField]) [self.costTextField becomeFirstResponder];
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
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // update corresponding property
    if ([textField isEqual:self.confirmTextField]) {
        self.confirmationCode = self.confirmTextField.text;
        NSLog(@"%@", self.confirmationCode);
    } else if ([textField isEqual:self.costTextField]) {
        NSString *numberValue;
        if ([self.costTextField.text hasPrefix:@"$"]) numberValue = [self.costTextField.text substringFromIndex:1];
        self.cost = [NSNumber numberWithDouble:[numberValue doubleValue]];
        // TODO: use NSNumberFormatter to update text display
        NSLog(@"%@", self.cost);
    } else if ([textField isEqual:self.expirationTextField]) {
        
    }
}

- (void)airportPickerViewController:(AirportPickerViewController *)airportPickerVC selectedOrigin:(NSString *)origin andDestination:(NSString *)destination {
    self.origin = origin;
    self.destination = destination;
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
