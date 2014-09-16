//
//  SettingViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SettingViewController.h"
#import "UIColor+Bttendance.h"
#import "User.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import <AFNetworking/AFNetworking.h>
#import "BTNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "PasswordCell.h"
#import "NotificationCell.h"
#import "WebViewController.h"

@interface SettingViewController ()

@property(strong, nonatomic) User *user;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [BTUserDefault getUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Setting", nil);
    [titlelabel sizeToFit];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.user = [BTUserDefault getUser];
    [BTAPIs autoSignInInSuccess:^(User *user) {
    } failure:^(NSError *error) {
    }];
}

- (void)reloadTableView:(NSNotification *)noti {
    self.user = [BTUserDefault getUser];
    [self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3)
        return 86;
    
    if (indexPath.row == 8)
        return 33;
    
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 3) {
        static NSString *CellIdentifier = @"NotificationCell";
        NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
                cell.title.text = NSLocalizedString(@"출석체크 알림", nil);
                cell.noti_switch.on = self.user.setting.attendance;
                [cell.noti_switch addTarget:self
                                     action:@selector(attendance:)
                           forControlEvents:UIControlEventValueChanged];
                break;
            case 1:
                cell.title.text = NSLocalizedString(@"설문조사 알림", nil);
                cell.noti_switch.on = self.user.setting.clicker;
                [cell.noti_switch addTarget:self
                                     action:@selector(clicker:)
                           forControlEvents:UIControlEventValueChanged];
                break;
            case 2:
            default:
                cell.title.text = NSLocalizedString(@"공지 알림", nil);
                cell.noti_switch.on = self.user.setting.notice;
                [cell.noti_switch addTarget:self
                                     action:@selector(notice:)
                           forControlEvents:UIControlEventValueChanged];
                break;
        }
        
        return  cell;
    }
    
    else if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 86)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 13, 280, 70)];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        NSString *string = NSLocalizedString(@"알람 설정을 끄면 강의자가 진행하는 액션에 대한 알림을\n받지 못합니다.", nil);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        [str addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string rangeOfString:string]];
        title.attributedText = str;
        title.numberOfLines = 0;
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [UIColor silver:1.0];
        [title sizeToFit];
        [cell addSubview:title];
        return cell;
    }
    
    else if (indexPath.row > 3 && indexPath.row < 8) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.row) {
            case 4:
                cell.password.text = NSLocalizedString(@"이용약관", nil);
                break;
            case 5:
                cell.password.text = NSLocalizedString(@"개인정보 처리방침", nil);
                break;
            case 6:
                cell.password.text = NSLocalizedString(@"비텐던스 공식 블로그", nil);
                break;
            case 7:
            default:
                cell.password.text = NSLocalizedString(@"비텐던스 페이스북 페이지", nil);
                break;
        }
        return cell;
    }
    
    else if (indexPath.row == 8) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        return cell;
    }
}

//#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 4:
            [self term];
            break;
        case 5:
            [self policy];
            break;
        case 6:
            [self blog];
            break;
        case 7:
            [self facebook];
            break;
        default:
            break;
    }
}

#pragma Actions
- (void)attendance:(id)sender {
    [BTAPIs updateNotiSettingAttendance:((UISwitch*)sender).on success:^(User *user) {
    } failure:^(NSError *error) {
    }];
}

- (void)clicker:(id)sender {
    [BTAPIs updateNotiSettingClicker:((UISwitch*)sender).on success:^(User *user) {
    } failure:^(NSError *error) {
    }];
}

- (void)notice:(id)sender {
    [BTAPIs updateNotiSettingNotice:((UISwitch*)sender).on success:^(User *user) {
    } failure:^(NSError *error) {
    }];
}

- (void)term {
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([locale isEqualToString:@"ko"]) {
        WebViewController *webView = [[WebViewController alloc] initWithURLString:@"http://www.bttendance.com/terms"];
        [self.navigationController pushViewController:webView animated:YES];
    } else {
        WebViewController *webView = [[WebViewController alloc] initWithURLString:@"http://www.bttendance.com/terms-en"];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (void)policy {
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([locale isEqualToString:@"ko"]) {
        WebViewController *webView = [[WebViewController alloc] initWithURLString:@"http://www.bttendance.com/privacy"];
        [self.navigationController pushViewController:webView animated:YES];
    } else {
        WebViewController *webView = [[WebViewController alloc] initWithURLString:@"http://www.bttendance.com/privacy-en"];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (void)blog {
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([locale isEqualToString:@"ko"]) {
        WebViewController *webView = [[WebViewController alloc] initWithURLString:@"http://bttendance.tistory.com"];
        [self.navigationController pushViewController:webView animated:YES];
    } else {
        WebViewController *webView = [[WebViewController alloc] initWithURLString:@"http://www.bttendance.com/blog"];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

- (void)facebook {
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([locale isEqualToString:@"ko"]) {
        NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/226844200832003"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            WebViewController *webView = [[WebViewController alloc] initWithURLString:@"http://www.facebook.com/226844200832003"];
            [self.navigationController pushViewController:webView animated:YES];
        }
    } else {
        NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/633914856683639"];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            WebViewController *webView = [[WebViewController alloc] initWithURLString:@"http://www.facebook.com/633914856683639"];
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}

@end
