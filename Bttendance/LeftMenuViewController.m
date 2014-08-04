//
//  LeftMenuViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "CourseDetailViewController.h"
#import "GuidePageViewController.h"
#import "CourseCreateViewController.h"
#import "CourseAttendViewController.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "BTUserDefault.h"
#import "BTColor.h"
#import "SideHeaderViewCell.h"
#import "SideInfoCell.h"
#import "SideCourseInfoCell.h"
#import "BTNotification.h"
#import "BTAPIs.h"
#import "UserVoice.h"

@interface LeftMenuViewController ()

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *courses;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user = [BTUserDefault getUser];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.courses = [BTUserDefault getCourses];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSide:) name:SideRefresh object:nil];
}

- (void)refreshSide:(NSNotification *)noti {
    [BTAPIs coursesInSuccess:^(NSArray *courses) {
        self.courses = courses;
        self.user = [BTUserDefault getUser];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)reloadTableView:(NSNotification *)noti {
    self.user = [BTUserDefault getUser];
    [self.tableview reloadData];
}

#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [[self.user getOpenedCourses] count] + 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
        return 133;
    else if (indexPath.row == 1)
        return 62.5;
    else if (indexPath.row <= [[self.user getOpenedCourses] count] + 1)
        return 118;
    else if (indexPath.row == [[self.user getOpenedCourses] count] + 2)
        return 57.5;
    else if (indexPath.row < [[self.user getOpenedCourses] count] + 6)
        return 62.5;
    else if (indexPath.row == [[self.user getOpenedCourses] count] + 6)
        return 30;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"SideHeaderViewCell";
        SideHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *type;
        if (self.user.supervising_courses.count > 0)
            type = NSLocalizedString(@"PROFESSOR", nil);
        else
            type = NSLocalizedString(@"STUDENT", nil);
        
        if ([self.user.full_name rangeOfString:type].length == 0) {
            NSString *title = [NSString stringWithFormat:@"%@  %@", self.user.full_name, type];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
            [str addAttribute:NSForegroundColorAttributeName value:[BTColor BT_silver:1.0] range:[title rangeOfString:type]];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:[title rangeOfString:type]];
            cell.name.attributedText = str;
        } else
            cell.name.text = self.user.full_name;
        
        cell.line.frame = CGRectMake(14, 132.3, 242, 0.7);
        
        return cell;
    }
    
    else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"SideInfoCell";
        SideInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.Info.text = NSLocalizedString(@"Add Course", nil);
        cell.Icon.hidden = NO;
        return cell;
    }
    
    else if (indexPath.row <= [[self.user getOpenedCourses] count] + 1) {
        static NSString *CellIdentifier = @"SideCourseInfoCell";
        SideCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSInteger index = indexPath.row - 2;
        SimpleCourse *openedCourse = [self.user getOpenedCourses][index];
        cell.name.text = openedCourse.name;
        
        NSString *attendance_rate = @"";
        NSString *clicker_rate = @"";
        NSString *notice_unseen = @"";
        
        if (self.courses != nil && [self.courses count] != 0) {
            for (Course *course in self.courses) {
                if (course.id == openedCourse.id) {
                    attendance_rate = course.attendance_rate;
                    clicker_rate = course.clicker_rate;
                    notice_unseen = course.notice_unseen;
                }
            }
        }
        
        cell.message1.text = [NSString stringWithFormat:NSLocalizedString(@"수업 참여율 %@%%  출석률 %@%%", nil), clicker_rate ,attendance_rate];
        
        if ([self.user supervising:openedCourse.id])
            cell.message2.text = [NSString stringWithFormat:NSLocalizedString(@"최근 공지를 읽지 않은 학생 수 %@", nil), notice_unseen];
        else
            cell.message2.text = [NSString stringWithFormat:NSLocalizedString(@"읽지 않은 공지 수 %@", nil), notice_unseen];
        
        return cell;
    }
    
    else if (indexPath.row == [[self.user getOpenedCourses] count] + 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 57.5)];
        cell.backgroundColor = [BTColor BT_white:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *bttendance = [[UILabel alloc] initWithFrame:CGRectMake(14, 33.5, 280, 14)];
        bttendance.text = NSLocalizedString(@"BTTENDANCE", nil);
        bttendance.font = [UIFont boldSystemFontOfSize:12.0];
        bttendance.textColor = [BTColor BT_navy:1.0];
        [cell addSubview:bttendance];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(14, 56.5, 242, 0.7)];
        view.backgroundColor = [BTColor BT_navy:1.0];
        [cell addSubview:view];
        
        return cell;
    }
    
    else if (indexPath.row < [[self.user getOpenedCourses] count] + 6) {
        static NSString *CellIdentifier = @"SideInfoCell";
        SideInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.Icon.hidden = YES;
        NSInteger index = indexPath.row - [[self.user getOpenedCourses] count] - 3;
        switch (index) {
            case 0:
                cell.Info.text = NSLocalizedString(@"Guide", nil);
                break;
            case 1:
                cell.Info.text = NSLocalizedString(@"Setting", nil);
                break;
            default:
                cell.Info.text = NSLocalizedString(@"Feedback", nil);
                break;
        }
        return cell;
    }
    
    else if (indexPath.row == [[self.user getOpenedCourses] count] + 6) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_white:1.0];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_white:1.0];
        return cell;
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ProfileViewController *profileView = [[ProfileViewController alloc] initWithCoder:nil];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:profileView]];
        [self.sideMenuViewController hideMenuViewController];
    }
    
    else if (indexPath.row == 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Create Course", nil), NSLocalizedString(@"Attend Course", nil), nil];
        [actionSheet showInView:self.view];
    }
    
    else if (indexPath.row <= [[self.user getOpenedCourses] count] + 1) {
        NSInteger index = indexPath.row - 2;
        CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
        courseDetail.simpleCourse = [self.user getOpenedCourses][index];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:courseDetail]];
        [self.sideMenuViewController hideMenuViewController];
    }
    
    else if (indexPath.row > [[self.user getOpenedCourses] count] + 2
             && indexPath.row < [[self.user getOpenedCourses] count] + 6) {
        NSInteger index = indexPath.row - [[self.user getOpenedCourses] count] - 3;
        switch (index) {
            case 0: {
                GuidePageViewController *guidePage = [[GuidePageViewController alloc] initWithNibName:@"GuidePageViewController" bundle:nil];
                [self presentViewController:guidePage animated:NO completion:nil];
                break;
            }
            case 1: {
                SettingViewController *settingView = [[SettingViewController alloc] initWithCoder:nil];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:settingView]];
                [self.sideMenuViewController hideMenuViewController];
                break;
            }
            default: {
                UVConfig *config = [UVConfig configWithSite:@"bttendance.uservoice.com"];
                config.forumId = 259759;
                [config identifyUserWithEmail:self.user.email
                                         name:self.user.full_name
                                         guid:self.user.email];
                [UserVoice initialize:config];
                
                [UVStyleSheet instance].tintColor = [BTColor BT_navy:1.0];
                [UVStyleSheet instance].navigationBarBackgroundColor = [BTColor BT_black:1.0];
                [UVStyleSheet instance].navigationBarTextColor = [BTColor BT_white:1.0];
                [UVStyleSheet instance].navigationBarTintColor = [BTColor BT_white:1.0];
                [UVStyleSheet instance].navigationBarActivityIndicatorColor = [BTColor BT_white:1.0];
                [UVStyleSheet instance].loadingViewBackgroundColor = [BTColor BT_grey:1.0];
                
                [UserVoice presentUserVoiceNewIdeaFormForParentViewController:self];
                break;
            }
        }
    }
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: { //create course
            CourseCreateViewController *courseCreateView = [[CourseCreateViewController alloc] initWithNibName:@"CourseCreateViewController" bundle:nil];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:courseCreateView] animated:YES completion:nil];
            break;
        }
        case 1: { //attend course
            CourseAttendViewController *courseAttendView = [[CourseAttendViewController alloc] initWithNibName:@"CourseAttendViewController" bundle:nil];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:courseAttendView] animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
