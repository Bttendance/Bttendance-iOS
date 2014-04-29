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
#import "BTAPIs.h"
#import "BTDateFormatter.h"

@interface FeedViewController ()

@end

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
    [self.tableview reloadData];
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
    return 102.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];

    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    cell.post = [data objectAtIndex:indexPath.row];
    cell.Title.text = cell.post.course.name;
    cell.Message.text = cell.post.message;
    cell.Date.text = [BTDateFormatter stringFromDate:cell.post.createdAt];
    cell.gap = [cell.post.createdAt timeIntervalSinceNow];
    cell.cellbackground.layer.cornerRadius = 2;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([cell.post.type isEqualToString:@"notice"]) {
        [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
        [cell.check_overlay setImage:nil];
    } else {
        Boolean check = false;
        NSArray *checks = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
        for (int i = 0; i < checks.count; i++) {
            NSString *check_id = [NSString stringWithFormat:@"%@", [[[data objectAtIndex:indexPath.row] objectForKey:@"checks"] objectAtIndex:i]];
            if ([BTUserDefault getUser].id == [check_id integerValue])
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

@end
