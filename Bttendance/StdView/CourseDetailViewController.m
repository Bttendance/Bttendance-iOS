//
//  StdCourseDetailView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CourseDetailHeaderView.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "BTColor.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "BTNotification.h"

#import "Post.h"
#import "User.h"
#import "BTDateFormatter.h"
#import "PostCell.h"
#import "ClickerCell.h"

#import "GuidePostCell.h"
#import "WebViewController.h"
#import "GuideCourseCreateViewController.h"
#import "GuideCourseAttendViewController.h"

#import "CreateClickerViewController.h"
#import "CreateAttdViewController.h"
#import "CreateNoticeViewController.h"

#import "AttendanceAgent.h"
#import "BTBlink.h"

#import "ClickerDetailViewController.h"
#import "AttdDetailViewController.h"
#import "AttdDetailListViewController.h"
#import "NoticeDetailViewController.h"

#import "CourseSettingViewController.h"

@interface CourseDetailViewController ()

@property (assign) BOOL auth;
@property (strong, nonatomic) Course *course;
@property (strong, nonatomic) Post *openingPost;

@end

@implementation CourseDetailViewController
@synthesize simpleCourse;

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setting:(id)sender {
    if (self.auth && simpleCourse.opened) {
        CourseSettingViewController *courseSetting = [[CourseSettingViewController alloc] initWithNibName:@"CourseSettingViewController" bundle:nil];
        courseSetting.simpleCourse = simpleCourse;
        [self.navigationController pushViewController:courseSetting animated:YES];
    } else if (self.auth && !simpleCourse.opened) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Open Course", nil), nil];
        [actionSheet showInView:self.view];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Unjoin Course", nil), nil];
        [actionSheet showInView:self.view];
    }
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.tableview reloadData];
    [self refreshFeed:nil];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *title = simpleCourse.name;
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = title;
    [titlelabel sizeToFit];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuButtonItem];

    self.view.backgroundColor = [BTColor BT_grey:1];
    [self tableview].backgroundColor = [BTColor BT_grey:1];

    user = [BTUserDefault getUser];
    data = [NSMutableArray array];
    self.auth = [user supervising:simpleCourse.id];
    if (self.simpleCourse.opened)
        [BTUserDefault setLastSeenCourse:simpleCourse.id];
    self.course = [BTUserDefault getCourse:simpleCourse.id];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [NSMutableArray arrayWithArray:[BTUserDefault getPostsOfArray:[NSString stringWithFormat:@"%ld", (long)simpleCourse.id]]];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    });
    
    if (!simpleCourse.opened) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    
    if (simpleCourse.opened || self.auth) {
        UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [settingButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setBackgroundImage:[UIImage imageNamed:@"setting@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *plusButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
        [self.navigationItem setRightBarButtonItem:plusButtonItem];
    }
    
    // Course Header View
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseDetailHeaderView" owner:self options:nil];
    coursedetailheaderview = [topLevelObjects objectAtIndex:0];
    
    [coursedetailheaderview.clickerBt setBackgroundImage:[BTColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [coursedetailheaderview.clickerBt setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateHighlighted];
    [coursedetailheaderview.clickerBt setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateSelected];
    [coursedetailheaderview.attendanceBt setBackgroundImage:[BTColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [coursedetailheaderview.attendanceBt setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateHighlighted];
    [coursedetailheaderview.attendanceBt setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateSelected];
    [coursedetailheaderview.noticeBt setBackgroundImage:[BTColor imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [coursedetailheaderview.noticeBt setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateHighlighted];
    [coursedetailheaderview.noticeBt setBackgroundImage:[BTColor imageWithCyanColor:0.5] forState:UIControlStateSelected];
    [coursedetailheaderview.clickerBt addTarget:self action:@selector(start_clicker) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.attendanceBt addTarget:self action:@selector(start_attendance) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.noticeBt addTarget:self action:@selector(create_notice) forControlEvents:UIControlEventTouchUpInside];
    
    coursedetailheaderview.clickerLabel.text = NSLocalizedString(@"Clicker", nil);
    coursedetailheaderview.attendanceLabel.text = NSLocalizedString(@"Attendance Check", nil);
    coursedetailheaderview.noticeLabel.text = NSLocalizedString(@"Notice", nil);
    coursedetailheaderview.classcode.text = NSLocalizedString(@"클래스 코드", nil);
    
    [self refreshHeader];
    
    self.tableview.tableHeaderView = coursedetailheaderview;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 4)];
    self.tableview.tableFooterView = footer;
    
    // NotificationCenter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPost:) name:OpenNewPost object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFeed:) name:FeedRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCourse:) name:CoursesUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClicker:) name:ClickerUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttendance:) name:AttendanceUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotice:) name:NoticeUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePost:) name:PostUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)refreshHeader {
    
    if (!self.auth || !self.simpleCourse.opened) {
        coursedetailheaderview.clickerBg.hidden = YES;
        coursedetailheaderview.attendanceBg.hidden = YES;
        coursedetailheaderview.noticeBg.hidden = YES;
        coursedetailheaderview.clickerBt.hidden = YES;
        coursedetailheaderview.attendanceBt.hidden = YES;
        coursedetailheaderview.noticeBt.hidden = YES;
        coursedetailheaderview.clickerView.hidden = YES;
        coursedetailheaderview.attendanceView.hidden = YES;
        coursedetailheaderview.noticeView.hidden = YES;
        coursedetailheaderview.clickerLabel.hidden = YES;
        coursedetailheaderview.attendanceLabel.hidden = YES;
        coursedetailheaderview.noticeLabel.hidden = YES;
    }
    
    NSString *courseName = self.simpleCourse.name;
    
    NSString *profName = self.simpleCourse.professor_name;
    NSString *schoolName = [user getSchoolNameFromId:self.simpleCourse.school];
    NSString *studentCount = [NSString stringWithFormat:NSLocalizedString(@"%d Student(s)", nil), self.course.students_count];
    
    NSAttributedString *courseMessage = [[NSAttributedString alloc] initWithString:courseName attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    CGRect courseMessageLabelSize = [courseMessage boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    CGFloat courseHeight = ceil(courseMessageLabelSize.size.height);
    
    NSString *detail = [NSString stringWithFormat:@"%@ | %@ | %@", profName, schoolName, studentCount];
    NSAttributedString *detailMessage = [[NSAttributedString alloc] initWithString:detail attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGRect detailMessageLabelSize = [detailMessage boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    CGFloat detailHeight = ceil(detailMessageLabelSize.size.height);
    
    if (detailHeight > 18) {
        detail = [NSString stringWithFormat:@"%@\n%@ | %@", profName, schoolName, studentCount];
        
        NSString *detail2 = [NSString stringWithFormat:@"%@ | %@", schoolName, studentCount];
        NSAttributedString *detailMessage2 = [[NSAttributedString alloc] initWithString:detail2 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        CGRect detailMessageLabelSize2 = [detailMessage2 boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        CGFloat detailHeight2 = ceil(detailMessageLabelSize2.size.height);
        
        if (detailHeight2 > 18) {
            detail = [NSString stringWithFormat:@"%@\n%@\n%@", profName, schoolName, studentCount];
        }
    }
    
    detailMessage = [[NSAttributedString alloc] initWithString:detail attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    detailMessageLabelSize = [detailMessage boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    detailHeight = ceil(detailMessageLabelSize.size.height);
    
    coursedetailheaderview.frame = CGRectMake(0, 0, 320, 204 + courseHeight + detailHeight);
    coursedetailheaderview.bg.frame = CGRectMake(10, 10, 300, 119 + courseHeight + detailHeight);
    
    if (!self.auth || !self.simpleCourse.opened) {
        [coursedetailheaderview setFrame:CGRectMake(0, 0, 320, 134 + courseHeight + detailHeight)];
        [coursedetailheaderview.bg setFrame:CGRectMake(10, 10, 300, 119 + courseHeight + detailHeight)];
    }
    
    coursedetailheaderview.coursename.text = courseName;
    coursedetailheaderview.coursename.numberOfLines = 0;
    [coursedetailheaderview.coursename sizeToFit];
    coursedetailheaderview.coursename.textAlignment = NSTextAlignmentCenter;
    coursedetailheaderview.coursename.frame = CGRectMake(20, 102, 280, courseHeight);
    
    coursedetailheaderview.detail.text = detail;
    coursedetailheaderview.detail.numberOfLines = 0;
    [coursedetailheaderview.detail sizeToFit];
    coursedetailheaderview.detail.textAlignment = NSTextAlignmentCenter;
    coursedetailheaderview.detail.frame = CGRectMake(20, 103 + courseHeight, 280, detailHeight);
    
    coursedetailheaderview.clickerBg.frame = CGRectMake(10, 131 + courseHeight + detailHeight, 99, 68);
    coursedetailheaderview.attendanceBg.frame = CGRectMake(111, 131 + courseHeight + detailHeight, 99, 68);
    coursedetailheaderview.noticeBg.frame = CGRectMake(211, 131 + courseHeight + detailHeight, 99, 68);
    
    coursedetailheaderview.clickerBt.frame = CGRectMake(10, 131 + courseHeight + detailHeight, 99, 68);
    coursedetailheaderview.attendanceBt.frame = CGRectMake(111, 131 + courseHeight + detailHeight, 99, 68);
    coursedetailheaderview.noticeBt.frame = CGRectMake(211, 131 + courseHeight + detailHeight, 99, 68);
    
    coursedetailheaderview.clickerView.frame = CGRectMake(47, 143 + courseHeight + detailHeight, 25, 25);
    coursedetailheaderview.attendanceView.frame = CGRectMake(148, 143 + courseHeight + detailHeight, 25, 25);
    coursedetailheaderview.noticeView.frame = CGRectMake(248, 143 + courseHeight + detailHeight, 25, 25);
    
    coursedetailheaderview.clickerLabel.frame = CGRectMake(15, 173 + courseHeight + detailHeight, 88, 21);
    coursedetailheaderview.attendanceLabel.frame = CGRectMake(116, 173 + courseHeight + detailHeight, 88, 21);
    coursedetailheaderview.noticeLabel.frame = CGRectMake(216, 173 + courseHeight + detailHeight, 88, 21);
    
    coursedetailheaderview.classBg.frame = CGRectMake(132, 31, 56, 57);
    coursedetailheaderview.classHeader.frame = CGRectMake(132, 31, 56, 30);
    coursedetailheaderview.classFooter.frame = CGRectMake(132, 49, 56, 30);
    
    coursedetailheaderview.classcode.frame = CGRectMake(132, 35, 56, 10);
    coursedetailheaderview.code.frame = CGRectMake(132, 57, 56, 20);
    
    if (self.course != nil)
        coursedetailheaderview.code.text = [self.course.code uppercaseString];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (self.openingPost != nil) {
        if ([self.openingPost.type isEqualToString:@"attendance"]) {
            if ([self.openingPost.attendance.type isEqualToString:@"auto"]) {
                AttdDetailViewController *attendanceView = [[AttdDetailViewController alloc] initWithNibName:@"AttdDetailViewController" bundle:nil];
                attendanceView.post = self.openingPost;
                [self.navigationController pushViewController:attendanceView animated:NO];
            } else {
                AttdDetailListViewController *attendanceView = [[AttdDetailListViewController alloc] initWithNibName:@"AttdDetailListViewController" bundle:nil];
                attendanceView.post = self.openingPost;
                attendanceView.start = YES;
                [self.navigationController pushViewController:attendanceView animated:NO];
            }
        }
        
        if ([self.openingPost.type isEqualToString:@"clicker"]) {
            ClickerDetailViewController *clickerView = [[ClickerDetailViewController alloc] initWithNibName:@"ClickerDetailViewController" bundle:nil];
            clickerView.post = self.openingPost;
            [self.navigationController pushViewController:clickerView animated:NO];
        }
        
        if ([self.openingPost.type isEqualToString:@"notice"]) {
            NoticeDetailViewController *noticeView = [[NoticeDetailViewController alloc] initWithNibName:@"NoticeDetailViewController" bundle:nil];
            noticeView.post = self.openingPost;
            [self.navigationController pushViewController:noticeView animated:NO];
        }
        self.openingPost = nil;
    }
    
    user = [BTUserDefault getUser];
    [self.tableview reloadData];
    [self refreshFeed:nil];
    
}

- (void)refreshFeed:(id)sender {
    [BTAPIs feedForCourse:[NSString stringWithFormat:@"%ld", (long)simpleCourse.id]
                     page:0
                  success:^(NSArray *posts) {
                     data = [NSMutableArray arrayWithArray:posts];
                     [self.tableview reloadData];
                     [self checkAttendanceScan];
                     [self refreshCheck];
                  } failure:^(NSError *error) {
                  }];
}

#pragma NSNotification
- (void)openPost:(NSNotification *)aNotification {
    NSDictionary *dict = [aNotification userInfo];
    self.openingPost = (Post*) [dict objectForKey:PostInfo];
}

- (void)updateCourse:(NSNotification *)notification {
    self.course = [BTUserDefault getCourse:simpleCourse.id];
    [self refreshHeader];
    [self.tableview reloadData];
}

- (void)updateClicker:(NSNotification *)notification {
    if ([notification object] == nil || data.count == 0)
        return;
    
    Clicker *clicker = [notification object];
    Boolean found = NO;
    for (int i = 0; i < data.count; i++) {
        Post *post = data[i];
        if ([post.type isEqualToString:@"clicker"] && clicker.id == post.clicker.id) {
            [post.clicker copyDataFromClicker:clicker];
            found = YES;
        }
    }
    if (found)
        [self.tableview reloadData];
}

- (void)updateAttendance:(NSNotification *)notification {
    if ([notification object] == nil || data.count == 0)
        return;
    
    Attendance *attendance = [notification object];
    Boolean found = NO;
    for (int i = 0; i < data.count; i++) {
        Post *post = data[i];
        if ([post.type isEqualToString:@"attendance"] && attendance.id == post.attendance.id) {
            [post.attendance copyDataFromAttendance:attendance];
            found = YES;
        }
    }
    if (found)
        [self.tableview reloadData];
}

- (void)updateNotice:(NSNotification *)notification {
    if ([notification object] == nil || data.count == 0)
        return;
    
    Notice *notice = [notification object];
    Boolean found = NO;
    for (int i = 0; i < data.count; i++) {
        Post *post = data[i];
        if ([post.type isEqualToString:@"notice"] && notice.id == post.notice.id) {
            [post.notice copyDataFromNotice:notice];
            found = YES;
        }
    }
    if (found)
        [self.tableview reloadData];
}

- (void)updatePost:(NSNotification *)notification {
    if ([notification object] == nil || data.count == 0)
        return;
    
    Post *newPost = [notification object];
    Boolean found = NO;
    for (int i = 0; i < data.count; i++) {
        Post *post = data[i];
        if (post.id == newPost.id) {
            [data replaceObjectAtIndex:i withObject:newPost];
            found = YES;
        }
    }
    if (found)
        [self.tableview reloadData];
}

// Check if any attendance is on-going
- (void)checkAttendanceScan {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Post *post in data) {
        double gap = [post.createdAt timeIntervalSinceNow];
        if (65.0f + gap > 0.0f && [post.type isEqualToString:@"attendance"] && [post.attendance.type isEqualToString:@"auto"])
            [array addObject:[NSString stringWithFormat:@"%d", (int)post.attendance.id]];
    }
    
    if (array.count > 0) {
        AttendanceAgent *agent = [AttendanceAgent sharedInstance];
        [agent startAttdScanWithAttendanceIDs:array];
    }
}

// Check when to refresh feed
- (void)refreshCheck {
    float gap = 65.0f;
    
    for (Post *post in data) {
        float interval = [post.createdAt timeIntervalSinceNow];
        
        if ([post.type isEqualToString:@"attendance"]
            && [post.attendance.type isEqualToString:@"auto"]
            && interval > -65.0f
            && gap > 65.0f + interval) {
            gap = 65.0f + interval;
            NSLog(@"gap : %f", gap);
        }
        
        if ([post.type isEqualToString:@"clicker"]
            && interval > -65.0f
            && gap > 65.0f + interval) {
            gap = 65.0f + interval;
            NSLog(@"gap : %f", gap);
        }
    }
    
    if (gap < 65.0f) {
        if (refreshTimer != nil)
            [refreshTimer invalidate];
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:gap
                                                        target:self
                                                      selector:@selector(refreshFeed:)
                                                      userInfo:nil
                                                       repeats:NO];
    }
}

#pragma UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count + 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= data.count)
        return 102;
    
    Post *post = [data objectAtIndex:indexPath.row];
    
    if (![post.type isEqualToString:@"clicker"]
        && ![post.type isEqualToString:@"attendance"]
        && ![post.type isEqualToString:@"notice"])
        return 102;
    
    if ([post.type isEqualToString:@"clicker"]) {
        
        Boolean manager = false;
        NSArray *supervisingCourses = user.supervising_courses;
        for (int i = 0; i < [supervisingCourses count]; i++) {
            if (post.course.id == ((SimpleCourse *)[supervisingCourses objectAtIndex:i]).id)
                manager = true;
        }
        
        Boolean check = false;
        NSMutableArray *checks = [[NSMutableArray alloc] init];
        [checks addObjectsFromArray:post.clicker.a_students];
        [checks addObjectsFromArray:post.clicker.b_students];
        [checks addObjectsFromArray:post.clicker.c_students];
        [checks addObjectsFromArray:post.clicker.d_students];
        [checks addObjectsFromArray:post.clicker.e_students];
        for (int i = 0; i < checks.count; i++)
            if (user.id == [checks[i] intValue])
                check = true;
        
        double gap = [post.createdAt timeIntervalSinceNow];
        
        if (65.0f + gap > 0.0f && !check && !manager) {
            
            UIFont *cellfont = [UIFont systemFontOfSize:12];
            NSString *rawmessage = post.message;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){200, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            
            if (post.clicker.choice_count == 5)
                return 224 + MAX(ceil(MessageLabelSize.size.height) - 15, 0);
            else
                return 179 + MAX(ceil(MessageLabelSize.size.height) - 15, 0);
        }
    }
    
    UIFont *cellfont = [UIFont systemFontOfSize:12];
    NSString *rawmessage = post.message;
    if ([post.type isEqualToString:@"clicker"])
        rawmessage = [NSString stringWithFormat:@"%@\n%@", post.message, [post.clicker detailText]];
    
    if ([post.type isEqualToString:@"attendance"]) {
        if (self.auth) {
            NSInteger total = (long) (post.attendance.checked_students.count + post.attendance.late_students.count);
            NSInteger total_grade = 0;
            if (self.course.students_count != 0)
                total_grade = (long) ceil((((float)post.attendance.checked_students.count + (float)post.attendance.late_students.count) / (float)self.course.students_count * 100.0f));
            rawmessage = [NSString stringWithFormat:NSLocalizedString(@"%ld/%ld (%ld%%) students has been attended.", nil), (long)total, (long)self.course.students_count, (long)total_grade];
        } else {
            NSString *message1 = NSLocalizedString(@"출석이 확인되었습니다.", nil);
            NSString *message2 = NSLocalizedString(@"결석으로 처리되었습니다.", nil);
            NSString *message3 = NSLocalizedString(@"지각으로 처리되었습니다.", nil);
            NSString *message4 = NSLocalizedString(@"Attendance Check is Ongoing", nil);
            
            if ([post.attendance stateInt:user.id] == 0) {
                if (65.0f + [post.createdAt timeIntervalSinceNow] > 0.0f && [post.attendance.type isEqualToString:@"auto"])
                    rawmessage = message4;
                else
                    rawmessage = message2;
            } else if ([post.attendance stateInt:user.id] == 1){
                rawmessage = message1;
            } else {
                rawmessage = message3;
            }
        }
    }
    
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
    CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){200, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    return 102 + MAX(ceil(MessageLabelSize.size.height) - 15, 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= data.count)
        return [self guideCellWith:tableView with:indexPath.row - data.count];
    
    Post *post = [data objectAtIndex:indexPath.row];
    
    if ([post.type isEqualToString:@"clicker"]) {
        return [self clickerCellWith:tableView with:post];
    } else if ([post.type isEqualToString:@"attendance"]) {
        return [self attendanceCellWith:tableView with:post];
    } else if ([post.type isEqualToString:@"notice"]) {
        return [self noticeCellWith:tableView with:post];
    } else {
        return [self updateAppCellWith:tableView];
    }
}

// GuideCells
- (UITableViewCell *)guideCellWith:(UITableView *)tableView with:(NSInteger)type {
    
    static NSString *CellIdentifier = @"GuidePostCell";
    GuidePostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (type) {
        case 0: { // how to use
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            NSString *string = NSLocalizedString(@"BTTENDANCE를 잘 사용하는 법을 다시 보려면 여기를 누르세요!", nil);
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string rangeOfString:string]];
            cell.Message.attributedText = str;
            cell.Message.numberOfLines = 0;
            [cell.Message sizeToFit];
            cell.Message.frame = CGRectMake(93, 50 - cell.Message.frame.size.height / 2, 200, cell.Message.frame.size.height);
            [cell.check_icon setImage:[UIImage imageNamed:@"bttendance_icon@2x.png"]];
            [cell.check_overlay setImage:nil];
            break;
        }
        case 1: { // clicker
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            NSString *string = NSLocalizedString(@"설문하기 기능을 어떻게 사용하는지 자세히 알아보려면 여기를 누르세요.", nil);
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string rangeOfString:string]];
            cell.Message.attributedText = str;
            cell.Message.numberOfLines = 0;
            [cell.Message sizeToFit];
            cell.Message.frame = CGRectMake(93, 50 - cell.Message.frame.size.height / 2, 200, cell.Message.frame.size.height);
            [cell.check_icon setImage:[UIImage imageNamed:@"pollicon@2x.png"]];
            [cell.check_overlay setImage:nil];
            break;
        }
        case 2: { // attendance
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            NSString *string = NSLocalizedString(@"출석체크 기능을 어떻게 사용하는지 자세히 알아보려면 여기를 누르세요.", nil);
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string rangeOfString:string]];
            cell.Message.attributedText = str;
            cell.Message.numberOfLines = 0;
            [cell.Message sizeToFit];
            cell.Message.frame = CGRectMake(93, 50 - cell.Message.frame.size.height / 2, 200, cell.Message.frame.size.height);
            break;
        }
        default: { //notice
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;
            NSString *string = NSLocalizedString(@"공지하기 기능을 어떻게 사용하는지 자세히 알아보려면 여기를 누르세요.", nil);
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string rangeOfString:string]];
            cell.Message.attributedText = str;
            cell.Message.numberOfLines = 0;
            [cell.Message sizeToFit];
            cell.Message.frame = CGRectMake(93, 50 - cell.Message.frame.size.height / 2, 200, cell.Message.frame.size.height);
            [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
            [cell.check_overlay setImage:nil];
            break;
        }
    }
    
    return cell;
}

// ClickerCell
- (UITableViewCell *)clickerCellWith:(UITableView *)tableView with:(Post *)post {
    
    Boolean manager = false;
    NSArray *supervisingCourses = user.supervising_courses;
    for (int i = 0; i < [supervisingCourses count]; i++) {
        if (post.course.id == ((SimpleCourse *)[supervisingCourses objectAtIndex:i]).id)
            manager = true;
    }
    
    Boolean check = false;
    NSMutableArray *checks = [[NSMutableArray alloc] init];
    [checks addObjectsFromArray:post.clicker.a_students];
    [checks addObjectsFromArray:post.clicker.b_students];
    [checks addObjectsFromArray:post.clicker.c_students];
    [checks addObjectsFromArray:post.clicker.d_students];
    [checks addObjectsFromArray:post.clicker.e_students];
    for (int i = 0; i < checks.count; i++)
        if (user.id == [checks[i] intValue])
            check = true;
    
    double gap = [post.createdAt timeIntervalSinceNow];
    
    // Clicker Choice
    if (65.0f + gap > 0.0f && !check && !manager) {
        static NSString *CellIdentifier = @"ClickerCell";
        ClickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.post = post;
        [cell startTimerAsClicker];
        cell.message.text = cell.post.message;
        cell.date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
        
        cell.message.lineBreakMode = NSLineBreakByWordWrapping;
        cell.message.numberOfLines = 0;
        [cell.message sizeToFit];
        NSInteger height = MAX(cell.message.frame.size.height, 15);
        
        cell.message.frame = CGRectMake(20, 46, 280, height);
        [cell.date setFrame:CGRectMake(97, 133 + height, 200, 21)];
        
        cell.blink_e.hidden = NO;
        cell.bg_e.hidden = NO;
        cell.ring_e.hidden = NO;
        cell.blink_d.hidden = NO;
        cell.bg_d.hidden = NO;
        cell.ring_d.hidden = NO;
        cell.blink_c.hidden = NO;
        cell.bg_c.hidden = NO;
        cell.ring_c.hidden = NO;
        
        if (cell.post.clicker.choice_count < 5) {
            cell.blink_e.hidden = YES;
            cell.bg_e.hidden = YES;
            cell.ring_e.hidden = YES;
        }
        
        if (cell.post.clicker.choice_count < 4) {
            cell.blink_d.hidden = YES;
            cell.bg_d.hidden = YES;
            cell.ring_d.hidden = YES;
        }
        
        if (cell.post.clicker.choice_count < 3) {
            cell.blink_c.hidden = YES;
            cell.bg_c.hidden = YES;
            cell.ring_c.hidden = YES;
        }
        
        [cell.date setFrame:CGRectMake(97, 148, 200, 21)];
        
        double progress = MIN(52.0f * -gap / 65.0f, 52);
        switch (cell.post.clicker.choice_count) {
            case 2: {
                [cell.blink_a setFrame:CGRectMake(89, 64 + height, 52, 52)];
                [cell.blink_b setFrame:CGRectMake(179, 64 + height, 52, 52)];
                
                [cell.ring_a setFrame:CGRectMake(89, 64 + height, 52, 52)];
                [cell.ring_b setFrame:CGRectMake(179, 64 + height, 52, 52)];
                
                cell.bg_a.frame = CGRectMake(89, 64 + height + progress, 52, 52 - progress);
                cell.bg_b.frame = CGRectMake(179, 64 + height + progress, 52, 52 - progress);
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:65.0f + gap];
                cell.bg_a.frame = CGRectMake(89, 116 + height, 52, 0);
                cell.bg_b.frame = CGRectMake(179, 116 + height, 52, 0);
                [UIView commitAnimations];
                break;
            }
            case 3: {
                [cell.blink_a setFrame:CGRectMake(59, 64 + height, 52, 52)];
                [cell.blink_b setFrame:CGRectMake(134, 64 + height, 52, 52)];
                [cell.blink_c setFrame:CGRectMake(209, 64 + height, 52, 52)];
                
                [cell.ring_a setFrame:CGRectMake(59, 64 + height, 52, 52)];
                [cell.ring_b setFrame:CGRectMake(134, 64 + height, 52, 52)];
                [cell.ring_c setFrame:CGRectMake(209, 64 + height, 52, 52)];
                
                cell.bg_a.frame = CGRectMake(59, 64 + height + progress, 52, 52 - progress);
                cell.bg_b.frame = CGRectMake(134, 64 + height + progress, 52, 52 - progress);
                cell.bg_c.frame = CGRectMake(209, 64 + height + progress, 52, 52 - progress);
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:65.0f + gap];
                cell.bg_a.frame = CGRectMake(59, 116 + height, 52, 0);
                cell.bg_b.frame = CGRectMake(134, 116 + height, 52, 0);
                cell.bg_c.frame = CGRectMake(209, 116 + height, 52, 0);
                [UIView commitAnimations];
                break;
            }
            case 4: {
                [cell.blink_a setFrame:CGRectMake(29, 64 + height, 52, 52)];
                [cell.blink_b setFrame:CGRectMake(99, 64 + height, 52, 52)];
                [cell.blink_c setFrame:CGRectMake(169, 64 + height, 52, 52)];
                [cell.blink_d setFrame:CGRectMake(239, 64 + height, 52, 52)];
                
                [cell.ring_a setFrame:CGRectMake(29, 64 + height, 52, 52)];
                [cell.ring_b setFrame:CGRectMake(99, 64 + height, 52, 52)];
                [cell.ring_c setFrame:CGRectMake(169, 64 + height, 52, 52)];
                [cell.ring_d setFrame:CGRectMake(239, 64 + height, 52, 52)];
                
                cell.bg_a.frame = CGRectMake(29, 64 + height + progress, 52, 52 - progress);
                cell.bg_b.frame = CGRectMake(99, 64 + height + progress, 52, 52 - progress);
                cell.bg_c.frame = CGRectMake(169, 64 + height + progress, 52, 52 - progress);
                cell.bg_d.frame = CGRectMake(239, 64 + height + progress, 52, 52 - progress);
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:65.0f + gap];
                cell.bg_a.frame = CGRectMake(29, 116 + height, 52, 0);
                cell.bg_b.frame = CGRectMake(99, 116 + height, 52, 0);
                cell.bg_c.frame = CGRectMake(169, 116 + height, 52, 0);
                cell.bg_d.frame = CGRectMake(239, 116 + height, 52, 0);
                [UIView commitAnimations];
                break;
            }
            case 5:
            default: {
                [cell.blink_a setFrame:CGRectMake(99, 64 + height, 52, 52)];
                [cell.blink_b setFrame:CGRectMake(169, 64 + height, 52, 52)];
                [cell.blink_c setFrame:CGRectMake(64, 124 + height, 52, 52)];
                [cell.blink_d setFrame:CGRectMake(134, 124 + height, 52, 52)];
                [cell.blink_e setFrame:CGRectMake(204, 124 + height, 52, 52)];
                
                [cell.ring_a setFrame:CGRectMake(99, 64 + height, 52, 52)];
                [cell.ring_b setFrame:CGRectMake(169, 64 + height, 52, 52)];
                [cell.ring_c setFrame:CGRectMake(64, 124 + height, 52, 52)];
                [cell.ring_d setFrame:CGRectMake(134, 124 + height, 52, 52)];
                [cell.ring_e setFrame:CGRectMake(204, 124 + height, 52, 52)];
                
                cell.bg_a.frame = CGRectMake(99, 64 + height + progress, 52, 52 - progress);
                cell.bg_b.frame = CGRectMake(169, 64 + height + progress, 52, 52 - progress);
                cell.bg_c.frame = CGRectMake(64, 124 + height + progress, 52, 52 - progress);
                cell.bg_d.frame = CGRectMake(134, 124 + height + progress, 52, 52 - progress);
                cell.bg_e.frame = CGRectMake(204, 124 + height + progress, 52, 52 - progress);
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:65.0f + gap];
                cell.bg_a.frame = CGRectMake(99, 116 + height, 52, 0);
                cell.bg_b.frame = CGRectMake(169, 116 + height, 52, 0);
                cell.bg_c.frame = CGRectMake(64, 176 + height, 52, 0);
                cell.bg_d.frame = CGRectMake(134, 176 + height, 52, 0);
                cell.bg_e.frame = CGRectMake(204, 176 + height, 52, 0);
                [UIView commitAnimations];
                
                [cell.date setFrame:CGRectMake(97, 208, 200, 21)];
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger count = 65 + gap;
        BlinkView *blinkView_a = [[BlinkView alloc] initWithView:cell.blink_a andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_a];
        BlinkView *blinkView_b = [[BlinkView alloc] initWithView:cell.blink_b andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_b];
        BlinkView *blinkView_c = [[BlinkView alloc] initWithView:cell.blink_c andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_c];
        BlinkView *blinkView_d = [[BlinkView alloc] initWithView:cell.blink_d andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_d];
        BlinkView *blinkView_e = [[BlinkView alloc] initWithView:cell.blink_e andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_e];
        
        [cell.ring_a setImage:[UIImage imageNamed:@"a_clicked@2x.png"] forState:UIControlStateHighlighted];
        [cell.ring_b setImage:[UIImage imageNamed:@"b_clicked@2x.png"] forState:UIControlStateHighlighted];
        [cell.ring_c setImage:[UIImage imageNamed:@"c_clicked@2x.png"] forState:UIControlStateHighlighted];
        [cell.ring_d setImage:[UIImage imageNamed:@"d_clicked@2x.png"] forState:UIControlStateHighlighted];
        [cell.ring_e setImage:[UIImage imageNamed:@"e_clicked@2x.png"] forState:UIControlStateHighlighted];
        
        [cell.ring_a addTarget:self action:@selector(click_a:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ring_b addTarget:self action:@selector(click_b:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ring_c addTarget:self action:@selector(click_c:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ring_d addTarget:self action:@selector(click_d:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ring_e addTarget:self action:@selector(click_e:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else { // Clicker Normal
        static NSString *CellIdentifier = @"PostCell";
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        XYPieChart *chart;
        for (UIView *view in  cell.contentView.subviews) {
            if ([view isKindOfClass:[XYPieChart class]]) {
                if (view.tag == post.clicker.id)
                    chart = (XYPieChart *)view;
                else
                    [view removeFromSuperview];
            }
        }
        
        if (chart == nil) {
            chart = [[XYPieChart alloc] initWithFrame:CGRectMake(30, 33, 50, 50)];
            chart.tag = post.clicker.id;
            chart.showLabel = NO;
            chart.pieRadius = 25;
            chart.userInteractionEnabled = NO;
        }
        
        [chart setDataSource:post.clicker];
        [chart reloadData];
        [cell.contentView insertSubview:chart aboveSubview:cell.background];
        
        cell.post = post;
        cell.Title.text = NSLocalizedString(@"Clicker", nil);
        cell.Title.textColor = [BTColor BT_silver:1];
        cell.Message.text = [NSString stringWithFormat:@"%@\n%@", post.message, [post.clicker detailText]];
        cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
        cell.gap = [cell.post.createdAt timeIntervalSinceNow];
        
        [cell.timer invalidate];
        cell.timer = nil;
        if (65.0f + cell.gap > 0.0f)
            [cell startTimerAsClicker];
        
        cell.Message.frame = CGRectMake(93, 49, 200, 15);
        cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
        cell.Message.numberOfLines = 0;
        [cell.Message sizeToFit];
        NSInteger height = MAX(cell.Message.frame.size.height, 15);
        
        [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
        [cell.selected_bg setFrame:CGRectMake(11, 7, 298, 73 + height)];
        [cell.Date setFrame:CGRectMake(97, 56 + height, 200, 21)];
        [cell.background setFrame:CGRectMake(29, 75 / 2, 50, 0)];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [[BTBlink sharedInstance] removeView:cell.check_icon];
        [cell.check_icon setImage:[UIImage imageNamed:@"clickerring@2x.png"]];
        cell.check_icon.frame = CGRectMake(29, 32, 52, 52);
        [cell.check_overlay setImage:nil];
        return cell;
    }
}

// AttendanceCell
- (UITableViewCell *)attendanceCellWith:(UITableView *)tableView with:(Post *)post {
    
    static NSString *CellIdentifier = @"PostCell";
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in  cell.contentView.subviews)
        if ([view isKindOfClass:[XYPieChart class]])
            [view removeFromSuperview];
    
    cell.post = post;
    cell.Title.text = NSLocalizedString(@"Attendance Check", nil);
    cell.Title.textColor = [BTColor BT_silver:1];
    cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
    cell.gap = [cell.post.createdAt timeIntervalSinceNow];
    
    [cell.timer invalidate];
    cell.timer = nil;
    if (65.0f + cell.gap > 0.0f && (self.auth || [post.attendance stateInt:user.id] == 0) && [post.attendance.type isEqualToString:@"auto"])
        [cell startTimerAsAttendance];
    
    cell.Message.frame = CGRectMake(93, 49, 200, 15);
    cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
    cell.Message.numberOfLines = 0;
    NSInteger height = MAX(cell.Message.frame.size.height, 15);
    [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.selected_bg setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.Date setFrame:CGRectMake(97, 56 + height, 200, 21)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.check_icon setImage:[UIImage imageNamed:@"attendancecheckcyan@2x.png"]];
    cell.check_icon.frame = CGRectMake(29, 25, 52, 52);
    [cell.check_overlay setImage:[UIImage imageNamed:@"attendanceringnonalpha@2x.png"]];
    
    if (self.auth) {
        NSInteger total = (long) (post.attendance.checked_students.count + post.attendance.late_students.count);
        NSInteger total_grade = 0;
        if (self.course.students_count != 0)
            total_grade = (long) ceil((((float)post.attendance.checked_students.count + (float)post.attendance.late_students.count) / (float)self.course.students_count * 100.0f));
        [cell.background setFrame:CGRectMake(29, 75 - total_grade / 2, 50, total_grade / 2)];
        
        if (65.0f + cell.gap > 0.0f && [post.attendance.type isEqualToString:@"auto"]) {
            NSInteger count = 65 + cell.gap;
            BlinkView *blinkView = [[BlinkView alloc] initWithView:cell.check_icon andCount:count];
            [[BTBlink sharedInstance] addBlinkView:blinkView];
        } else {
            [[BTBlink sharedInstance] removeView:cell.check_icon];
        }
        cell.Message.text = [NSString stringWithFormat:NSLocalizedString(@"%ld/%ld (%ld%%) students has been attended.", nil), (long)total, (long)self.course.students_count, (long)total_grade];
    } else {
        
        NSString *message1 = NSLocalizedString(@"출석이 확인되었습니다.", nil);
        NSString *message2 = NSLocalizedString(@"결석으로 처리되었습니다.", nil);
        NSString *message3 = NSLocalizedString(@"지각으로 처리되었습니다.", nil);
        NSString *message4 = NSLocalizedString(@"Attendance Check is Ongoing", nil);
        
        if ([post.attendance stateInt:user.id] == 0) {
            if (65.0f + cell.gap > 0.0f && [post.attendance.type isEqualToString:@"auto"]) {
                [self startAttdAnimation:cell];
                NSInteger count = 65 + cell.gap;
                BlinkView *blinkView = [[BlinkView alloc] initWithView:cell.check_icon andCount:count];
                [[BTBlink sharedInstance] addBlinkView:blinkView];
                cell.Message.text = message4;
            } else {
                [[BTBlink sharedInstance] removeView:cell.check_icon];
                [cell.check_icon setImage:[UIImage imageNamed:@"attendfail@2x.png"]];
                [cell.check_overlay setImage:nil];
                [cell.background setFrame:CGRectMake(29, 75 / 2, 50, 0)];
                cell.Message.text = message2;
            }
        } else if ([post.attendance stateInt:user.id] == 1){
            [[BTBlink sharedInstance] removeView:cell.check_icon];
            [cell.check_icon setImage:[UIImage imageNamed:@"attended@2x.png"]];
            [cell.check_overlay setImage:nil];
            [cell.background setFrame:CGRectMake(29, 75 / 2, 50, 0)];
            cell.Message.text = message1;
        } else {
            [[BTBlink sharedInstance] removeView:cell.check_icon];
            [cell.check_icon setImage:[UIImage imageNamed:@"attendlate@2x.png"]];
            [cell.check_overlay setImage:nil];
            [cell.background setFrame:CGRectMake(29, 75 / 2, 50, 0)];
            cell.Message.text = message3;
        }
    }
    [cell.Message sizeToFit];
    return cell;
}

// NoticeCell
- (UITableViewCell *)noticeCellWith:(UITableView *)tableView with:(Post *)post {
    
    static NSString *CellIdentifier = @"PostCell";
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in  cell.contentView.subviews)
        if ([view isKindOfClass:[XYPieChart class]])
            [view removeFromSuperview];
    
    cell.post = post;
    cell.Title.text = NSLocalizedString(@"Notice", nil);
    cell.Title.textColor = [BTColor BT_silver:1];
    
    if (self.auth) {
        NSInteger seen = post.notice.seen_students.count;
        NSInteger total = self.course.students_count;
        cell.Title.text = [NSString stringWithFormat:NSLocalizedString(@"Notice (%ld/%ld 읽음)", nil), seen, total];
    } else if (![post.notice seen:user.id]) {
        cell.Title.text = NSLocalizedString(@"Unread Notice", nil);
        cell.Title.textColor = [BTColor BT_red:1];
    }
    
    cell.Message.text = cell.post.message;
    cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
    cell.gap = [cell.post.createdAt timeIntervalSinceNow];
    
    [cell.timer invalidate];
    cell.timer = nil;
    
    cell.Message.frame = CGRectMake(93, 49, 200, 15);
    cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
    cell.Message.numberOfLines = 0;
    [cell.Message sizeToFit];
    NSInteger height = MAX(cell.Message.frame.size.height, 15);
    [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.selected_bg setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.Date setFrame:CGRectMake(97, 56 + height, 200, 21)];
    
    [cell.background setFrame:CGRectMake(29, 75 / 2, 50, 0)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[BTBlink sharedInstance] removeView:cell.check_icon];
    [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
    if (height > 17)
        cell.check_icon.frame = CGRectMake(29, 32, 52, 52);
    else
        cell.check_icon.frame = CGRectMake(29, 25, 52, 52);
    [cell.check_overlay setImage:nil];
    return cell;
}

// UpdateAppCell
- (UITableViewCell *)updateAppCellWith:(UITableView *)tableView {
    
    static NSString *CellIdentifier = @"GuidePostCell";
    GuidePostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    NSString *string = NSLocalizedString(@"이 게시물은 현재 버전의 앱에서 읽을 수 없습니다. 앱을 업데이트 해주세요.", nil);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string rangeOfString:string]];
    cell.Message.attributedText = str;
    cell.Message.numberOfLines = 0;
    [cell.Message sizeToFit];
    cell.Message.frame = CGRectMake(93, 50 - cell.Message.frame.size.height / 2, 200, cell.Message.frame.size.height);
    [cell.check_icon setImage:[UIImage imageNamed:@"bttendance_icon@2x.png"]];
    [cell.check_overlay setImage:nil];
    
    return cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= data.count) {
        switch (indexPath.row - data.count) {
            case 0: { // how to use
                if (self.auth) {
                    GuideCourseCreateViewController *guide = [[GuideCourseCreateViewController alloc] initWithNibName:@"GuideCourseCreateViewController" bundle:nil];
                    guide.courseCode = [self classcode];
                    [self presentViewController:guide animated:NO completion:nil];
                } else {
                    GuideCourseAttendViewController *guide = [[GuideCourseAttendViewController alloc] initWithNibName:@"GuideCourseAttendViewController" bundle:nil];
                    [self presentViewController:guide animated:NO completion:nil];
                }
                break;
            }
            case 1: { // clicker
                NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
                NSString *url = [NSString stringWithFormat:@"http://www.bttd.co/tutorial/clicker?device_type=iphone&locale=%@&app_version=%@", locale, appVersion];
                WebViewController *tutorial = [[WebViewController alloc] initWithURLString:url];
                [self.navigationController pushViewController:tutorial animated:YES];
                break;
            }
            case 2: { // attendance
                NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
                NSString *url = [NSString stringWithFormat:@"http://www.bttd.co/tutorial/attendance?device_type=iphone&locale=%@&app_version=%@", locale, appVersion];
                WebViewController *tutorial = [[WebViewController alloc] initWithURLString:url];
                [self.navigationController pushViewController:tutorial animated:YES];
                break;
            }
            default: { // notice
                NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                NSString *locale = [[NSLocale preferredLanguages] objectAtIndex:0];
                NSString *url = [NSString stringWithFormat:@"http://www.bttd.co/tutorial/notice?device_type=iphone&locale=%@&app_version=%@", locale, appVersion];
                WebViewController *tutorial = [[WebViewController alloc] initWithURLString:url];
                [self.navigationController pushViewController:tutorial animated:YES];
                break;
            }
        }
        return;
    }
    
    if (data.count != 0 && ![[self.tableview cellForRowAtIndexPath:indexPath] isKindOfClass:[ClickerCell class]]) {
        PostCell *cell = (PostCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
        if ([cell.post.type isEqualToString:@"attendance"]) {
            AttdDetailViewController *attendanceView = [[AttdDetailViewController alloc] initWithNibName:@"AttdDetailViewController" bundle:nil];
            attendanceView.post = cell.post;
            [self.navigationController pushViewController:attendanceView animated:YES];
        }
        
        if ([cell.post.type isEqualToString:@"clicker"]) {
            ClickerDetailViewController *clickerView = [[ClickerDetailViewController alloc] initWithNibName:@"ClickerDetailViewController" bundle:nil];
            clickerView.post = cell.post;
            [self.navigationController pushViewController:clickerView animated:YES];
        }
        
        if ([cell.post.type isEqualToString:@"notice"]) {
            NoticeDetailViewController *noticeView = [[NoticeDetailViewController alloc] initWithNibName:@"NoticeDetailViewController" bundle:nil];
            noticeView.post = cell.post;
            [self.navigationController pushViewController:noticeView animated:YES];
        }
        
        return;
    }
}

#pragma Click Event for Clicker
- (void)click_a:(id)sender {
    UIButton *send = (UIButton *) sender;
    ClickerCell *cell = (ClickerCell *) send.superview.superview.superview;
    [BTAPIs clickWithClicker:[NSString stringWithFormat:@"%d", (int)cell.post.clicker.id]
                      choice:@"1"
                     success:^(Clicker *clicker) {
                     } failure:^(NSError *error) {
                     }];
}
- (void)click_b:(id)sender {
    UIButton *send = (UIButton *) sender;
    ClickerCell *cell = (ClickerCell *) send.superview.superview.superview;
    [BTAPIs clickWithClicker:[NSString stringWithFormat:@"%d", (int)cell.post.clicker.id]
                      choice:@"2"
                     success:^(Clicker *clicker) {
                     } failure:^(NSError *error) {
                     }];
}
- (void)click_c:(id)sender {
    UIButton *send = (UIButton *) sender;
    ClickerCell *cell = (ClickerCell *) send.superview.superview.superview;
    [BTAPIs clickWithClicker:[NSString stringWithFormat:@"%d", (int)cell.post.clicker.id]
                      choice:@"3"
                     success:^(Clicker *clicker) {
                     } failure:^(NSError *error) {
                     }];
}
- (void)click_d:(id)sender {
    UIButton *send = (UIButton *) sender;
    ClickerCell *cell = (ClickerCell *) send.superview.superview.superview;
    [BTAPIs clickWithClicker:[NSString stringWithFormat:@"%d", (int)cell.post.clicker.id]
                      choice:@"4"
                     success:^(Clicker *clicker) {
                     } failure:^(NSError *error) {
                     }];
}
- (void)click_e:(id)sender {
    UIButton *send = (UIButton *) sender;
    ClickerCell *cell = (ClickerCell *) send.superview.superview.superview;
    [BTAPIs clickWithClicker:[NSString stringWithFormat:@"%d", (int)cell.post.clicker.id]
                      choice:@"5"
                     success:^(Clicker *clicker) {
                     } failure:^(NSError *error) {
                     }];
}

#pragma Animation for Attendance
- (void)startAttdAnimation:(PostCell *)cell {
    float height = (65.0f + cell.gap) / 65.0f * 50.0f;
    cell.background.frame = CGRectMake(29, 75 - height, 50, height);
    [UIView animateWithDuration:65.0f + cell.gap
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.background.frame = CGRectMake(29, 75, 50, 0);
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 200 && buttonIndex == 1)
        [self dettend_course];
    if (alertView.tag == 100 && buttonIndex == 1)
        [self open_course];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.auth) {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Would you like to open %@?", nil), simpleCourse.name];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Open Course", nil)
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Open", nil), nil];
            alert.tag = 100;
            [alert show];
        } else {
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Do you really wish to unjoin from course %@?", nil), simpleCourse.name];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UnJoin Course", nil)
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Un Join", nil), nil];
            alert.tag = 200;
            [alert show];
        }
    }
}

#pragma Actions
- (void)start_clicker {
    CreateClickerViewController *clickerView = [[CreateClickerViewController alloc] initWithNibName:@"CreateClickerViewController" bundle:nil];
    clickerView.cid = [NSString stringWithFormat:@"%ld", (long)simpleCourse.id];
    [self.navigationController pushViewController:clickerView animated:YES];
}

- (void)start_attendance {
    CreateAttdViewController *attdView = [[CreateAttdViewController alloc] initWithNibName:@"CreateAttdViewController" bundle:nil];
    attdView.simpleCourse = self.simpleCourse;
    [self.navigationController pushViewController:attdView animated:YES];
}

- (void)create_notice {
    CreateNoticeViewController *noticeView = [[CreateNoticeViewController alloc] initWithNibName:@"CreateNoticeViewController" bundle:nil];
    noticeView.cid = [NSString stringWithFormat:@"%ld", (long)simpleCourse.id];
    [self.navigationController pushViewController:noticeView animated:YES];
}

- (void)dettend_course {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Unjoining Course", nil);
    hud.yOffset = -40.0f;
    [BTAPIs dettendCourse:[NSString stringWithFormat:@"%ld", (long)simpleCourse.id]
                  success:^(User *user) {
                      [hud hide:YES];
                      [self.navigationController popViewControllerAnimated:YES];
                  } failure:^(NSError *error) {
                      [hud hide:YES];
                  }];
}

- (void)open_course {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Opening Course", nil);
    hud.yOffset = -40.0f;
    [BTAPIs openCourse:[NSString stringWithFormat:@"%ld", (long)simpleCourse.id]
                  success:^(User *user) {
                      [hud hide:YES];
                      //Go To Course
                  } failure:^(NSError *error) {
                      [hud hide:YES];
                  }];
}

#pragma Helpers
-(NSString *)schoolName {
    NSString *schoolName;
    if (schoolName == nil) {
        user = [BTUserDefault getUser];
        for (int i = 0; i < [user.enrolled_schools count]; i++)
            if (((SimpleSchool *)user.enrolled_schools[i]).id == simpleCourse.school)
                schoolName = ((SimpleSchool *)user.enrolled_schools[i]).name;
        for (int i = 0; i < [user.employed_schools count]; i++)
            if (((SimpleSchool *)user.employed_schools[i]).id == simpleCourse.school)
                schoolName = ((SimpleSchool *)user.employed_schools[i]).name;
    }
    return schoolName;
}

-(NSString *)classcode {
    if (self.course == nil)
        self.course = [BTUserDefault getCourse:self.simpleCourse.id];
    
    NSString *code = self.course.code;
    if (code == nil)
        code = @"";
    
    return code;
}

@end