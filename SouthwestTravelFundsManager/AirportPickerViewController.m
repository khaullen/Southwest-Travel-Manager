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
        NSString *file = [[NSBundle mainBundle] pathForResource:@"airports" ofType:@"plist"];
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
    return [self.allAirports objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *origin = [self.allAirports objectAtIndex:[self.airportPicker selectedRowInComponent:0]];
    NSString *destination = [self.allAirports objectAtIndex:[self.airportPicker selectedRowInComponent:1]];
    [self.delegate airportPickerViewController:self selectedOrigin:origin andDestination:destination];
}

- (NSTimeZone *)timeZoneForAirport:(NSString *)airport {
    // TODO: implement this method
    return [NSTimeZone defaultTimeZone];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
