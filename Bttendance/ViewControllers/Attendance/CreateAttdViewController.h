//
//  CreateAttdViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface CreateAttdViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIView *selected_bg;

@property(weak, nonatomic) IBOutlet UILabel *bluetooth;
@property(weak, nonatomic) IBOutlet UILabel *nobluetooth;
@property(weak, nonatomic) IBOutlet UILabel *detail;
@property(weak, nonatomic) IBOutlet UILabel *detail2;

@property(weak, nonatomic) IBOutlet UIButton *bluetoothBt;
@property(weak, nonatomic) IBOutlet UIButton *nobluetoothBt;

- (IBAction)bluetooth:(id)sender;
- (IBAction)nobluetooth:(id)sender;

@property(strong, nonatomic) SimpleCourse *simpleCourse;

@end
