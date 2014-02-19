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
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/course/feed"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        
        data = responsObject;
        NSLog(@"data , %@", data);
        
        rowcount = data.count;
        [_tableview reloadData];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"get course's feeds fail : %@", error);
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
    
    static NSString *CellIentifierCP = @"PostCell";
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIentifierCP];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.Title.text = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.Message.text = [[data objectAtIndex:indexPath.row] objectForKey:@"message"];
    cell.PostID = [[[data objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    //time convert
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    NSDateFormatter *dm = [[NSDateFormatter alloc] init];
    [dm setTimeZone:[NSTimeZone timeZoneWithName:@"KST"]];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateformatter setTimeZone:gmt];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dm setDateFormat:@"yy/MM/dd HH:mm"];
    NSDate *updatedAt = [dateformatter dateFromString:[[data objectAtIndex:indexPath.row] objectForKey:@"updatedAt"]];
    
    cell.Date.text = [dm stringFromDate:updatedAt];
    updatedAt = [dm dateFromString:cell.Date.text];
    
    NSTimeInterval secs = [updatedAt timeIntervalSinceNow];
    
    cell.gap = secs;
    
    
    cell.backgroundColor = [BTColor BT_grey:1];
    cell.cellbackground.backgroundColor = [BTColor BT_white:1];
    cell.cellbackground.layer.cornerRadius = 2;

    cell.timer = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(time + cell.gap <= 0){//time over;
        //check attendance completed
        NSArray *temp = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
        Boolean check = false;
        for(int i = 0; i < temp.count ; i++){
            NSString *check_id = [NSString stringWithFormat:@"%@",[[[data objectAtIndex:indexPath.row] objectForKey:@"checks"]objectAtIndex:i]];
            if([my_id isEqualToString:check_id]){
                check = true;
            }
        }
        if(!check){ // NOT ATTENDANCE!!!!
            //change image
            [cell.check_icon setImage:[UIImage imageNamed:@"attendfail@2x.png"]];
            [cell.check_button setBackgroundImage:Nil forState:UIControlStateNormal];
        }
    }
    else{//ongoing
        NSArray *temp = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
        Boolean check = false;
        for(int i = 0; i < temp.count ; i++){
            NSString *check_id = [NSString stringWithFormat:@"%@",[[[data objectAtIndex:indexPath.row] objectForKey:@"checks"] objectAtIndex:i]];
            if([my_id isEqualToString:check_id]){
                check = true;
            }
        }
        if(check){
            [cell.background setImage:nil];
        }
        else{
            [self showing_timer_post:cell];
        }
    }
    
    return cell;
    
}


-(void)showing_timer_post:(PostCell *)cell{
    float a = -cell.gap;
    float ratio = a/(float)time;
    
    if(time > a){
        [cell.background setImage:[UIImage imageNamed:@"0072b0.png"]];
        
        CGRect frame1 = cell.background.frame;
        frame1.size.height = cell.background.frame.size.height*(1.0f - ratio);
        frame1.origin.y = cell.background.frame.origin.y + cell.background.frame.size.height*ratio;
        cell.background.frame = frame1;
        
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:(time -a)];
        
        CGRect frame = cell.background.frame;
        frame.size.height = 0.0f;
        frame.origin.y = 77.0f;
        cell.background.frame = frame;
        [UIImageView commitAnimations];
        
        cell.timer = cell.timer - cell.gap;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(change_check_post2:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil] repeats:YES];
    }
}

-(void)change_check_post2:(NSTimer *)timer{
    PostCell *cell = [[timer userInfo] objectForKey:@"cell"];
    
    NSInteger i = cell.timer;
    
    if(i >= 2*time){
        [timer invalidate];
        timer = nil;
        i = 0;
    }
    
    int j = i%2;
    
    switch (j) {
        case 0:{
            cell.check_icon.alpha = 0;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:0.5];
            cell.check_icon.alpha = 1;
            [UIImageView commitAnimations];
            i++;
            cell.timer = i;
            break;
        }
        case 1:{
            cell.check_icon.alpha = 1;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:0.5];
            cell.check_icon.alpha = 0;
            [UIImageView commitAnimations];
            i++;
            cell.timer = i;
            break;
        }
        default:
            break;
    }
    
}

-(void)showgrade:(CGFloat)grade :(CourseDetailHeaderView *)view{
    CGRect frame = view.grade.frame;
    frame.size.height = 94.0f * (100.0f-grade) / 100.0f;
    [view.grade setFrame:frame];
    NSLog(@"set grade showing");
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