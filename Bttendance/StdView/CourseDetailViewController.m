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

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController
@synthesize currentcell, auth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFeed:) name:@"NEWMESSAGE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9.5, 15)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.tableview reloadData];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *title = currentcell.CourseName.text;

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

    coursedetailheaderview.profname.text = currentcell.Professor.text;
    coursedetailheaderview.schoolname.text = currentcell.School.text;
    coursedetailheaderview.background.layer.cornerRadius = 52.5f;
    coursedetailheaderview.background.layer.masksToBounds = YES;

    [coursedetailheaderview.noticeBt addTarget:self action:@selector(create_notice) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.gradeBt addTarget:self action:@selector(show_grade) forControlEvents:UIControlEventTouchUpInside];
    [coursedetailheaderview.managerBt addTarget:self action:@selector(show_manager) forControlEvents:UIControlEventTouchUpInside];

    if (auth) {
        [coursedetailheaderview.BTicon addTarget:self action:@selector(BTiconAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [coursedetailheaderview setFrame:CGRectMake(0, 0, 320, 170)];
        [coursedetailheaderview.bg setFrame:CGRectMake(10, 10, 300, 156)];
        coursedetailheaderview.gradeBt.hidden = YES;
        coursedetailheaderview.noticeBt.hidden = YES;
        coursedetailheaderview.managerBt.hidden = YES;
    }

    [self showgrade:[currentcell.course.grade integerValue]:coursedetailheaderview];
    self.tableview.tableHeaderView = coursedetailheaderview;
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshFeed:nil];
}

- (void)refreshFeed:(id)sender {
    
    [BTAPIs feedForCourse:[NSString stringWithFormat:@"%ld", (long) currentcell.course.id]
                     page:1
                  success:^(NSArray *posts) {
                      data = posts;
                      rowcount = data.count;
                      [_tableview reloadData];
                  } failure:^(NSError *error) {
                  }];
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
    cell.Title.text = currentcell.course.name;
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
        statView.postId = cell.post.id;
        statView.courseId = cell.post.course.id;
        statView.courseName = cell.post.course.name;
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

- (void)show_grade {
    GradeViewController *gradeView = [[GradeViewController alloc] initWithNibName:@"GradeViewController" bundle:nil];
    gradeView.cid = [NSString stringWithFormat:@"%ld", (long) currentcell.course.id];
    gradeView.currentcell = currentcell;
    [self.navigationController pushViewController:gradeView animated:YES];
}

- (void)create_notice {
    CreateNoticeViewController *noticeView = [[CreateNoticeViewController alloc] initWithNibName:@"CreateNoticeViewController" bundle:nil];
    noticeView.cid = [NSString stringWithFormat:@"%ld", (long) currentcell.course.id];
    noticeView.currentcell = currentcell;
    [self.navigationController pushViewController:noticeView animated:YES];
}

- (void)show_manager {
    ManagerViewController *managerView = [[ManagerViewController alloc] initWithNibName:@"ManagerViewController" bundle:nil];
    managerView.courseId = currentcell.course.id;
    managerView.courseName = currentcell.CourseName.text;
    [self.navigationController pushViewController:managerView animated:YES];
}


@end