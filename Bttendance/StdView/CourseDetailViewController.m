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
#import "CreateClickerViewController.h"
#import "ManagerViewController.h"
#import "AttdStatViewController.h"
#import "BTDateFormatter.h"
#import "BTUserDefault.h"
#import "BTNotification.h"
#import "Post.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "User.h"
#import "AttendanceAgent.h"
#import "SocketAgent.h"
#import "ClickerCell.h"
#import "BTBlink.h"
#import "ClickerDetailViewController.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController
@synthesize course, simpleCourse, auth;

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setting:(id)sender {
    if (auth && [self opened]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                                   destructiveButtonTitle:NSLocalizedString(@"Close Course", nil)
                                                        otherButtonTitles:NSLocalizedString(@"Add Manager", nil),
                                      NSLocalizedString(@"Show Grades", nil),
                                      NSLocalizedString(@"Export Grades", nil),
                                      NSLocalizedString(@"Attendance Grades", nil),
                                      NSLocalizedString(@"Clicker Grades", nil), nil];
        [actionSheet showInView:self.view];
    } else if (auth && ![self opened]) {
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
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFeed:) name:FeedRefresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader:) name:CourseUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClicker:) name:ClickerUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    NSString *title = [self courseName];
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(title, @"");
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

    //set header view
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseDetailHeaderView" owner:self options:nil];
    coursedetailheaderview = [topLevelObjects objectAtIndex:0];
    
    [self refreshHeader:nil];
    
    user = [BTUserDefault getUser];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [BTUserDefault getPostsOfArray:[self courseId]];
        rowcount = data.count;
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    });
    
    rowcount = data.count;
    auth = simpleCourse.opened && [user supervising:simpleCourse.id];

    if (!auth) {
        [coursedetailheaderview setFrame:CGRectMake(0, 0, 320, 178)];
        [coursedetailheaderview.bg setFrame:CGRectMake(10, 10, 300, 161)];
        coursedetailheaderview.clickerBt.hidden = YES;
        coursedetailheaderview.attendanceBt.hidden = YES;
        coursedetailheaderview.noticeBt.hidden = YES;
        coursedetailheaderview.clickerView.hidden = YES;
        coursedetailheaderview.attendanceView.hidden = YES;
        coursedetailheaderview.noticeView.hidden = YES;
    }
    
    if (!simpleCourse.opened) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    
    if (simpleCourse.opened || auth) {
        UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [settingButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setBackgroundImage:[UIImage imageNamed:@"setting@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *plusButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
        [self.navigationItem setRightBarButtonItem:plusButtonItem];
    }

    CGRect frame = coursedetailheaderview.grade.frame;
//    frame.size.height = 94.0f * (100.0f - [[self grade] intValue]) / 100.0f;
    [coursedetailheaderview.grade setFrame:frame];
    self.tableview.tableHeaderView = coursedetailheaderview;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 4)];
    self.tableview.tableFooterView = footer;
}

- (void)refreshHeader:(id)sender {
    NSNotification *notification = sender;
    if ([notification object] != nil)
        course = [notification object];

    coursedetailheaderview.profname.text = [self profName];
    coursedetailheaderview.schoolname.text = [self schoolName];
    coursedetailheaderview.background.layer.cornerRadius = 52.5f;
    coursedetailheaderview.background.layer.masksToBounds = YES;
    
    [coursedetailheaderview.clickerBt addTarget:self action:@selector(start_clicker) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.attendanceBt addTarget:self action:@selector(start_attendance) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.noticeBt addTarget:self action:@selector(create_notice) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    user = [BTUserDefault getUser];
    [self.tableview reloadData];
    [self refreshFeed:nil];
    
}

- (void)refreshFeed:(id)sender {
    [BTAPIs feedForCourse:[self courseId]
                     page:0
                  success:^(NSArray *posts) {
                     data = [NSMutableArray arrayWithArray:posts];
                     rowcount = data.count;
                     [self.tableview reloadData];
                     [self checkAttendanceScan];
                     [self checkClickerScan];
                     [self refreshCheck];
                  } failure:^(NSError *error) {
                  }];
}

// UpdateClicker Notification Event
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

// Check if any attendance is on-going
- (void)checkAttendanceScan {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Post *post in data) {
        double gap = [post.createdAt timeIntervalSinceNow];
        if (180.0f + gap > 0.0f && [post.type isEqualToString:@"attendance"])
            [array addObject:[NSString stringWithFormat:@"%d", (int)post.attendance.id]];
    }
    
    if (array.count > 0) {
        AttendanceAgent *agent = [AttendanceAgent sharedInstance];
        [agent startAttdScanWithAttendanceIDs:array];
    }
}
// Check is any clicker is on-going
- (void)checkClickerScan {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Post *post in data) {
        double gap = [post.createdAt timeIntervalSinceNow];
        if (60.0f + gap > 0.0f && [post.type isEqualToString:@"clicker"])
            [array addObject:[NSString stringWithFormat:@"%d", (int)post.clicker.id]];
    }
}

// Check when to refresh feed
- (void)refreshCheck {
    float gap = 180.0f;
    
    for (Post *post in data) {
        float interval = [post.createdAt timeIntervalSinceNow];
        
        if ([post.type isEqualToString:@"attendance"]
            && interval > -180.0f
            && gap > 180.0f + interval) {
            gap = 180.0f + interval;
            NSLog(@"gap : %f", gap);
        }
        
        if ([post.type isEqualToString:@"clicker"]
            && interval > -60.0f
            && gap > 60.0f + interval) {
            gap = 60.0f + interval;
            NSLog(@"gap : %f", gap);
        }
    }
    
    if (gap < 180.0f) {
        if (refreshTimer != nil)
            [refreshTimer invalidate];
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:gap
                                                        target:self
                                                      selector:@selector(refreshFeed:)
                                                      userInfo:nil
                                                       repeats:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowcount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [data objectAtIndex:indexPath.row];
    
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
        
        if (60.0f + gap > 0.0f && !check && !manager) {
            
            UIFont *cellfont = [UIFont systemFontOfSize:12];
            NSString *rawmessage = post.message;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){200, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            
            return 179 + MAX(ceil(MessageLabelSize.size.height) - 15, 0);
        }
    }
    
    UIFont *cellfont = [UIFont systemFontOfSize:12];
    NSString *rawmessage = post.message;
    if ([post.type isEqualToString:@"clicker"])
        rawmessage = [NSString stringWithFormat:@"%@\n%@", post.message, [post.clicker detailText]];
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
    CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){200, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    return 102 + MAX(ceil(MessageLabelSize.size.height) - 15, 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [data objectAtIndex:indexPath.row];
    
    if ([post.type isEqualToString:@"clicker"]) {
        return [self clickerCellWith:tableView with:post];
    } else if ([post.type isEqualToString:@"attendance"]) {
        return [self attendanceCellWith:tableView with:post];
    } else {
        return [self noticeCellWith:tableView with:post];
    }
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
    if (60.0f + gap > 0.0f && !check && !manager) {
        static NSString *CellIdentifier = @"ClickerCell";
        ClickerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.post = post;
        cell.courseName.text = NSLocalizedString(@"Clicker", nil);
        cell.message.text = cell.post.message;
        cell.date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
        
        cell.message.lineBreakMode = NSLineBreakByWordWrapping;
        cell.message.numberOfLines = 0;
        [cell.message sizeToFit];
        NSInteger height = MAX(cell.message.frame.size.height, 15);
        
        cell.message.frame = CGRectMake(20, 46, 280, height);
        [cell.date setFrame:CGRectMake(97, 133 + height, 200, 21)];
        
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
        
        [cell.blink_a setFrame:CGRectMake(29, 64 + height, 52, 52)];
        [cell.blink_b setFrame:CGRectMake(99, 64 + height, 52, 52)];
        [cell.blink_c setFrame:CGRectMake(169, 64 + height, 52, 52)];
        [cell.blink_d setFrame:CGRectMake(239, 64 + height, 52, 52)];
        
        [cell.ring_a setFrame:CGRectMake(29, 64 + height, 52, 52)];
        [cell.ring_b setFrame:CGRectMake(99, 64 + height, 52, 52)];
        [cell.ring_c setFrame:CGRectMake(169, 64 + height, 52, 52)];
        [cell.ring_d setFrame:CGRectMake(239, 64 + height, 52, 52)];
        
        double progress = MIN(52.0f * -gap / 60.0f, 52);
        cell.bg_a.frame = CGRectMake(29, 64 + height + progress, 52, 52 - progress);
        cell.bg_b.frame = CGRectMake(99, 64 + height + progress, 52, 52 - progress);
        cell.bg_c.frame = CGRectMake(169, 64 + height + progress, 52, 52 - progress);
        cell.bg_d.frame = CGRectMake(239, 64 + height + progress, 52, 52 - progress);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:60.0f + gap];
        cell.bg_a.frame = CGRectMake(29, 116 + height, 52, 0);
        cell.bg_b.frame = CGRectMake(99, 116 + height, 52, 0);
        cell.bg_c.frame = CGRectMake(169, 116 + height, 52, 0);
        cell.bg_d.frame = CGRectMake(239, 116 + height, 52, 0);
        [UIView commitAnimations];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger count = 60 + gap;
        BlinkView *blinkView_a = [[BlinkView alloc] initWithView:cell.blink_a andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_a];
        BlinkView *blinkView_b = [[BlinkView alloc] initWithView:cell.blink_b andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_b];
        BlinkView *blinkView_c = [[BlinkView alloc] initWithView:cell.blink_c andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_c];
        BlinkView *blinkView_d = [[BlinkView alloc] initWithView:cell.blink_d andCount:count];
        [[BTBlink sharedInstance] addBlinkView:blinkView_d];
        
        [cell.ring_a setImage:[UIImage imageNamed:@"a_clicked@2x.png"] forState:UIControlStateHighlighted];
        [cell.ring_b setImage:[UIImage imageNamed:@"b_clicked@2x.png"] forState:UIControlStateHighlighted];
        [cell.ring_c setImage:[UIImage imageNamed:@"c_clicked@2x.png"] forState:UIControlStateHighlighted];
        [cell.ring_d setImage:[UIImage imageNamed:@"d_clicked@2x.png"] forState:UIControlStateHighlighted];
        
        [cell.ring_a addTarget:self action:@selector(click_a:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ring_b addTarget:self action:@selector(click_b:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ring_c addTarget:self action:@selector(click_c:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ring_d addTarget:self action:@selector(click_d:) forControlEvents:UIControlEventTouchUpInside];
        
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
        cell.Message.text = [NSString stringWithFormat:@"%@\n%@", post.message, [post.clicker detailText]];
        cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
        cell.gap = [cell.post.createdAt timeIntervalSinceNow];
        
        cell.Message.frame = CGRectMake(93, 49, 200, 15);
        cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
        cell.Message.numberOfLines = 0;
        [cell.Message sizeToFit];
        NSInteger height = MAX(cell.Message.frame.size.height, 15);
        
        [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
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
    cell.Title.text = NSLocalizedString(@"Attendance", nil);
    cell.Message.text = post.message;
    cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
    cell.gap = [cell.post.createdAt timeIntervalSinceNow];
    
    cell.Message.frame = CGRectMake(93, 49, 200, 15);
    cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
    cell.Message.numberOfLines = 0;
    [cell.Message sizeToFit];
    NSInteger height = MAX(cell.Message.frame.size.height, 15);
    [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.Date setFrame:CGRectMake(97, 56 + height, 200, 21)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Boolean check = false;
    NSArray *checks = cell.post.attendance.checked_students;
    for (int i = 0; i < checks.count; i++) {
        if (user.id == [checks[i] intValue])
            check = true;
    }
    
    Boolean manager = false;
    NSArray *supervisingCourses = user.supervising_courses;
    for (int i = 0; i < [supervisingCourses count]; i++) {
        if (cell.post.course.id == ((SimpleCourse *)[supervisingCourses objectAtIndex:i]).id)
            manager = true;
    }
    
    [cell.check_icon setImage:[UIImage imageNamed:@"attendancecheckcyan@2x.png"]];
    cell.check_icon.frame = CGRectMake(29, 25, 52, 52);
    [cell.check_overlay setImage:[UIImage imageNamed:@"attendanceringnonalpha@2x.png"]];
    
    if (manager) {
        if (180.0f + cell.gap > 0.0f) {
            [self startAttdAnimation:cell];
            NSInteger count = 180 + cell.gap;
            BlinkView *blinkView = [[BlinkView alloc] initWithView:cell.check_icon andCount:count];
            [[BTBlink sharedInstance] addBlinkView:blinkView];
        } else {
            [[BTBlink sharedInstance] removeView:cell.check_icon];
            int grade =  [cell.post.grade intValue];
            [cell.background setFrame:CGRectMake(29, 75 - grade / 2, 50, grade / 2)];
        }
    } else {
        if (!check) {
            if (180.0f + cell.gap > 0.0f) {
                [self startAttdAnimation:cell];
                NSInteger count = 180 + cell.gap;
                BlinkView *blinkView = [[BlinkView alloc] initWithView:cell.check_icon andCount:count];
                [[BTBlink sharedInstance] addBlinkView:blinkView];
            } else {
                [[BTBlink sharedInstance] removeView:cell.check_icon];
                [cell.check_icon setImage:[UIImage imageNamed:@"attendfail@2x.png"]];
                [cell.check_overlay setImage:nil];
                [cell.background setFrame:CGRectMake(29, 75 / 2, 50, 0)];
            }
        } else {
            [[BTBlink sharedInstance] removeView:cell.check_icon];
            [cell.background setFrame:CGRectMake(29, 75 / 2, 50, 0)];
        }
    }
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
    cell.Message.text = cell.post.message;
    cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
    cell.gap = [cell.post.createdAt timeIntervalSinceNow];
    
    cell.Message.frame = CGRectMake(93, 49, 200, 15);
    cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
    cell.Message.numberOfLines = 0;
    [cell.Message sizeToFit];
    NSInteger height = MAX(cell.Message.frame.size.height, 15);
    [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.Date setFrame:CGRectMake(97, 56 + height, 200, 21)];
    
    [cell.background setFrame:CGRectMake(29, 75 / 2, 50, 0)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[BTBlink sharedInstance] removeView:cell.check_icon];
    [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
    cell.check_icon.frame = CGRectMake(29, 25, 52, 52);
    [cell.check_overlay setImage:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (data.count != 0 && ![[self.tableview cellForRowAtIndexPath:indexPath] isKindOfClass:[ClickerCell class]]) {
        PostCell *cell = (PostCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
        Boolean manager = false;
        NSArray *supervisingCourses = user.supervising_courses;
        for (int i = 0; i < [supervisingCourses count]; i++)
            if (cell.post.course.id == ((SimpleCourse *)supervisingCourses[i]).id)
                manager = true;
        
        if (manager && [cell.post.type isEqualToString:@"attendance"]) {
            AttdStatViewController *statView = [[AttdStatViewController alloc] initWithNibName:@"AttdStatViewController" bundle:nil];
            statView.post = cell.post;
            [self.navigationController pushViewController:statView animated:YES];
        }
        
        if ([cell.post.type isEqualToString:@"clicker"]) {
            ClickerDetailViewController *clickerView = [[ClickerDetailViewController alloc] initWithNibName:@"ClickerDetailViewController" bundle:nil];
            clickerView.post = cell.post;
            [self.navigationController pushViewController:clickerView animated:YES];
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

#pragma Animation for Attendance
- (void)startAttdAnimation:(PostCell *)cell {
    float height = (180.0f + cell.gap) / 180.0f * 50.0f;
    cell.background.frame = CGRectMake(29, 75 - height, 50, height);
    [UIView animateWithDuration:180.0f + cell.gap
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
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            if (auth)
                [self show_grades];
            else {
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Do you really wish to unjoin from course %@?", nil), [self courseName]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UnJoin Course", nil)
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Un Join", nil), nil];
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
    CreateClickerViewController *clickerView = [[CreateClickerViewController alloc] initWithNibName:@"CreateClickerViewController" bundle:nil];
    clickerView.cid = [self courseId];
    [self.navigationController pushViewController:clickerView animated:YES];
}

- (void)start_attendance {
    NSString *courseName = [self courseName];
    NSString *courseID = [self courseId];
    [[AttendanceAgent sharedInstance] startAttdWithCourseName:courseName andID:courseID];
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
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Exporting Grades", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs exportGradesWithCourse:[self courseId]
                           success:^(Email *email) {
                               [hud hide:YES];
                               NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Exporting Grades has been finished.\nPlease check your email.\n%@", nil), email.email];
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Exporting Grades", nil)
                                                                               message:message
                                                                              delegate:self
                                                                     cancelButtonTitle:nil
                                                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                               [alert show];
                           } failure:^(NSError *error) {
                               [hud hide:YES];
                           }];
}

- (void)dettend_course {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Unjoining Course", nil);
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

-(BOOL)opened {
    BOOL opened = course.opened;
    if (course == nil)
        opened = simpleCourse.opened;
    return opened;
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

-(NSString *)attendanceRate {
    NSString *grade = course.attendance_rate;
    if (grade == nil)
        grade = @"0";
    return grade;
}

-(NSString *)clickerRate {
    NSString *grade = course.clicker_rate;
    if (grade == nil)
        grade = @"0";
    return grade;
}

-(NSString *)noticeUnseen {
    NSString *grade = course.notice_unseen;
    if (grade == nil)
        grade = @"0";
    return grade;
}

@end