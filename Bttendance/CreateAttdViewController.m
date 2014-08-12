//
//  CreateAttdViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CreateAttdViewController.h"
#import "BTColor.h"
#import "AttendanceAgent.h"
#import "BTNotification.h"
#import <AudioToolbox/AudioServices.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface CreateAttdViewController ()

@property (assign) BOOL bt;
@property (assign) BOOL btno;

@end

@implementation CreateAttdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleDone target:self action:@selector(start:)];
    self.navigationItem.rightBarButtonItem = start;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [BTColor BT_white:1.0];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Attendance Check", nil);
    [titlelabel sizeToFit];
    
    self.detail.text = NSLocalizedString(@"출석체크가 모두 진행된 이후에도\n언제든지 출석 결과를 수정할 수 있습니다.", nil);
    self.detail.numberOfLines = 0;
    
    self.detail2.text = NSLocalizedString(@"출석체크를 어떤 방법으로 하실지 선택한후,\n시작 버튼을 누르세요.", nil);
    self.detail2.numberOfLines = 0;
    
    NSString *bluetoothStr1 = NSLocalizedString(@"Bluetooth로\n빠르게 출석체크", nil);
    NSString *bluetoothStr2 = NSLocalizedString(@"(예상시간: 1분)", nil);
    NSString *bluetoothTitle = [NSString stringWithFormat:@"%@\n%@", bluetoothStr1, bluetoothStr2];
    NSMutableAttributedString *bluetoothStr = [[NSMutableAttributedString alloc] initWithString:bluetoothTitle];
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([locale isEqualToString:@"ko"]) {
        [bluetoothStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[bluetoothTitle rangeOfString:bluetoothStr1]];
        [bluetoothStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:[bluetoothTitle rangeOfString:bluetoothStr2]];
    } else {
        [bluetoothStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0] range:[bluetoothTitle rangeOfString:bluetoothStr1]];
        [bluetoothStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:[bluetoothTitle rangeOfString:bluetoothStr2]];
    }
    
    self.bluetooth.attributedText = bluetoothStr;
    self.bluetooth.numberOfLines = 0;
    
    NSString *nobluetoothStr1 = NSLocalizedString(@"이름 부르면서\n출석체크하기", nil);
    NSString *nobluetoothStr2 = NSLocalizedString(@"(예상시간: 3~5분)", nil);
    NSString *nobluetoothTitle = [NSString stringWithFormat:@"%@\n%@", nobluetoothStr1, nobluetoothStr2];
    
    NSMutableAttributedString *nobluetoothStr = [[NSMutableAttributedString alloc] initWithString:nobluetoothTitle];
    if ([locale isEqualToString:@"ko"]) {
        [nobluetoothStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[nobluetoothTitle rangeOfString:nobluetoothStr1]];
        [nobluetoothStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:[nobluetoothTitle rangeOfString:nobluetoothStr2]];
    } else {
        [nobluetoothStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0] range:[nobluetoothTitle rangeOfString:nobluetoothStr1]];
        [nobluetoothStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:[nobluetoothTitle rangeOfString:nobluetoothStr2]];
    }
    self.nobluetooth.attributedText = nobluetoothStr;
    self.nobluetooth.numberOfLines = 0;
    
}

#pragma NavigationBarAction
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)start:(UIBarButtonItem *)sender {
    sender.enabled = NO;
    
    BOOL pass = YES;
    
    if (!self.bt && !self.btno)
        pass = NO;
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        self.selected_bg.backgroundColor = [BTColor BT_red:0.1];
        self.detail2.textColor = [BTColor BT_red:1];
        sender.enabled = YES;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Starting Attendance", nil);
    hud.yOffset = -40.0f;
    
    NSString *courseName = self.simpleCourse.name;
    NSString *courseID = [NSString stringWithFormat:@"%ld", (long)self.simpleCourse.id];
    NSString *type;
    if (self.bt)
        type = @"auto";
    else
        type = @"manual";
    [[AttendanceAgent sharedInstance] startAttendanceWithCourse:courseID
                                                  andCourseName:courseName
                                                        andType:type
                                                        success:^(Post *post) {
                                                            [hud hide:YES];
                                                            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:post, PostInfo, nil];
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:OpenNewPost object:nil userInfo:data];
                                                            [self.navigationController popViewControllerAnimated:NO];
                                                        } failure:^(NSError *error) {
                                                            [hud hide:YES];
                                                            sender.enabled = YES;
                                                        }];
}

#pragma IBActions
- (IBAction)bluetooth:(id)sender {
    self.bluetoothBt.backgroundColor = [BTColor BT_cyan:0.2];
    self.nobluetoothBt.backgroundColor = [BTColor BT_cyan:0.0];
    self.bt = YES;
}

- (IBAction)nobluetooth:(id)sender {
    self.bluetoothBt.backgroundColor = [BTColor BT_cyan:0.0];
    self.nobluetoothBt.backgroundColor = [BTColor BT_cyan:0.2];
    self.btno = YES;
}

@end
