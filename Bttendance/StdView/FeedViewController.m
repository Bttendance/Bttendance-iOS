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
#import "BTNotification.h"
#import "Clicker.h"
#import "XYPieChart.h"
#import "BTBlink.h"
#import "AttendanceAgent.h"
#import "ClickerCell.h"
#import "SocketAgent.h"

@implementation FeedViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        data = [[NSMutableArray alloc] init];
        rowcount = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFeed:) name:FeedRefresh object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClicker:) name:ClickerUpdated object:nil];
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
    user = [BTUserDefault getUser];
    [self.tableview reloadData];
    [self refreshFeed:nil];
    
}

- (void)refreshFeed:(id)sender {
    [BTAPIs feedWithPage:0
                 success:^(NSArray *posts) {
                     int count = (int)data.count;
                     data = [NSMutableArray arrayWithArray:posts];
                     rowcount = data.count;
                     if (count == data.count)
                         [self.tableview reloadRowsAtIndexPaths:[self.tableview indexPathsForVisibleRows]
                                               withRowAnimation:UITableViewRowAnimationNone];
                     else
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
    for (int i = 0; i < data.count; i++) {
        Post *post = data[i];
        if ([post.type isEqualToString:@"clicker"] && clicker.id == post.clicker.id) {
            [post.clicker copyDataFromClicker:clicker];
        }
    }
    [self.tableview reloadRowsAtIndexPaths:[self.tableview indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
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
    
    if (array.count > 0) {
        for (NSString *ID in array)
             [[SocketAgent sharedInstance] connetWithClicker:ID];
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
        ClickerCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        cell.post = post;
        cell.courseName.text = cell.post.course.name;
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
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
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
            chart = [[XYPieChart alloc] initWithFrame:CGRectMake(30, 26, 50, 50)];
            chart.tag = post.clicker.id;
            chart.showLabel = NO;
            chart.pieRadius = 25;
            chart.userInteractionEnabled = NO;
        }
        
        [chart setDataSource:post.clicker];
        [chart reloadData];
        [cell.contentView insertSubview:chart aboveSubview:cell.background];
        
        cell.post = post;
        cell.Title.text = cell.post.course.name;
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
        [cell.check_overlay setImage:nil];
        return cell;
    }
}

// AttendanceCell
- (UITableViewCell *)attendanceCellWith:(UITableView *)tableView with:(Post *)post {
    
    static NSString *CellIdentifier = @"PostCell";
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    for (UIView *view in  cell.contentView.subviews)
        if ([view isKindOfClass:[XYPieChart class]])
            [view removeFromSuperview];
    
    cell.post = post;
    cell.Title.text = post.course.name;
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
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    for (UIView *view in  cell.contentView.subviews)
        if ([view isKindOfClass:[XYPieChart class]])
            [view removeFromSuperview];
    
    cell.post = post;
    cell.Title.text = cell.post.course.name;
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

@end
