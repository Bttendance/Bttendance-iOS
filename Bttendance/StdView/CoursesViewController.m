//
//  StdCourseView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CoursesViewController.h"
#import "BTUserDefault.h"

#import "BTColor.h"
#import "CourseCell.h"
#import "CourseDetailViewController.h"
#import "BTAPIs.h"
#import "SchoolChooseViewController.h"
#import "BTDateFormatter.h"
#import "CreateNoticeViewController.h"
#import "CreateClickerViewController.h"
#import "Course.h"
#import "BTNotification.h"
#import "AttendanceAgent.h"
#import "BTBlink.h"

@interface CoursesViewController ()

@end

@implementation CoursesViewController

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];

    if (self) {
        data = [[NSMutableArray alloc] init];
        user = [BTUserDefault getUser];

        UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [plusButton addTarget:self action:@selector(plusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"plus@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *plusButtonItem = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
        [self.navigationItem setRightBarButtonItem:plusButtonItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCourses:) name:CoursesRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
    }

    return self;
}

- (void)plusButtonPressed:(id)selector {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Create Course", @"Attend Course", nil];
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BTColor BT_grey:1];
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    [self refreshUser];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.tableview reloadData];
    [self checkAttdScan];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUser];
    [self.tableview reloadData];
    [self refreshCourses:nil];
}

- (void)reloadTableView:(NSNotification *)noti {
    [self.tableview reloadData];
}

- (void)refreshCourses:(id)sender {
    [BTAPIs coursesInSuccess:^(NSArray *courses) {
        for (Course *course in courses)
            [[NSNotificationCenter defaultCenter] postNotificationName:CourseUpdated object:course];
        data = courses;
        [self.tableview reloadData];
        [self checkAttdScan];
        [self refreshCheck];
    } failure:^(NSError *error) {
    }];
}

- (void)checkAttdScan {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (Course *course in data) {
        double gap = [course.attdCheckedAt timeIntervalSinceNow];
        if (180.0f + gap > 0.0f && course.attdCheckedAt != nil)
            [array addObject:[NSString stringWithFormat:@"%d", (int)course.id]];
    }
    
    if (array.count > 0) {
        AttendanceAgent *agent = [AttendanceAgent sharedInstance];
        [agent startAttdScanWithCourseIDs:array];
    }
}

- (void)refreshCheck {
    float gap = 0.0f;
    for (Course *course in data) {
        float interval = [course.attdCheckedAt timeIntervalSinceNow];
        if (interval > -180.0f
            && gap > interval) {
            gap = interval;
        }
    }
    
    if (gap < 0.0f) {
        if (refreshTimer != nil)
            [refreshTimer invalidate];
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:180.0f + gap
                                                        target:self
                                                      selector:@selector(refreshCourses:)
                                                      userInfo:nil
                                                       repeats:NO];
    }
}

- (void)refreshUser {
    user = [BTUserDefault getUser];
    rowcount1 = [user.supervising_courses count];
    rowcount2 = [user.attending_courses count];
    sectionCount = 0;
    if (rowcount1 > 0)
        sectionCount++;
    if (rowcount2 > 0)
        sectionCount++;
    
    if (sectionCount == 0)
        _noCourseView.hidden = NO;
    else
        _noCourseView.hidden = YES;
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (sectionCount == 2) {
        switch (section) {
            case 0:
                return @"Supervising Courses";
            case 1:
            default:
                return @"Attending Courses";
        }
    } else if (sectionCount == 1) {
        if (rowcount1 > 0)
            return @"Supervising Courses";
        else
            return @"Attending Courses";
    } else
        return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sectionCount == 2) {
        switch (section) {
            case 0:
                return rowcount1;
            case 1:
            default:
                return rowcount2;
        }
    } else if (sectionCount == 1) {
        if (rowcount1 > 0)
            return rowcount1;
        else
            return rowcount2;
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sectionCount == 2) {
        switch (indexPath.section) {
            case 0:
                return [self supervisingCellWith:tableView at:indexPath.row];
            case 1:
            default:
                return [self attendingCellWith:tableView at:indexPath.row];
        }
    } else if (sectionCount == 1) {
        if (rowcount1 > 0)
            return [self supervisingCellWith:tableView at:indexPath.row];
        else
            return [self attendingCellWith:tableView at:indexPath.row];
    } else
        return nil;
}

- (UITableViewCell *)supervisingCellWith:(UITableView *)tableView at:(NSInteger)rowIndex {

    static NSString *CellIdentifier = @"CourseCell";

    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    [[BTBlink sharedInstance] removeView:cell.check_icon];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (data.count != 0) {
        for (int i = 0; i < data.count; i++) {
            if (((SimpleCourse *)[user.supervising_courses objectAtIndex:rowIndex]).id ==
                    ((Course *)[data objectAtIndex:i]).id) {
                cell.course = [data objectAtIndex:i];
                cell.CourseName.text = cell.course.name;
                cell.Professor.text = cell.course.professor_name;
                cell.School.text = cell.course.school.name;
                cell.isManager = true;
                [cell.background setFrame:CGRectMake(239, 75 - [cell.course.grade integerValue] / 2, 50, [cell.course.grade integerValue] / 2)];
                
                cell.gap = -180.0f;
                if (cell.course != nil && cell.course.attdCheckedAt != nil)
                    cell.gap = [cell.course.attdCheckedAt timeIntervalSinceNow];
                if (180.0f + cell.gap > 0.0f)
                    [self startAnimation:cell];
                else
                    [[BTBlink sharedInstance] removeView:cell.check_icon];

                break;
            }
        }
    } else {
        cell.simpleCourse = [user.supervising_courses objectAtIndex:rowIndex];
        for (int i = 0; i < [user.employed_schools count]; i++)
            if (((SimpleSchool *)user.employed_schools[i]).id == cell.simpleCourse.school)
                cell.School.text = ((SimpleSchool *)user.employed_schools[i]).name;
        cell.CourseName.text = cell.simpleCourse.name;
        cell.Professor.text = cell.simpleCourse.professor_name;
        cell.isManager = true;
        [cell.background setFrame:CGRectMake(239, 75 - [cell.course.grade integerValue] / 2, 50, [cell.course.grade integerValue] / 2)];
        [[BTBlink sharedInstance] removeView:cell.check_icon];
    }
    
    [cell.attendanceBt addTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
    [cell.clickerBt addTarget:self action:@selector(clickerStart:) forControlEvents:UIControlEventTouchUpInside];
    [cell.noticeBt addTarget:self action:@selector(createNotice:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.clickerBt.hidden = NO;
    cell.attendanceBt.hidden = NO;
    cell.noticeBt.hidden = NO;
    
    cell.clickerView.hidden = NO;
    cell.attendanceView.hidden = NO;
    cell.noticeView.hidden = NO;
    
    return cell;
}

- (UITableViewCell *)attendingCellWith:(UITableView *)tableView at:(NSInteger)rowIndex {

    static NSString *CellIdentifier = @"CourseCell";

    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (data.count != 0) {
        for (int i = 0; i < data.count; i++) {
            if (((SimpleCourse *)[user.attending_courses objectAtIndex:rowIndex]).id ==
                ((Course *)[data objectAtIndex:i]).id) {
                cell.course = [data objectAtIndex:i];
                cell.CourseName.text = cell.course.name;
                cell.Professor.text = cell.course.professor_name;
                cell.School.text = cell.course.school.name;
                cell.isManager = false;
                [cell.background setFrame:CGRectMake(239, 75 - [cell.course.grade integerValue] / 2, 50, [cell.course.grade integerValue] / 2)];

                cell.gap = [cell.course.attdCheckedAt timeIntervalSinceNow];
                if (180.0f + cell.gap > 0.0f && cell.course.attdCheckedAt != nil)
                    [self startAnimation:cell];
                else
                    [[BTBlink sharedInstance] removeView:cell.check_icon];

                break;
            }
        }
    } else {
        cell.simpleCourse = [user.attending_courses objectAtIndex:rowIndex];
        for (int i = 0; i < [user.enrolled_schools count]; i++)
            if (((SimpleSchool *)user.enrolled_schools[i]).id == cell.simpleCourse.school)
                cell.School.text = ((SimpleSchool *)user.enrolled_schools[i]).name;
        cell.CourseName.text = cell.simpleCourse.name;
        cell.Professor.text = cell.simpleCourse.professor_name;
        cell.isManager = false;
        [cell.background setFrame:CGRectMake(239, 75 - [cell.course.grade integerValue] / 2, 50, [cell.course.grade integerValue] / 2)];
        [[BTBlink sharedInstance] removeView:cell.check_icon];
    }
    
    [cell.attendanceBt removeTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
    [cell.clickerBt removeTarget:self action:@selector(clickerStart:) forControlEvents:UIControlEventTouchUpInside];
    [cell.noticeBt removeTarget:self action:@selector(createNotice:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.clickerBt.hidden = YES;
    cell.attendanceBt.hidden = YES;
    cell.noticeBt.hidden = YES;
    
    cell.clickerView.hidden = YES;
    cell.attendanceView.hidden = YES;
    cell.noticeView.hidden = YES;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sectionCount == 2) {
        switch (indexPath.section) {
            case 0:
                return 146.0f;
            case 1:
            default:
                return 102.0f;
        }
    } else if (sectionCount == 1) {
        if (rowcount1 > 0)
            return 146.0f;
        else
            return 102.0f;
    } else
        return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell *cell = (CourseCell *) [self.tableview cellForRowAtIndexPath:indexPath];
    CourseDetailViewController *courseDetailViewController = [[CourseDetailViewController alloc] initWithNibName:@"CourseDetailViewController" bundle:nil];
    courseDetailViewController.course = cell.course;
    courseDetailViewController.simpleCourse = cell.simpleCourse;
    courseDetailViewController.auth = cell.isManager;
    [self.navigationController pushViewController:courseDetailViewController animated:YES];
}

#pragma Course Button Animation
- (void)startAnimation:(CourseCell *)cell {
    float height = (180.0f + cell.gap) / 180.0f * 50.0f;
    cell.background.frame = CGRectMake(239, 75 - height, 50, height);
    [UIView animateWithDuration:180.0f + cell.gap
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [cell.background setFrame:CGRectMake(239, 75, 50, 0)];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [cell.background setFrame:CGRectMake(239, 75 - [cell.course.grade integerValue] / 2, 50, [cell.course.grade integerValue] / 2)];
                         }
                     }];
    
    NSInteger count = 180 + cell.gap;
    BlinkView *blinkView = [[BlinkView alloc] initWithView:cell.check_icon andCount:count];
    [[BTBlink sharedInstance] addBlinkView:blinkView];
}

#pragma Button Events
- (void)move_to_school:(BOOL)auth {
    SchoolChooseViewController *schoolChooseView = [[SchoolChooseViewController alloc] init];
    schoolChooseView.auth = auth;
    [self.navigationController pushViewController:schoolChooseView animated:YES];
}

- (void)attdStart:(id)sender {
    UIButton *send = (UIButton *) sender;
    CourseCell *cell = (CourseCell *) send.superview.superview.superview;
    NSString *courseName;
    NSString *courseID;
    if (cell.course != nil) {
        courseName = [NSString stringWithFormat:@"%@", cell.course.name];
        courseID = [NSString stringWithFormat:@"%ld", (long) cell.course.id];
    } else {
        courseName = [NSString stringWithFormat:@"%@", cell.simpleCourse.name];
        courseID = [NSString stringWithFormat:@"%ld", (long) cell.simpleCourse.id];
    }
    [[AttendanceAgent sharedInstance] startAttdWithCourseName:courseName andID:courseID];
}

- (void)clickerStart:(id)sender {
    UIButton *send = (UIButton *) sender;
    CourseCell *cell = (CourseCell *) send.superview.superview.superview;
    
    CreateClickerViewController *clickerView = [[CreateClickerViewController alloc] initWithNibName:@"CreateClickerViewController" bundle:nil];
    if (cell.course != nil)
        clickerView.cid = [NSString stringWithFormat:@"%ld", (long) cell.course.id];
    else
        clickerView.cid = [NSString stringWithFormat:@"%ld", (long) cell.simpleCourse.id];
    [self.navigationController pushViewController:clickerView animated:YES];
}

- (void)createNotice:(id)sender {
    UIButton *send = (UIButton *) sender;
    CourseCell *cell = (CourseCell *) send.superview.superview.superview;

    CreateNoticeViewController *noticeView = [[CreateNoticeViewController alloc] initWithNibName:@"CreateNoticeViewController" bundle:nil];
    if (cell.course != nil)
        noticeView.cid = [NSString stringWithFormat:@"%ld", (long) cell.course.id];
    else
        noticeView.cid = [NSString stringWithFormat:@"%ld", (long) cell.simpleCourse.id];
    [self.navigationController pushViewController:noticeView animated:YES];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self move_to_school:YES];
            break;
        case 1:
            [self move_to_school:NO];
            break;
        case 2:
        default:
            break;
    }
}

@end
