//
//  AirportPickerViewController.m
//  SouthwestTravelFundsManager
//
//  Created by Colin Regan on 8/21/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import "AirportPickerViewController.h"

@interface AirportPickerViewController ()

@property (nonatomic, strong) NSArray *allAirports;

@end

@implementation AirportPickerViewController

@synthesize airportPicker = _airportPicker;
@synthesize delegate = _delegate;
@synthesize allAirports = _allAirports;

- (NSArray *)allAirports {
    if (!_allAirports) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"airportInfo" ofType:@"plist"];
        _allAirports = [NSArray arrayWithContentsOfFile:file];
    }
    return _allAirports;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.allAirports.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.allAirports objectAtIndex:row] objectForKey:AIRPORT_CODE];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *origin = [self.allAirports objectAtIndex:[self.airportPicker selectedRowInComponent:0]];
    NSDictionary *destination = [self.allAirports objectAtIndex:[self.airportPicker selectedRowInComponent:1]];
    [self.delegate airportPickerViewController:self selectedOrigin:origin andDestination:destination];
}

- (void)setSelectedOrigin:(NSDictionary *)origin andDestination:(NSDictionary *)destination {
    [self.airportPicker selectRow:[self.allAirports indexOfObject:origin] inComponent:0 animated:FALSE];
    [self.airportPicker selectRow:[self.allAirports indexOfObject:destination] inComponent:1 animated:FALSE];
    [self.delegate airportPickerViewController:self selectedOrigin:origin andDestination:destination];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
