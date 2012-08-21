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
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return TRUE;
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
