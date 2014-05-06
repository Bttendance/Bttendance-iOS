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
#import "BTNotification.h"
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFeed:) name:FeedRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader:) name:CourseUpdated object:nil];
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
    coursedetailheaderview = [[CourseDetailHeaderView alloc] init];
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseDetailHeaderView" owner:self options:nil];
    coursedetailheaderview = [topLevelObjects objectAtIndex:0];
    
    [self refreshHeader:nil];

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

- (void)refreshHeader:(id)sender {
    NSNotification *notification = sender;
    if ([notification object] != nil)
        course = [notification object];

    coursedetailheaderview.profname.text = [self profName];
    coursedetailheaderview.schoolname.text = [self schoolName];
    coursedetailheaderview.background.layer.cornerRadius = 52.5f;
    coursedetailheaderview.background.layer.masksToBounds = YES;
    coursedetailheaderview.studentNumber.text = [NSString stringWithFormat:@"%d students", (int)[self studentCount]];
    coursedetailheaderview.attendanceGrade.text = [NSString stringWithFormat:@"%@%% attendance rate", [self grade]];
    coursedetailheaderview.clickerUsage.text = [NSString stringWithFormat:@"%d clickers", (int)[self clickerUsage]];
    coursedetailheaderview.noticeUsage.text = [NSString stringWithFormat:@"%d notices", (int)[self noticeUsage]];
    
    [coursedetailheaderview.clickerBt addTarget:self action:@selector(start_clicker) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.attendanceBt addTarget:self action:@selector(start_attendance) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.noticeBt addTarget:self action:@selector(create_notice) forControlEvents:UIControlEventTouchUpInside];
    
    double gap = [course.attdCheckedAt timeIntervalSinceNow];
    if (180.0f + gap > 0.0f && course != nil)
        [coursedetailheaderview.attendanceBt removeTarget:self action:@selector(start_attendance) forControlEvents:UIControlEventTouchUpInside];
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
    return [NSString stringWithFormat:@"%d", (int)courseId];
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