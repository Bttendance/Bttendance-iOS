//
//  ClickerDetailViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerDetailViewController.h"
#import "NSDate+Bttendance.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTAPIs.h"
#import "XYPieChart.h"
#import "BTUserDefault.h"
#import "BTNotification.h"
#import "ClickerCRUDViewController.h"
#import "ClickerDetailListViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SocketAgent.h"
#import <AudioToolbox/AudioServices.h>
#import "BTDatabase.h"

@interface ClickerDetailViewController ()

@property (assign) BOOL auth;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Course *course;

@end

@implementation ClickerDetailViewController
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
    titlelabel.text = NSLocalizedString(@"Clicker", nil);
    [titlelabel sizeToFit];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    self.user = [BTDatabase getUser];
    self.course = [BTDatabase getCourseWithID:post.course.id];
    self.auth = [self.user supervising:post.course.id];
    
    self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20);
    
    if ([@"all" isEqualToString:self.post.clicker.detail_privacy]
        || ([@"professor" isEqualToString:self.post.clicker.detail_privacy] && self.auth)) {
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
        label.text = NSLocalizedString(@"상세보기", nil);
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
    
    self.chart = [[XYPieChart alloc] initWithFrame:CGRectMake(63, 3, 194, 194)];
    self.chart.showLabel = NO;
    self.chart.pieRadius = 97;
    self.chart.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClicker:) name:ClickerUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePost:) name:PostUpdated object:nil];
    
    [[SocketAgent sharedInstance] socketConnect];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.chart reloadData];
}

#pragma NSNotificationCenter
- (void)updateClicker:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Clicker *clicker = [notification object];
    if (post.clicker.id != clicker.id)
        return;
    
    [post.clicker copyDataFromClicker:clicker];
    [self.chart reloadData];
    [self.tableview reloadData];
}

- (void)updatePost:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Post *newPost = [notification object];
    if (post.id != newPost.id)
        return;
    
    post = newPost;
    [self.chart reloadData];
    [self.tableview reloadData];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.auth)
        return 9;
    else
        return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return 35;
        case 1:
        {
            UIFont *cellfont = [UIFont boldSystemFontOfSize:14];
            NSString *rawmessage = post.message;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            return ceil(MessageLabelSize.size.height);
        }
        case 2: {
            UIFont *cellfont = [UIFont boldSystemFontOfSize:12];
            NSString *rawmessage1 = [NSString stringWithFormat:NSLocalizedString(@"%1$@/%2$ld명 참여, %3$@", nil), [post.clicker participation], self.course.students_count, [post createdDateWholeFormat]];
            NSInteger left = MIN(post.clicker.progress_time, (ceil)(post.clicker.progress_time + 5 + [self.post createdDateTimeInterval]));
            NSString *rawmessage2 = [NSString stringWithFormat:NSLocalizedString(@"Clicker Ongoing (%ld sec left)", nil), left];
            NSString *rawmessage;
            if (left >= 0)
                rawmessage = [NSString stringWithFormat:@"%@\n%@", rawmessage1, rawmessage2];
            else
                rawmessage = rawmessage1;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            return ceil(MessageLabelSize.size.height) + 3;
        }
        case 3:
            return 35;
        case 4:
            return 200;
        case 5:
            return 20;
        case 6:
            return 85;
        case 7:
            return 20;
        case 8:
            if (self.auth)
                return 62;
            else
                return 40;
        case 9:
            return 62;
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
            UIFont *cellfont = [UIFont boldSystemFontOfSize:14];
            NSString *rawmessage = post.message;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, ceil(MessageLabelSize.size.height))];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, ceil(MessageLabelSize.size.height))];
            label.font = [UIFont boldSystemFontOfSize:14];
            label.text = post.message;
            label.textColor = [UIColor navy:1];
            label.numberOfLines = 0;
            [label sizeToFit];
            label.frame = CGRectMake(20, 0, 280, ceil(MessageLabelSize.size.height));
            label.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:label];
            
            return cell;
        }
        case 2: {
            UIFont *cellfont = [UIFont boldSystemFontOfSize:12];
            NSString *rawmessage1 = [NSString stringWithFormat:NSLocalizedString(@"%1$@/%2$ld명 참여, %3$@", nil), [post.clicker participation], self.course.students_count, [post createdDateWholeFormat]];
            NSInteger left = MIN(post.clicker.progress_time, (ceil)(post.clicker.progress_time + 5 + [self.post createdDateTimeInterval]));
            NSString *rawmessage2 = [NSString stringWithFormat:NSLocalizedString(@"Clicker Ongoing (%ld sec left)", nil), left];
            NSString *rawmessage;
            if (left >= 0) {
                rawmessage = [NSString stringWithFormat:@"%@\n%@", rawmessage1, rawmessage2];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clickerTimer) userInfo:nil repeats:YES];
            } else
                rawmessage = rawmessage1;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, ceil(MessageLabelSize.size.height) + 3)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 280, ceil(MessageLabelSize.size.height))];
            messageLabel.font = [UIFont systemFontOfSize:12];
            messageLabel.text = rawmessage;
            messageLabel.textColor = [UIColor silver:1];
            messageLabel.numberOfLines = 0;
            [messageLabel sizeToFit];
            messageLabel.frame = CGRectMake(20, 3, 280, ceil(MessageLabelSize.size.height));
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:messageLabel];
            
            return cell;
        }
        case 3: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            return cell;
        }
        case 4: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            UIView *image = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 200, 200)];
            image.backgroundColor = [UIColor navy:1];
            image.layer.cornerRadius = 100;
            image.clipsToBounds = YES;
            [cell addSubview:image];
            
            UIView *image2 = [[UIView alloc] initWithFrame:CGRectMake(64, 4, 192, 192)];
            image2.backgroundColor = [UIColor white:1];
            image2.layer.cornerRadius = 96;
            image2.clipsToBounds = YES;
            [cell addSubview:image2];
            
            [cell addSubview:self.chart];
            
            if (!self.post.clicker.show_info_on_select && self.post.clicker.progress_time + 5 + [post createdDateTimeInterval] > 0.0f && !self.auth)
                [self.chart setDataSource:nil];
            else {
                [self.chart setDataSource:post.clicker];
                [self.chart reloadData];
            }
            
            return cell;
        }
        case 5: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            return cell;
        }
        case 6: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            CGFloat width = post.clicker.choice_count * 51.5 - 15.5;
            CGFloat left = 160 - width / 2;
            
            UIImageView *aImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_A.png"]];
            UIImageView *bImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_B.png"]];
            UIImageView *cImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_C.png"]];
            UIImageView *dImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_D.png"]];
            UIImageView *eImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_E.png"]];
            
            aImage.frame = CGRectMake(left, 0, 36, 36);
            bImage.frame = CGRectMake(left + 51, 0, 36, 36);
            cImage.frame = CGRectMake(left + 51 * 2, 0, 36, 36);
            dImage.frame = CGRectMake(left + 51 * 3, 0, 36, 36);
            eImage.frame = CGRectMake(left + 51 * 4, 0, 36, 36);
            
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(left - 5, 44, 46, 14)];
            UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(left + 51 - 5, 44, 46, 14)];
            UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(left + 51 * 2 - 5, 44, 46, 14)];
            UILabel *dLabel = [[UILabel alloc] initWithFrame:CGRectMake(left + 51 * 3 - 5, 44, 46, 14)];
            UILabel *eLabel = [[UILabel alloc] initWithFrame:CGRectMake(left + 51 * 4 - 5, 44, 46, 14)];
            
            NSString *aPercent = [post.clicker percent:1];
            NSString *bPercent = [post.clicker percent:2];
            NSString *cPercent = [post.clicker percent:3];
            NSString *dPercent = [post.clicker percent:4];
            NSString *ePercent = [post.clicker percent:5];
            
//            NSInteger aCount = post.clicker.a_students.count;
//            NSInteger bCount = post.clicker.b_students.count;
//            NSInteger cCount = post.clicker.c_students.count;
//            NSInteger dCount = post.clicker.d_students.count;
//            NSInteger eCount = post.clicker.e_students.count;
            
            NSInteger aCount = 0;
            NSInteger bCount = 0;
            NSInteger cCount = 0;
            NSInteger dCount = 0;
            NSInteger eCount = 0;
            
            if (!self.post.clicker.show_info_on_select && self.post.clicker.progress_time + 5 + [post createdDateTimeInterval] > 0.0f && !self.auth) {
                aPercent = @"0";
                bPercent = @"0";
                cPercent = @"0";
                dPercent = @"0";
                ePercent = @"0";
                aCount = 0;
                bCount = 0;
                cCount = 0;
                dCount = 0;
                eCount = 0;
            }
            
            NSString *aTitle = [NSString stringWithFormat:@"%@%%", aPercent];
            NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:aTitle];
            [aStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[aTitle rangeOfString:[NSString stringWithFormat:@"%@", aPercent]]];
            [aStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11.0] range:[aTitle rangeOfString:@"%"]];
            aLabel.textColor = [UIColor navy:1.0];
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.attributedText = aStr;
            
            NSString *bTitle = [NSString stringWithFormat:@"%@%%", bPercent];
            NSMutableAttributedString *bStr = [[NSMutableAttributedString alloc] initWithString:bTitle];
            [bStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[bTitle rangeOfString:[NSString stringWithFormat:@"%@", bPercent]]];
            [bStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11.0] range:[bTitle rangeOfString:@"%"]];
            bLabel.textColor = [UIColor navy:1.0];
            bLabel.textAlignment = NSTextAlignmentCenter;
            bLabel.attributedText = bStr;
            
            NSString *cTitle = [NSString stringWithFormat:@"%@%%", cPercent];
            NSMutableAttributedString *cStr = [[NSMutableAttributedString alloc] initWithString:cTitle];
            [cStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[cTitle rangeOfString:[NSString stringWithFormat:@"%@", cPercent]]];
            [cStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11.0] range:[cTitle rangeOfString:@"%"]];
            cLabel.textColor = [UIColor navy:1.0];
            cLabel.textAlignment = NSTextAlignmentCenter;
            cLabel.attributedText = cStr;
            
            NSString *dTitle = [NSString stringWithFormat:@"%@%%", dPercent];
            NSMutableAttributedString *dStr = [[NSMutableAttributedString alloc] initWithString:dTitle];
            [dStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[dTitle rangeOfString:[NSString stringWithFormat:@"%@", dPercent]]];
            [dStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11.0] range:[dTitle rangeOfString:@"%"]];
            dLabel.textColor = [UIColor navy:1.0];
            dLabel.textAlignment = NSTextAlignmentCenter;
            dLabel.attributedText = dStr;
            
            NSString *eTitle = [NSString stringWithFormat:@"%@%%", ePercent];
            NSMutableAttributedString *eStr = [[NSMutableAttributedString alloc] initWithString:eTitle];
            [eStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[eTitle rangeOfString:[NSString stringWithFormat:@"%@", ePercent]]];
            [eStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11.0] range:[eTitle rangeOfString:@"%"]];
            eLabel.textColor = [UIColor navy:1.0];
            eLabel.textAlignment = NSTextAlignmentCenter;
            eLabel.attributedText = eStr;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(left, 64, width, 0.7)];
            line.backgroundColor = [UIColor navy:1];
            
            UILabel *aLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(left, 73, 36, 14)];
            UILabel *bLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(left + 51, 73, 36, 14)];
            UILabel *cLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(left + 51 * 2, 73, 36, 14)];
            UILabel *dLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(left + 51 * 3, 73, 36, 14)];
            UILabel *eLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(left + 51 * 4, 73, 36, 14)];
            
            aLabel2.textColor = [UIColor silver:1];
            aLabel2.font = [UIFont systemFontOfSize:12];
            aLabel2.text = [NSString stringWithFormat:NSLocalizedString(@"%ld명", nil), (long)aCount];
            aLabel2.textAlignment = NSTextAlignmentCenter;
            
            bLabel2.textColor = [UIColor silver:1];
            bLabel2.font = [UIFont systemFontOfSize:12];
            bLabel2.text = [NSString stringWithFormat:NSLocalizedString(@"%ld명", nil), (long)bCount];
            bLabel2.textAlignment = NSTextAlignmentCenter;
            
            cLabel2.textColor = [UIColor silver:1];
            cLabel2.font = [UIFont systemFontOfSize:12];
            cLabel2.text = [NSString stringWithFormat:NSLocalizedString(@"%ld명", nil), (long)cCount];
            cLabel2.textAlignment = NSTextAlignmentCenter;
            
            dLabel2.textColor = [UIColor silver:1];
            dLabel2.font = [UIFont systemFontOfSize:12];
            dLabel2.text = [NSString stringWithFormat:NSLocalizedString(@"%ld명", nil), (long)dCount];
            dLabel2.textAlignment = NSTextAlignmentCenter;
            
            eLabel2.textColor = [UIColor silver:1];
            eLabel2.font = [UIFont systemFontOfSize:12];
            eLabel2.text = [NSString stringWithFormat:NSLocalizedString(@"%ld명", nil), (long)eCount];
            eLabel2.textAlignment = NSTextAlignmentCenter;
            
            switch (post.clicker.choice_count) {
                case 2:
                    cImage.hidden = YES;
                    cLabel.hidden = YES;
                    cLabel2.hidden = YES;
                case 3:
                    dImage.hidden = YES;
                    dLabel.hidden = YES;
                    dLabel2.hidden = YES;
                case 4:
                    eImage.hidden = YES;
                    eLabel.hidden = YES;
                    eLabel2.hidden = YES;
                default:
                    break;
            }
            
            [cell addSubview:aImage];
            [cell addSubview:bImage];
            [cell addSubview:cImage];
            [cell addSubview:dImage];
            [cell addSubview:eImage];
            [cell addSubview:aLabel];
            [cell addSubview:bLabel];
            [cell addSubview:cLabel];
            [cell addSubview:dLabel];
            [cell addSubview:eLabel];
            [cell addSubview:line];
            [cell addSubview:aLabel2];
            [cell addSubview:bLabel2];
            [cell addSubview:cLabel2];
            [cell addSubview:dLabel2];
            [cell addSubview:eLabel2];
            
            return cell;
        }
        case 7: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            return cell;
        }
        case 8:
        if (!self.auth) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 14)];
            if ([post.clicker choice:self.user.id] == nil)
                label.text = NSLocalizedString(@"답변을 선택하지 않으셨습니다.", nil);
            else
                label.text = [NSString stringWithFormat:NSLocalizedString(@"%@을 선택하셨습니다.", nil), [post.clicker choice:self.user.id]];
            label.textColor = [UIColor navy:1];
            label.font = [UIFont boldSystemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:label];
            
            return cell;
        }
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor grey:1.0];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 288, 36)];
            label.textColor = [UIColor silver:1.0];
            label.font = [UIFont systemFontOfSize:12];
            
            NSString *progressTimeMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 시작되면 %d분간 답변을 수집합니다.", nil), (int)(self.post.clicker.progress_time/60)];
            NSString *showInfoOnSelectMessage, *detailPrivacyMessage;
            if (self.post.clicker.show_info_on_select)
                showInfoOnSelectMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 진행되는 동안 학생들이 결과를 볼 수 있습니다.", nil)];
            else
                showInfoOnSelectMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 끝난 후에야 학생들이 결과를 볼 수 있습니다.", nil)];
            if ([@"professor" isEqualToString:self.post.clicker.detail_privacy])
                detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 강의자만 상세 결과를 볼 수 있습니다.", nil)];
            else if ([@"all" isEqualToString:self.post.clicker.detail_privacy])
                detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 모두 상세 결과를 볼 수 있습니다.", nil)];
            else
                detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 아무도 상세 결과를 볼 수 없습니다.", nil)];
            
            NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@", detailPrivacyMessage, showInfoOnSelectMessage, progressTimeMessage];
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:message];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:[NSString stringWithFormat:NSLocalizedString(@"%d분간", nil), (int)(self.post.clicker.progress_time/60)]]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"진행되는 동안", nil)]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"끝난 후에야", nil)]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"강의자만", nil)]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"모두", nil)]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"아무도", nil)]];
            
            label.attributedText = attributed;
            label.numberOfLines = 0;
            [label sizeToFit];
            [cell addSubview:label];
            return cell;
        }
    }
}

#pragma NSTimer Action
- (void)clickerTimer {
    NSInteger leftTime = MIN(self.post.clicker.progress_time, (ceil)(self.post.clicker.progress_time + 5 + [self.post createdDateTimeInterval]));
    NSString *rawmessage1 = [NSString stringWithFormat:NSLocalizedString(@"%1$@/%2$ld명 참여, %3$@", nil), [post.clicker participation], self.course.students_count, [post createdDateWholeFormat]];
    NSString *rawmessage2 = [NSString stringWithFormat:NSLocalizedString(@"Clicker Ongoing (%ld sec left)", nil), leftTime];
    NSString *rawmessage;
    rawmessage = [NSString stringWithFormat:@"%@\n%@", rawmessage1, rawmessage2];
    messageLabel.text = rawmessage;
    if (leftTime <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.tableview reloadData];
//        [NSTimer scheduledTimerWithTimeInterval:5
//                                         target:self
//                                       selector:@selector(refreshFeed:)
//                                       userInfo:nil
//                                        repeats:NO];
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
                                               destructiveButtonTitle:NSLocalizedString(@"Delete Clicker", nil)
                                                    otherButtonTitles:NSLocalizedString(@"Edit Message", nil), nil];
    [actionSheet showInView:self.view];
}

#pragma IBAction
- (IBAction)showDetail:(id)sender {
//    if (!self.post.clicker.show_info_on_select && self.post.clicker.progress_time + 5 + [post createdTimeInterval] > 0.0f && !self.auth) {
//        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
//        return;
//    }
    ClickerDetailListViewController *clickerDetailsView = [[ClickerDetailListViewController alloc] initWithNibName:@"ClickerDetailListViewController" bundle:nil];
    clickerDetailsView.post = post;
    [self.navigationController pushViewController:clickerDetailsView animated:YES];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        [self deleteClicker];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSString *message = NSLocalizedString(@"Do you really wish to delete current clicker?", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Clicker", nil)
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
        [alert show];
    }
    
    if (buttonIndex == 1)
        [self editMessage];
}

#pragma private methods
- (void)editMessage {
    ClickerCRUDViewController *editClicker = [[ClickerCRUDViewController alloc] initWithStyle:UITableViewStylePlain];
    editClicker.clickerType = CLICKER_EDIT;
    editClicker.post = self.post;
    [self.navigationController pushViewController:editClicker animated:YES];
}

- (void)deleteClicker {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Deleting Clicker", nil);
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
