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
#import "UIColor+Bttendance.h"
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
            [self.tableView reloadData];
        });
    });
    
    self.tableView.scrollsToTop = NO;
    super.tableView.backgroundColor = [UIColor white:1.0];
    super.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSide:) name:SideRefresh object:nil];
}

- (void)refreshSide:(NSNotification *)noti {
    [BTAPIs coursesInSuccess:^(NSArray *courses) {
        self.courses = courses;
        self.user = [BTUserDefault getUser];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)reloadTableView:(NSNotification *)noti {
    self.user = [BTUserDefault getUser];
    [self.tableView reloadData];
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
        return 155;
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
        
        cell.type.text = type;
        cell.name.text = self.user.full_name;
        cell.line.frame = CGRectMake(14, 154.3, 242, 0.7);
        
        cell.lectures.text = NSLocalizedString(@"LECTURES", nil);
        
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
        NSInteger notice_unseen = 0;
        NSInteger students_count = 0;
        
        if (self.courses != nil && [self.courses count] != 0) {
            for (Course *course in self.courses) {
                if (course.id == openedCourse.id) {
                    attendance_rate = [NSString stringWithFormat:@"%ld", (long)course.attendance_rate];
                    clicker_rate = [NSString stringWithFormat:@"%ld", (long)course.clicker_rate];
                    notice_unseen = course.notice_unseen;
                    students_count = course.students_count;
                }
            }
        }
        
        NSString *message1 = [NSString stringWithFormat:NSLocalizedString(@"수업 참여율 %1$@%%  출석률 %2$@%%", nil), clicker_rate ,attendance_rate];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:message1];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor silver:1.0] range:[message1 rangeOfString:[NSString stringWithFormat:@"%@%%", clicker_rate]]];
        [str1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message1 rangeOfString:[NSString stringWithFormat:@"%@%%", clicker_rate]]];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor silver:1.0] range:[message1 rangeOfString:[NSString stringWithFormat:@"%@%%", attendance_rate] options:NSBackwardsSearch]];
        [str1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message1 rangeOfString:[NSString stringWithFormat:@"%@%%", attendance_rate] options:NSBackwardsSearch]];
        cell.message1.attributedText = str1;
        
        if ([self.user supervising:openedCourse.id]) {
            NSString *message2 = [NSString stringWithFormat:NSLocalizedString(@"최근 공지를 읽은 학생 수 %ld/%ld", nil), (long)(students_count - notice_unseen), (long)students_count];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:message2];
            [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor silver:1.0] range:[message2 rangeOfString:[NSString stringWithFormat:@"%ld/%ld", (long)(students_count - notice_unseen), (long)students_count]]];
            [str2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message2 rangeOfString:[NSString stringWithFormat:@"%ld/%ld", (long)(students_count - notice_unseen), (long)students_count]]];
            cell.message2.attributedText = str2;
        } else {
            NSString *message2 = [NSString stringWithFormat:NSLocalizedString(@"읽지 않은 공지 수 %ld", nil), (long)notice_unseen];
            NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:message2];
            [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor silver:1.0] range:[message2 rangeOfString:[NSString stringWithFormat:@"%ld", (long)notice_unseen]]];
            [str2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message2 rangeOfString:[NSString stringWithFormat:@"%ld", (long)notice_unseen]]];
            cell.message2.attributedText = str2;
        }
        
        return cell;
    }
    
    else if (indexPath.row == [[self.user getOpenedCourses] count] + 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 57.5)];
        cell.backgroundColor = [UIColor white:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *bttendance = [[UILabel alloc] initWithFrame:CGRectMake(14, 33.5, 280, 14)];
        bttendance.text = NSLocalizedString(@"BTTENDANCE", nil);
        bttendance.font = [UIFont boldSystemFontOfSize:12.0];
        bttendance.textColor = [UIColor navy:1.0];
        [cell addSubview:bttendance];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(14, 56.3, 242, 0.7)];
        view.backgroundColor = [UIColor navy:1.0];
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
        cell.backgroundColor = [UIColor white:1.0];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor white:1.0];
        return cell;
    }
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ProfileViewController *profileView = [[ProfileViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:profileView]];
        [self.sideMenuViewController hideMenuViewController];
    }
    
    else if (indexPath.row == 1) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
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
                SettingViewController *settingView = [[SettingViewController alloc] initWithStyle:UITableViewStylePlain];
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
                
                [UVStyleSheet instance].tintColor = [UIColor navy:1.0];
                [UVStyleSheet instance].navigationBarBackgroundColor = [UIColor black:1.0];
                [UVStyleSheet instance].navigationBarTextColor = [UIColor white:1.0];
                [UVStyleSheet instance].navigationBarTintColor = [UIColor white:1.0];
                [UVStyleSheet instance].navigationBarActivityIndicatorColor = [UIColor white:1.0];
                [UVStyleSheet instance].loadingViewBackgroundColor = [UIColor grey:1.0];
                
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
            CourseCreateViewController *courseCreateView = [[CourseCreateViewController alloc] initWithStyle:UITableViewStylePlain];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:courseCreateView] animated:YES completion:nil];
            break;
        }
        case 1: { //attend course
            CourseAttendViewController *courseAttendView = [[CourseAttendViewController alloc] initWithStyle:UITableViewStylePlain];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:courseAttendView] animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
