//
//  StdCourseDetailView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CourseDetailHeaderView.h"
#import "PostCell.h"
#import "BTColor.h"
#import <AFNetworking/AFNetworking.h>
#import "BTAPIs.h"
#import "GradeViewController.h"
#import "CreateNoticeViewController.h"
#import "ManagerViewController.h"
#import "AttdStatViewController.h"
#import "BTDateFormatter.h"
#import "BTUserDefault.h"
#import "Post.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "User.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController
@synthesize course, simpleCourse, auth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFeed:) name:@"NEWMESSAGE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
        
        UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [settingButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setBackgroundImage:[UIImage imageNamed:@"setting@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *plusButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
        [self.navigationItem setRightBarButtonItem:plusButtonItem];
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setting:(id)sender {
    if (auth) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Show Grades", @"Export Grades", @"Add Manager", nil];
        [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Unjoin Course", nil];
        [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
    }
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.tableview reloadData];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *title = [self courseName];

    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(title, @"");
    [titlelabel sizeToFit];

    self.view.backgroundColor = [BTColor BT_grey:1];
    [self tableview].backgroundColor = [BTColor BT_grey:1];

    //set header view
    CourseDetailHeaderView *coursedetailheaderview = [[CourseDetailHeaderView alloc] init];

    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseDetailHeaderView" owner:self options:nil];
    coursedetailheaderview = [topLevelObjects objectAtIndex:0];

    coursedetailheaderview.profname.text = [self profName];
    coursedetailheaderview.schoolname.text = [self schoolName];
    coursedetailheaderview.background.layer.cornerRadius = 52.5f;
    coursedetailheaderview.background.layer.masksToBounds = YES;
    coursedetailheaderview.studentNumber.text = [NSString stringWithFormat:@"%ld students", [self studentCount]];
    coursedetailheaderview.attendanceGrade.text = [NSString stringWithFormat:@"%@%% attendance rate", [self grade]];
    coursedetailheaderview.clickerUsage.text = [NSString stringWithFormat:@"%ld clickers", [self clickerUsage]];
    coursedetailheaderview.noticeUsage.text = [NSString stringWithFormat:@"%ld notices", [self noticeUsage]];
    
    [coursedetailheaderview.clickerBt addTarget:self action:@selector(start_clicker) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.attendanceBt addTarget:self action:@selector(start_attendance) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.noticeBt addTarget:self action:@selector(create_notice) forControlEvents:UIControlEventTouchUpInside];

    if (auth) {
        [coursedetailheaderview.BTicon addTarget:self action:@selector(BTiconAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [coursedetailheaderview setFrame:CGRectMake(0, 0, 320, 175)];
        [coursedetailheaderview.bg setFrame:CGRectMake(10, 10, 300, 161)];
        coursedetailheaderview.clickerBt.hidden = YES;
        coursedetailheaderview.attendanceBt.hidden = YES;
        coursedetailheaderview.noticeBt.hidden = YES;
        coursedetailheaderview.clickerView.hidden = YES;
        coursedetailheaderview.attendanceView.hidden = YES;
        coursedetailheaderview.noticeView.hidden = YES;
    }

    [self showgrade:[[self grade] integerValue]:coursedetailheaderview];
    self.tableview.tableHeaderView = coursedetailheaderview;
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshFeed:nil];
}

- (void)refreshFeed:(id)sender {
//    [BTAPIs feedForCourse:[self courseId]
//                     page:1
//                  success:^(NSArray *posts) {
//                      data = posts;
//                      rowcount = data.count;
//                      [_tableview reloadData];
//                  } failure:^(NSError *error) {
//                  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowcount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 102.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];

    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.post = [data objectAtIndex:indexPath.row];
    cell.Title.text = [self courseName];
    cell.Message.text = cell.post.message;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([[[data objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"notice"]) {
        [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
        [cell.check_overlay setImage:nil];
    } else {

        Boolean check = false;
        NSArray *checks = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
        for (int i = 0; i < checks.count; i++) {
            NSString *check_id = [NSString stringWithFormat:@"%@", [[[data objectAtIndex:indexPath.row] objectForKey:@"checks"] objectAtIndex:i]];
            if ([my_id isEqualToString:check_id])
                check = true;
        }

        Boolean manager = false;
        NSArray *supervisingCourses = [BTUserDefault getUser].supervising_courses;
        for (int i = 0; i < [supervisingCourses count]; i++) {
            if ([[[data objectAtIndex:indexPath.row] objectForKey:@"course"] intValue] == [[supervisingCourses objectAtIndex:i] intValue])
                manager = true;
        }

        if (manager) {
            if (180.0f + cell.gap > 0.0f)
                [self startAnimation:cell];
            else {
                int grade = [[[data objectAtIndex:indexPath.row] objectForKey:@"grade"] intValue];
                [cell.background setFrame:CGRectMake(29, 75 - grade / 2, 50, grade / 2)];
            }
        } else {
            if (!check) {
                if (180.0f + cell.gap > 0.0f) {
                    [self startAnimation:cell];
                } else if (!check) {
                    [cell.check_icon setImage:[UIImage imageNamed:@"attendfail@2x.png"]];
                    [cell.check_overlay setImage:nil];
                }
            }
        }
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (data.count != 0) {
        PostCell *cell = (PostCell *) [self.tableview cellForRowAtIndexPath:indexPath];

        Boolean manager = false;
        NSArray *supervisingCourses = [BTUserDefault getUser].supervising_courses;
        for (int i = 0; i < [supervisingCourses count]; i++) {
            if (cell.post.course.id == [[supervisingCourses objectAtIndex:i] intValue])
                manager = true;
        }

        if (!manager || [cell.post.type isEqualToString:@"notice"])
            return;

        AttdStatViewController *statView = [[AttdStatViewController alloc] initWithNibName:@"AttdStatViewController" bundle:nil];
        statView.post = cell.post;
        [self.navigationController pushViewController:statView animated:YES];
    }
}

- (void)startAnimation:(PostCell *)cell {

    float height = (180.0f + cell.gap) / 180.0f * 50.0f;
    cell.background.frame = CGRectMake(29, 75 - height, 50, height);
    [UIView animateWithDuration:180.0f + cell.gap
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.background.frame = CGRectMake(29, 75, 50, 0);
                     }
                     completion:^(BOOL finished) {
                         if (finished)
                             [self refreshFeed:nil];
                     }];


    cell.blinkTime = 180 + cell.gap;
    if (cell.blink != nil)
        [cell.blink invalidate];
    NSTimer *blink = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(blink:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell, @"cell", nil] repeats:YES];
    cell.blink = blink;
}

- (void)blink:(NSTimer *)timer {
    PostCell *cell = [[timer userInfo] objectForKey:@"cell"];

    cell.blinkTime--;
    if (cell.blinkTime < 0) {

        Boolean manager = false;
        NSArray *supervisingCourses = [BTUserDefault getUser].supervising_courses;
        for (int i = 0; i < [supervisingCourses count]; i++) {
            if (cell.post.course.id == [[supervisingCourses objectAtIndex:i] intValue])
                manager = true;
        }

        if (manager) {
            cell.check_icon.alpha = 1;
            if (cell.blink != nil)
                [cell.blink invalidate];
            cell.blink = nil;
        } else {
            [cell.check_icon setImage:[UIImage imageNamed:@"attendfail@2x.png"]];
            [cell.check_overlay setImage:nil];
        }
        return;
    }

    if (cell.check_icon.alpha < 0.5) {
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:1.0];
        cell.check_icon.alpha = 1;
        [UIImageView commitAnimations];
    } else {
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:1.0];
        cell.check_icon.alpha = 0;
        [UIImageView commitAnimations];
    }
}

- (void)showgrade:(CGFloat)grade :(CourseDetailHeaderView *)view {
    CGRect frame = view.grade.frame;
    frame.size.height = 94.0f * (100.0f - grade) / 100.0f;
    [view.grade setFrame:frame];
}

- (void)BTiconAction:(id)sender {
    NSLog(@"BTicon pressed");
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 200)
        [self dettend_course];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            if (auth)
                [self show_grades];
            else {
                NSString *message = [NSString stringWithFormat:@"Do you really wish to unjoin from course %@?", [self courseName]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UnJoin Course"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"UnJoin"
                                                      otherButtonTitles:@"Cancel", nil];
                alert.tag = 200;
                [alert show];
            }
            break;
        case 1:
            if (auth)
                [self export_grades];
            break;
        case 2:
            if (auth)
                [self add_manager];
            break;
        default:
            break;
    }
}

#pragma Actions
- (void)start_clicker {
    
}

- (void)start_attendance {
    
}

- (void)create_notice {
    CreateNoticeViewController *noticeView = [[CreateNoticeViewController alloc] initWithNibName:@"CreateNoticeViewController" bundle:nil];
    noticeView.cid = [self courseId];
    [self.navigationController pushViewController:noticeView animated:YES];
}

- (void)add_manager {
    ManagerViewController *managerView = [[ManagerViewController alloc] initWithNibName:@"ManagerViewController" bundle:nil];
    managerView.courseId = [self courseId];
    managerView.courseName = [self courseName];
    [self.navigationController pushViewController:managerView animated:YES];
}

- (void)show_grades {
    GradeViewController *gradeView = [[GradeViewController alloc] initWithNibName:@"GradeViewController" bundle:nil];
    gradeView.cid = [self courseId];
    [self.navigationController pushViewController:gradeView animated:YES];
}

- (void)export_grades {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = @"Loading";
    hud.detailsLabelText = @"Exporting Grades";
    hud.yOffset = -40.0f;
    
    [BTAPIs exportGradesWithCourse:[self courseId]
                           success:^(Email *email) {
                               [hud hide:YES];
                               NSString *message = [NSString stringWithFormat:@"Exporting Grades has been finished.\nPlease check your email.\n%@", email.email];
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exporting Grades"
                                                                               message:message
                                                                              delegate:self
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil];
                               [alert show];
                           } failure:^(NSError *error) {
                               [hud hide:YES];
                           }];
}

- (void)dettend_course {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = @"Loading";
    hud.detailsLabelText = @"Unjoining Course";
    hud.yOffset = -40.0f;
    [BTAPIs dettendCourse:[self courseId]
                  success:^(User *user) {
                      [hud hide:YES];
                      [self.navigationController popViewControllerAnimated:YES];
                  } failure:^(NSError *error) {
                      [hud hide:YES];
                  }];
}

#pragma Helpers
-(NSString *)courseId {
    NSInteger courseId = course.id;
    if (courseId == 0)
        courseId = simpleCourse.id;
    return [NSString stringWithFormat:@"%ld", courseId];
}

-(NSString *)courseName {
    NSString *courseName = course.name;
    if (courseName == nil)
        courseName = simpleCourse.name;
    return courseName;
}

-(NSString *)profName {
    NSString *profName = course.professor_name;
    if (profName == nil)
        profName = simpleCourse.professor_name;
    return profName;
}

-(NSString *)schoolName {
    NSString *schoolName = course.school.name;
    if (schoolName == nil) {
        User *user = [BTUserDefault getUser];
        for (int i = 0; i < [user.enrolled_schools count]; i++)
            if (((SimpleSchool *)user.enrolled_schools[i]).id == simpleCourse.school)
                schoolName = ((SimpleSchool *)user.enrolled_schools[i]).name;
        for (int i = 0; i < [user.employed_schools count]; i++)
            if (((SimpleSchool *)user.employed_schools[i]).id == simpleCourse.school)
                schoolName = ((SimpleSchool *)user.employed_schools[i]).name;
    }
    return schoolName;
}

-(NSString *)grade {
    NSString *grade = course.grade;
    if (grade == nil)
        grade = @"0";
    return grade;
}

-(NSInteger)studentCount {
    NSInteger studentCount = course.students_count;
    if (studentCount == 0)
        studentCount = simpleCourse.students_count;
    return studentCount;
}

-(NSInteger)clickerUsage {
    NSInteger clickerUsage = course.clicker_usage;
    if (clickerUsage == 0)
        clickerUsage = simpleCourse.clicker_usage;
    return clickerUsage;
}

-(NSInteger)noticeUsage {
    NSInteger noticeUsage = course.notice_usage;
    if (noticeUsage == 0)
        noticeUsage = simpleCourse.notice_usage;
    return noticeUsage;
}

@end