//
//  NoticeDetailViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NSDate+Bttendance.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "BTNotification.h"
#import "NoticeDetailListViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface NoticeDetailViewController ()

@property (assign) BOOL auth;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) Course *course;

@end

@implementation NoticeDetailViewController
@synthesize post;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Notice", nil);
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotice:) name:NoticeUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePost:) name:PostUpdated object:nil];
    
    if (!self.auth && ![self.post.notice seen:self.user.id]) {
        [BTAPIs seenWithNotice:[NSString stringWithFormat:@"%ld", (long)self.post.notice.id]
                       success:^(Notice *notice) {
                       } failure:^(NSError *error) {
                       }];
    }
}

#pragma NSNotificationCenter
- (void)updateNotice:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Notice *notice = [notification object];
    if (post.notice.id != notice.id)
        return;
    
    [post.notice copyDataFromNotice:notice];
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            UIFont *cellfont = [UIFont systemFontOfSize:12];
            NSString *date = [NSDate detailedStringFromDate:self.post.createdAt];
            NSInteger seen = self.post.notice.seen_students.count;
            NSInteger total = self.course.students_count;
            NSInteger rate = (int) ceil(((float)self.post.notice.seen_students.count/(float)self.course.students_count) * 100);
            NSString *rawmessage;
            if (self.auth)
                rawmessage = [NSString stringWithFormat:NSLocalizedString(@"* %@에 작성된 공지입니다.\n* %ld/%ld (%ld%%)명의 학생이 공지를 읽었습니다.", nil), date, seen, total, rate];
            else if ([self.post.notice seen:self.user.id])
                rawmessage = [NSString stringWithFormat:NSLocalizedString(@"* %@에 작성된 공지입니다.\n* 공지를 읽었습니다.", nil), date, seen, total, rate];
            else
                rawmessage = [NSString stringWithFormat:NSLocalizedString(@"* %@에 작성된 공지입니다.\n* 공지를 읽지 않았습니다.", nil), date, seen, total, rate];
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            return ceil(MessageLabelSize.size.height) + 14;
        }
        case 1: {
            UIFont *cellfont = [UIFont systemFontOfSize:14];
            NSString *rawmessage = post.message;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){230, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            return ceil(MessageLabelSize.size.height) + 11;
        }
        case 2:
            return 40;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            UIFont *cellfont = [UIFont systemFontOfSize:12];
            NSString *date = [NSDate detailedStringFromDate:self.post.createdAt];
            NSInteger seen = self.post.notice.seen_students.count;
            NSInteger total = self.course.students_count;
            NSInteger rate = (int) ceil(((float)self.post.notice.seen_students.count/(float)self.course.students_count) * 100);
            NSString *rawmessage;
            if (self.auth)
                rawmessage = [NSString stringWithFormat:NSLocalizedString(@"* %@에 작성된 공지입니다.\n* %ld/%ld (%ld%%)명의 학생이 공지를 읽었습니다.", nil), date, seen, total, rate];
            else if ([self.post.notice seen:self.user.id])
                rawmessage = [NSString stringWithFormat:NSLocalizedString(@"* %@에 작성된 공지입니다.\n* 공지를 읽었습니다.", nil), date, seen, total, rate];
            else
                rawmessage = [NSString stringWithFormat:NSLocalizedString(@"* %@에 작성된 공지입니다.\n* 공지를 읽지 않았습니다.", nil), date, seen, total, rate];
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, ceil(MessageLabelSize.size.height) + 10)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor grey:1];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 280, 0)];
            label.textColor = [UIColor silver:1];
            label.font = [UIFont systemFontOfSize:12];
            label.text = rawmessage;
            label.numberOfLines = 0;
            [label sizeToFit];
            
            [cell addSubview:label];
            
            return cell;
        }
        case 1: {
            UIFont *cellfont = [UIFont systemFontOfSize:14];
            NSString *rawmessage = self.post.message;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){230, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, ceil(MessageLabelSize.size.height) + 11)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1];
            
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice.png"]];
            image.frame = CGRectMake(16, 18, 52, 52);
            [cell addSubview:image];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 11, 230, 0)];
            label.textColor = [UIColor silver:1];
            label.font = [UIFont systemFontOfSize:14];
            label.text = rawmessage;
            label.numberOfLines = 0;
            [label sizeToFit];
            
            [cell addSubview:label];
            
            return cell;
        }
        case 2: {
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

#pragma NavigationBarAction
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setting:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"Delete Notice", nil)
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma IBAction
- (IBAction)showDetail:(id)sender {
    NoticeDetailListViewController *noticeDetailsView = [[NoticeDetailListViewController alloc] initWithNibName:@"NoticeDetailListViewController" bundle:nil];
    noticeDetailsView.post = post;
    [self.navigationController pushViewController:noticeDetailsView animated:YES];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
        [self deleteNotice];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSString *message = NSLocalizedString(@"Do you really wish to delete current notice?", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Notice", nil)
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"Delete", nil), nil];
        [alert show];
    }
}

#pragma private methods
- (void)deleteNotice {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Deleting Notice", nil);
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
