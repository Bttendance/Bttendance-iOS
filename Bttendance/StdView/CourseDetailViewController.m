//
//  StdCourseDetailView.m
//  Bttendance
//
//  Created by HAJE on 2014. 1. 24..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "CourseDetailViewController.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController
@synthesize currentcell, auth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userinfo = [BTUserDefault getUserInfo];
        my_id = [userinfo objectForKey:UseridKey];
        time = 180;
    }
    return self;
}

- (void)viewDidLoad
{
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
    
    if(auth) {
        [coursedetailheaderview.BTicon addTarget:self action:@selector(BTiconAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [coursedetailheaderview setFrame:CGRectMake(0, 0, 320, 170)];
        [coursedetailheaderview.bg setFrame:CGRectMake(10, 10, 300, 156)];
        coursedetailheaderview.gradeBt.hidden = YES;
        coursedetailheaderview.noticeBt.hidden = YES;
        coursedetailheaderview.managerBt.hidden = YES;
    }
    
    [self showgrade:currentcell.grade :coursedetailheaderview];
    self.tableview.tableHeaderView = coursedetailheaderview;
}

-(void)viewWillAppear:(BOOL)animated {
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *cid = [NSString stringWithFormat:@"%ld", (long)currentcell.CourseID];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":cid};
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/course/feed"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        
        data = responsObject;
        NSLog(@"data , %@", data);
        
        rowcount = data.count;
        [_tableview reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"get course's feeds fail : %@", error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rowcount;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
                // Show Attd Stat
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
                     }];
    
    
    cell.blinkTime = 180 + cell.gap;
    if (cell.blink != nil)
        [cell.blink invalidate];
    NSTimer *blink = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(blink:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil] repeats:YES];
    cell.blink = blink;
}

-(void)blink:(NSTimer *)timer {
    PostCell *cell = [[timer userInfo] objectForKey:@"cell"];
    
    cell.blinkTime--;
    if (cell.blinkTime < 0) {
        cell.check_icon.alpha = 1;
        if (cell.blink != nil)
            [cell.blink invalidate];
        cell.blink = nil;
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

-(void)showgrade:(CGFloat)grade :(CourseDetailHeaderView *)view{
    CGRect frame = view.grade.frame;
    frame.size.height = 94.0f * (100.0f-grade) / 100.0f;
    [view.grade setFrame:frame];
}

-(void)BTiconAction:(id)sender{
    NSLog(@"BTicon pressed");
}

-(void)show_grade{
    GradeViewController *gradeView = [[GradeViewController alloc] initWithNibName:@"GradeViewController" bundle:nil];
    gradeView.cid = [NSString stringWithFormat:@"%ld", (long) currentcell.CourseID];
    gradeView.currentcell = currentcell;
    [self.navigationController pushViewController:gradeView animated:YES];
}

-(void)create_notice{
    CreateNoticeViewController *noticeView = [[CreateNoticeViewController alloc] initWithNibName:@"CreateNoticeViewController" bundle:nil];
    noticeView.cid = [NSString stringWithFormat:@"%ld",(long) currentcell.CourseID];
    noticeView.currentcell = currentcell;
    [self.navigationController pushViewController:noticeView animated:YES];
}

-(void)show_manager{
    ManagerViewController *managerView = [[ManagerViewController alloc] initWithNibName:@"ManagerViewController" bundle:nil];
    managerView.courseId = currentcell.CourseID;
    managerView.courseName = currentcell.CourseName.text;
    [self.navigationController pushViewController:managerView animated:YES];
}



@end