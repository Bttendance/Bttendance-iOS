//
//  StdFeedView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        rowcount = 0;
        userinfo = [BTUserDefault getUserInfo];
        my_id = [userinfo objectForKey:UseridKey];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tableview reloadData];
    [self refreshFeed:nil];
}

-(void)refreshFeed:(id)sender{
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/feed"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        data = responsObject;
        rowcount = data.count;
        [self.tableview reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rowcount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.Title.text = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.Message.text = [[data objectAtIndex:indexPath.row] objectForKey:@"message"];
    cell.PostID = [[[data objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    cell.CourseID = [[[data objectAtIndex:indexPath.row] objectForKey:@"course"] intValue];
    cell.CourseName = [[data objectAtIndex:indexPath.row] objectForKey:@"course_name"];
    
    NSString *createdAt = [[data objectAtIndex:indexPath.row] objectForKey:@"createdAt"];
    cell.createdDate = [BTDateFormatter dateFromUTC:createdAt];
    cell.Date.text = [BTDateFormatter stringFromUTC:createdAt];
    cell.gap = [BTDateFormatter intervalFromUTC:createdAt];
    cell.cellbackground.layer.cornerRadius = 2;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([[[data objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"notice"]){
        cell.isNotice = true;
        [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
        [cell.check_overlay setImage:nil];
    } else {
        cell.isNotice = false;
        
        Boolean check = false;
        NSArray *checks = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
        for(int i = 0; i < checks.count ; i++){
            NSString *check_id = [NSString stringWithFormat:@"%@",[[[data objectAtIndex:indexPath.row] objectForKey:@"checks"] objectAtIndex:i]];
            if([my_id isEqualToString:check_id])
                check = true;
        }
        
        Boolean manager = false;
        NSArray *supervisingCourses = [[BTUserDefault getUserInfo] objectForKey:SupervisingCoursesKey];
        for (int i = 0; i < [supervisingCourses count]; i++) {
            if ([[[data objectAtIndex:indexPath.row] objectForKey:@"course"] intValue] == [[supervisingCourses objectAtIndex:i] intValue])
                manager = true;
        }
        
        if (manager) {
            if(180.0f + cell.gap > 0.0f)
                [self startAnimation:cell];
            else {
                int grade = [[[data objectAtIndex:indexPath.row] objectForKey:@"grade"] intValue];
                [cell.background setFrame:CGRectMake(29, 75 - grade / 2, 50, grade / 2)];
            }
        } else {
            if(!check) {
                if(180.0f + cell.gap > 0.0f) {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(data.count != 0) {
        
        PostCell *cell = (PostCell *)[self.tableview cellForRowAtIndexPath:indexPath];
        
        Boolean manager = false;
        NSArray *supervisingCourses = [[BTUserDefault getUserInfo] objectForKey:SupervisingCoursesKey];
        for (int i = 0; i < [supervisingCourses count]; i++) {
            if (cell.CourseID == [[supervisingCourses objectAtIndex:i] intValue])
                manager = true;
        }
        
        if (!manager || cell.isNotice)
            return;
        
        AttdStatViewController *statView = [[AttdStatViewController alloc] initWithNibName:@"AttdStatViewController" bundle:nil];
        statView.postId = cell.PostID;
        statView.courseId = cell.CourseID;
        statView.courseName = cell.CourseName;
        [self.navigationController pushViewController:statView animated:YES];
    }
}

-(void)startAnimation:(PostCell *)cell {
    
    float height = (180.0f + cell.gap) / 180.0f * 50.0f;
    cell.background.frame = CGRectMake(29, 75 - height, 50, height);
    [UIView animateWithDuration:180.0f + cell.gap
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.background.frame = CGRectMake(29, 75, 50, 0);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self refreshFeed:nil];
                     }];
    
    cell.blinkTime = 180 + cell.gap;
    if (cell.blink != nil)
        [cell.blink invalidate];
    NSTimer *blink = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(blink:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell, @"cell", nil] repeats:YES];
    cell.blink = blink;
}

-(void)blink:(NSTimer *)timer {
    PostCell *cell = [[timer userInfo] objectForKey:@"cell"];
    
    cell.blinkTime--;
    if (cell.blinkTime < 0) {
        
        Boolean manager = false;
        NSArray *supervisingCourses = [[BTUserDefault getUserInfo] objectForKey:SupervisingCoursesKey];
        for (int i = 0; i < [supervisingCourses count]; i++) {
            if (cell.CourseID == [[supervisingCourses objectAtIndex:i] intValue])
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
