//
//  StdFeedView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "FeedViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "PostCell.h"
#import "AttdStatViewController.h"
#import "ClickerDetailViewController.h"
#import "BTAPIs.h"
#import "BTDateFormatter.h"
#import "Clicker.h"
#import "XYPieChart.h"

@implementation FeedViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        rowcount = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFeed:) name:@"NEWMESSAGE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    }
    return self;
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.tableview reloadData];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.tableview reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self refreshFeed:nil];
}

- (void)refreshFeed:(id)sender {
    [BTAPIs feedWithPage:0
                 success:^(NSArray *posts) {
                     data = posts;
                     rowcount = data.count;
                     [self.tableview reloadData];
                 } failure:^(NSError *error) {
                 }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowcount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [data objectAtIndex:indexPath.row];
    
    post.type = @"clicker";
    SimpleClicker *clicker = [[SimpleClicker alloc] init];
    clicker.a_students = [[NSArray alloc] initWithObjects:@"1", nil];
    clicker.b_students = [[NSArray alloc] initWithObjects:@"2", @"3", nil];
    clicker.c_students = [[NSArray alloc] initWithObjects:@"4", @"5", nil];
    clicker.d_students = [[NSArray alloc] initWithObjects:@"6", nil];
//    clicker.e_students = [[NSArray alloc] initWithObjects:@"7", @"8", nil];
    clicker.choice_count = 4;
    post.clicker = clicker;
    
    UIFont *cellfont = [UIFont systemFontOfSize:12];
    NSString *rawmessage = post.message;
    if ([post.type isEqualToString:@"clicker"])
        rawmessage = [NSString stringWithFormat:@"%@\n%@", post.message, [post.clicker detailText]];
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
    CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){200, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    return 102 + ceil(MessageLabelSize.size.height) - 15;
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

- (UITableViewCell *)clickerCellWith:(UITableView *)tableView with:(Post *)post {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    XYPieChart *chart = [[XYPieChart alloc] initWithFrame:CGRectMake(30, 26, 50, 50)];
    chart.showLabel = NO;
    chart.pieRadius = 25;
    [chart setDataSource:post.clicker];
    [chart reloadData];
    [cell.contentView insertSubview:chart aboveSubview:cell.background];
    
    cell.post = post;
    cell.Title.text = cell.post.course.name;
    cell.Message.text = [NSString stringWithFormat:@"%@\n%@", post.message, [post.clicker detailText]];
    cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
    cell.gap = [cell.post.createdAt timeIntervalSinceNow];
    
    cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
    cell.Message.numberOfLines = 0;
    [cell.Message sizeToFit];
    NSInteger height = cell.Message.frame.size.height;
    [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.Date setFrame:CGRectMake(97, 56 + height, 200, 21)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.check_icon setImage:[UIImage imageNamed:@"clickerring@2x.png"]];
    [cell.check_overlay setImage:nil];
    return cell;
}

- (UITableViewCell *)attendanceCellWith:(UITableView *)tableView with:(Post *)post {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.post = post;
    cell.Title.text = cell.post.course.name;
    cell.Message.text = cell.post.message;
    cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
    cell.gap = [cell.post.createdAt timeIntervalSinceNow];
    
    cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
    cell.Message.numberOfLines = 0;
    [cell.Message sizeToFit];
    NSInteger height = cell.Message.frame.size.height;
    [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.Date setFrame:CGRectMake(97, 56 + height, 200, 21)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Boolean check = false;
    NSArray *checks = cell.post.attendance.checked_students;
    for (int i = 0; i < checks.count; i++) {
        if ([BTUserDefault getUser].id == [checks[i] intValue])
            check = true;
    }
    
    Boolean manager = false;
    NSArray *supervisingCourses = [BTUserDefault getUser].supervising_courses;
    for (int i = 0; i < [supervisingCourses count]; i++) {
        if (cell.post.course.id == ((SimpleCourse *)[supervisingCourses objectAtIndex:i]).id)
            manager = true;
    }
    
    if (manager) {
        if (180.0f + cell.gap > 0.0f)
            [self startAnimation:cell];
        else {
            int grade =  [cell.post.grade intValue];
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
    return cell;
}

- (UITableViewCell *)noticeCellWith:(UITableView *)tableView with:(Post *)post {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.post = post;
    cell.Title.text = cell.post.course.name;
    cell.Message.text = cell.post.message;
    cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
    cell.gap = [cell.post.createdAt timeIntervalSinceNow];
    
    cell.Message.lineBreakMode = NSLineBreakByWordWrapping;
    cell.Message.numberOfLines = 0;
    [cell.Message sizeToFit];
    NSInteger height = cell.Message.frame.size.height;
    [cell.cellbackground setFrame:CGRectMake(11, 7, 298, 73 + height)];
    [cell.Date setFrame:CGRectMake(97, 56 + height, 200, 21)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
    [cell.check_overlay setImage:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (data.count != 0) {
        PostCell *cell = (PostCell *) [self.tableview cellForRowAtIndexPath:indexPath];

        Boolean manager = false;
        NSArray *supervisingCourses = [BTUserDefault getUser].supervising_courses;
        for (int i = 0; i < [supervisingCourses count]; i++)
            if (cell.post.course.id == ((SimpleCourse *)supervisingCourses[i]).id)
                manager = true;

        if (manager && [cell.post.type isEqualToString:@"attendance"]) {
            AttdStatViewController *statView = [[AttdStatViewController alloc] initWithNibName:@"AttdStatViewController" bundle:nil];
            statView.postId = cell.post.id;
            statView.courseId = cell.post.course.id;
            statView.courseName = cell.post.course.name;
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

#pragma Animation for Clicker

#pragma Animation for Attendance
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

@end
