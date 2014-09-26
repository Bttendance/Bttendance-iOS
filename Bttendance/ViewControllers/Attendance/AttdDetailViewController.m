//
//  AttdDetailViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 6..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "AttdDetailViewController.h"
#import "NSDate+Bttendance.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "BTNotification.h"
#import "BTBlink.h"
#import "AttdDetailListViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SocketAgent.h"

@interface AttdDetailViewController ()

@property (assign) BOOL auth;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Course *course;

@end

@implementation AttdDetailViewController
@synthesize post, messageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Attendance Check", nil);
    [titlelabel sizeToFit];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    self.user = [BTUserDefault getUser];
    self.course = [BTUserDefault getCourse:post.course.id];
    self.auth = [self.user supervising:post.course.id];
    
    self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20);
    
    if (self.auth) {
        UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [settingButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
        UIBarButtonItem *plusButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
        [self.navigationItem setRightBarButtonItem:plusButtonItem];
        self.tableview.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20 - 46 - 64);
        self.detailBt.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20 - 64 - 46, 320, 46);
        [self.detailBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
        [self.detailBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
        [self.detailBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
        [self.detailBt setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.textColor = [UIColor white:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = NSLocalizedString(@"출석결과 수정하기", nil);
        [label sizeToFit];
        
        CGFloat width = label.frame.size.width;
        CGFloat height = label.frame.size.height;
        label.frame = CGRectMake(160 - width / 2 + 15.5 / 2 + 8 / 2, 24 - height / 2, width, height);
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more.png"]];
        image.frame = CGRectMake(160 - width / 2 - 15.5 / 2 - 8 / 2, 23 - 15 / 2, 15.5, 15);
        
        [self.detailBt addSubview:label];
        [self.detailBt addSubview:image];
    } else {
        self.tableview.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttendance:) name:AttendanceUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePost:) name:PostUpdated object:nil];
    
    [[SocketAgent sharedInstance] socketConnect];
}

#pragma NSNotificationCenter
- (void)updateAttendance:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Attendance *attendance = [notification object];
    if (post.attendance.id != attendance.id)
        return;
    
    [post.attendance copyDataFromAttendance:attendance];
    [self.tableview reloadData];
}

- (void)updatePost:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Post *newPost = [notification object];
    if (post.id != newPost.id)
        return;
    
    post = newPost;
    [self.tableview reloadData];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.auth)
        return 7;
    else if (65.0f + [post.createdAt timeIntervalSinceNow] > 0.0f && [post.attendance.type isEqualToString:@"auto"])
        return 8;
    else
        return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return 35;
        case 1:
            return 38;
        case 2:
            if (self.auth)
                return 36;
            else
                return 62;
        case 3:
            return 200;
        case 4:
            if (self.auth)
                return 33;
            else
                return 60;
        case 5:
            if (self.auth)
                return 70;
            else
                return 0;
        case 6:
            if (self.auth)
                return 40;
            else
                return 0;
        case 7:
            return 40;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            return cell;
        }
        case 1: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            NSString *date = [NSDate dateStringFromDate:post.createdAt];
            NSString *time = [NSDate timeStringFromDate:post.createdAt];
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            dateLabel.text = date;
            dateLabel.font = [UIFont systemFontOfSize:12];
            dateLabel.textColor = [UIColor navy:1];
            [dateLabel sizeToFit];
            
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            timeLabel.text = time;
            timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:29];
            timeLabel.textColor = [UIColor navy:1];
            [timeLabel sizeToFit];
            
            NSString *title1 = NSLocalizedString(@"자동 출석체크 완료!", nil); //auto done
            NSString *title2 = NSLocalizedString(@"출석체크 진행중", nil); //auto on-going
            NSString *title3 = NSLocalizedString(@"수동 출석체크", nil); //manual
            
            int leftTime = MAX(MIN(60, 65.0f + [post.createdAt timeIntervalSinceNow]), 0);
            NSString *message1 = [NSString stringWithFormat:NSLocalizedString(@"%d초 남았습니다.", nil), leftTime];
            NSString *message2 = NSLocalizedString(@"출석 현황 입니다.", nil);
            NSString *message3 = NSLocalizedString(@"출석이 확인되었습니다.", nil);
            NSString *message4 = NSLocalizedString(@"결석으로 처리되었습니다.", nil);
            NSString *message5 = NSLocalizedString(@"지각으로 처리되었습니다.", nil);
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            if (self.auth) {
                if ([post.attendance.type isEqualToString:@"manual"])
                    titleLabel.text = title3;
                else if (65.0f + [post.createdAt timeIntervalSinceNow] > 0.0f)
                    titleLabel.text = title2;
                else
                    titleLabel.text = title1;
            } else {
                if ([post.attendance.type isEqualToString:@"manual"])
                    titleLabel.text = title3;
                else if ([self.post.attendance stateInt:self.user.id] == 0 && 65.0f + [post.createdAt timeIntervalSinceNow] > 0.0f)
                    titleLabel.text = title2;
                else
                    titleLabel.text = title1;
            }
            titleLabel.font = [UIFont boldSystemFontOfSize:16];
            titleLabel.textColor = [UIColor navy:1];
            [titleLabel sizeToFit];
            
            [self.timer invalidate];
            self.timer = nil;
            
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            messageLabel.textColor = [UIColor navy:1];
            if (self.auth) {
                if (65.0f + [post.createdAt timeIntervalSinceNow] > 0.0f
                    && [post.attendance.type isEqualToString:@"auto"]) {
                    messageLabel.text = message1;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(attendanceTimer) userInfo:nil repeats:YES];
                } else
                    messageLabel.text = message2;
            } else {
                if ([self.post.attendance stateInt:self.user.id] == 0
                    && 65.0f + [post.createdAt timeIntervalSinceNow] > 0.0f
                    && [post.attendance.type isEqualToString:@"auto"]) {
                    messageLabel.text = message1;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(attendanceTimer) userInfo:nil repeats:YES];
                } else if ([self.post.attendance stateInt:self.user.id] == 0) {
                    messageLabel.text = message4;
                    messageLabel.textColor = [UIColor silver:1];
                } else if ([self.post.attendance stateInt:self.user.id] == 1) {
                    messageLabel.text = message3;
                    messageLabel.textColor = [UIColor navy:1];
                } else if ([self.post.attendance stateInt:self.user.id] == 2) {
                    messageLabel.text = message5;
                    messageLabel.textColor = [UIColor cyan:1];
                }
            }
            messageLabel.font = [UIFont systemFontOfSize:16];
            [messageLabel sizeToFit];
            
            CGFloat max1 = MAX(dateLabel.frame.size.width , timeLabel.frame.size.width);
            CGFloat max2 = MAX(titleLabel.frame.size.width , messageLabel.frame.size.width);
            CGFloat width = max1 + 21 + max2;
            
            dateLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.textAlignment = NSTextAlignmentRight;
            titleLabel.textAlignment = NSTextAlignmentLeft;
            messageLabel.textAlignment = NSTextAlignmentLeft;
            
            dateLabel.frame = CGRectMake(160 - width/2, 0, max1, dateLabel.frame.size.height);
            timeLabel.frame = CGRectMake(160 - width/2 + 1, 10, max1, timeLabel.frame.size.height);
            titleLabel.frame = CGRectMake(160 - width/2 + 21 + max1, 1, max2, titleLabel.frame.size.height);
            messageLabel.frame = CGRectMake(160 - width/2 + 20 + max1, 21, max2, messageLabel.frame.size.height);
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(160 - width/2 + 10 + max1, 3, 1, 35)];
            line.backgroundColor = [UIColor navy:1];
            [cell addSubview:line];
            
            [cell addSubview:dateLabel];
            [cell addSubview:timeLabel];
            [cell addSubview:titleLabel];
            [cell addSubview:messageLabel];
            
            return cell;
        }
        case 2: {
            if (self.auth) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor white:1];
                return cell;
            } else {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor white:1];
                return cell;
            }
        }
        case 3: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            UIView *image = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 200, 200)];
            image.backgroundColor = [UIColor cyan:1];
            image.layer.cornerRadius = 100;
            image.clipsToBounds = YES;
            [cell addSubview:image];
            
            UIView *image2 = [[UIView alloc] initWithFrame:CGRectMake(69, 9, 182, 182)];
            image2.backgroundColor = [UIColor navy:1];
            image2.layer.cornerRadius = 91;
            image2.clipsToBounds = YES;
            [cell addSubview:image2];
            
            UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 200, 200)];
            
            //Auth
            if (self.auth) {
                [image3 setImage:[UIImage imageNamed:@"big_check.png"]];
                NSInteger count = 65 + [post.createdAt timeIntervalSinceNow];
                if (count > 0) {
                    BlinkView *blinkView = [[BlinkView alloc] initWithView:image3 andCount:count];
                    [[BTBlink sharedInstance] addBlinkView:blinkView];
                }
            
                CGFloat grade = 0;
                if (self.course.students_count != 0)
                    grade = ((float)self.post.attendance.checked_students.count + (float)self.post.attendance.late_students.count) / (float)self.course.students_count;
                UIView *top = [[UIView alloc] initWithFrame:CGRectMake(69, 9, 182, 182 * (1-grade))];
                top.backgroundColor = [UIColor white:1];
                [cell addSubview:top];
                
                UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 200, 200)];
                [image4 setImage:[UIImage imageNamed:@"big_ring.png"]];
                [cell addSubview:image4];
            }
            //Attended
            else if ([self.post.attendance stateInt:self.user.id] == 1) {
                image.backgroundColor = [UIColor navy:1];
                image2.backgroundColor = [UIColor white:1];
                [image3 setImage:[UIImage imageNamed:@"big_attended.png"]];
            }
            //Late
            else if ([self.post.attendance stateInt:self.user.id] == 2) {
                image.backgroundColor = [UIColor cyan:1];
                image2.backgroundColor = [UIColor white:1];
                [image3 setImage:[UIImage imageNamed:@"big_late.png"]];
            }
            //Abscent
            else if ([self.post.attendance stateInt:self.user.id] == 0 && [post.createdAt timeIntervalSinceNow] <= -65.0f) {
                image.backgroundColor = [UIColor silver:1];
                image2.backgroundColor = [UIColor white:1];
                [image3 setImage:[UIImage imageNamed:@"big_abscent.png"]];
            }
            //Attendance on-going
            else {
                [image3 setImage:[UIImage imageNamed:@"big_check.png"]];
                NSInteger count = 65 + [post.createdAt timeIntervalSinceNow];
                BlinkView *blinkView = [[BlinkView alloc] initWithView:image3 andCount:count];
                [[BTBlink sharedInstance] addBlinkView:blinkView];
                
                CGFloat grade = MIN(60.0f, 65.0f + [post.createdAt timeIntervalSinceNow]) / 60.0f;
                UIView *top = [[UIView alloc] initWithFrame:CGRectMake(69, 9, 182, 182 * (1-grade))];
                top.backgroundColor = [UIColor white:1];
                [cell addSubview:top];
                
                [UIView animateWithDuration:65.0f + [post.createdAt timeIntervalSinceNow]
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     top.frame = CGRectMake(69, 9, 182, 182);
                                 }
                                 completion:^(BOOL finished) {
                                 }];
                
                UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 200, 200)];
                [image4 setImage:[UIImage imageNamed:@"big_ring.png"]];
                [cell addSubview:image4];
            }
            
            [cell addSubview:image3];
            
            return cell;
        }
        case 4: {
            if (self.auth) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor white:1];
                return cell;
            } else {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor white:1];
                return cell;
            }
        }
        case 5: {
            if (self.auth) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor white:1];
                
                UILabel *attd = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                attd.text = [NSString stringWithFormat:NSLocalizedString(@"%ld명", nil), (long) (self.post.attendance.checked_students.count + self.post.attendance.late_students.count)];
                attd.font = [UIFont boldSystemFontOfSize:27];
                attd.textColor = [UIColor cyan:1];
                [attd sizeToFit];
                
                UILabel *std = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                std.text = [NSString stringWithFormat:NSLocalizedString(@"%ld명", nil), (long) (self.course.students_count)];
                std.font = [UIFont boldSystemFontOfSize:27];
                std.textColor = [UIColor navy:1];
                [std sizeToFit];
                
                UILabel *percent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                percent.text = [NSString stringWithFormat:NSLocalizedString(@"출석(%ld%%)", nil), (long) ceil((((float)self.post.attendance.checked_students.count + (float)self.post.attendance.late_students.count) / (float)self.course.students_count * 100.0f))];
                percent.font = [UIFont systemFontOfSize:12];
                percent.textColor = [UIColor navy:1];
                [percent sizeToFit];
                
                CGFloat max = MAX(MAX(attd.frame.size.width, std.frame.size.width), percent.frame.size.width);
                CGFloat max2 = MAX(attd.frame.size.width, std.frame.size.width);
                
                attd.textAlignment = NSTextAlignmentCenter;
                std.textAlignment = NSTextAlignmentCenter;
                percent.textAlignment = NSTextAlignmentCenter;
                
                attd.frame = CGRectMake(160 - max/2, 0, max, attd.frame.size.height);
                std.frame = CGRectMake(160 - max/2, 32, max, std.frame.size.height);
                percent.frame = CGRectMake(160 - max/2, 64, max, percent.frame.size.height);
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(160 - max2/2 + 1, 30.5, max2 - 2, 1.5)];
                line.backgroundColor = [UIColor navy:1];
                [cell addSubview:line];
                
                [cell addSubview:attd];
                [cell addSubview:std];
                [cell addSubview:percent];
                
                return cell;
            } else {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor white:1];
                return cell;
            }
        }
        case 6: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            return cell;
        }
        case 7: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            return cell;
        }
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            return cell;
        }
    }
}

#pragma NSTimer Action
- (void)attendanceTimer {
    NSInteger leftTime = MIN(60, (ceil)(65.0f + [self.post.createdAt timeIntervalSinceNow]));
    messageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d초 남았습니다.", nil), leftTime];
    if (leftTime <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.tableview reloadData];
    }
}

#pragma NavigationBarAction
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setting:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"Delete Attendance", nil)
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma IBAction
- (IBAction)showDetail:(id)sender {
    AttdDetailListViewController *attdDetailsView = [[AttdDetailListViewController alloc] initWithNibName:@"AttdDetailListViewController" bundle:nil];
    attdDetailsView.post = post;
    [self.navigationController pushViewController:attdDetailsView animated:YES];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        [self deleteAttd];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSString *message = NSLocalizedString(@"Do you really wish to delete current attendance record?", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Attendance", nil)
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
        [alert show];
    }
}

#pragma private methods
- (void)deleteAttd {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Deleting Attendance", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs removePost:[NSString stringWithFormat:@"%ld", (long)post.id]
               success:^(Post *post) {
                   [self.navigationController popViewControllerAnimated:YES];
                   [hud hide:YES];
               } failure:^(NSError *error) {
                   [hud hide:YES];
               }];
}

@end
