//
//  DataEntryCell.h
//  SouthwestTravelManager
//
//  Created by Colin Regan on 10/1/12.
//  Copyright (c) 2012 Red Cup. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataEntryCell;

@protocol DataEntryCellDelegate <NSObject>

- (void)dataEntryCell:(DataEntryCell *)sender textFieldDidReturn:(UITextField *)textField;

@end

@interface DataEntryCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) id <DataEntryCellDelegate> delegate;

@end
