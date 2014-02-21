//
//  CourseView.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "CourseAttendView.h"

@interface CourseAttendView ()

@end

@implementation CourseAttendView
@synthesize sid;
@synthesize sname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rowcount0 = 0;
        rowcount1 = 0;
        data0 = [[NSMutableArray alloc] init];
        data1 = [[NSMutableArray alloc] init];
        
        userinfo = [BTUserDefault getUserInfo];
//        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set tableview background color
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    
    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Attend Course", @"");
    [titlelabel sizeToFit];
    
    
    // Do any additional setup after loading the view from its nib.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];

    NSString *username = [[BTUserDefault getUserInfo] objectForKey:UsernameKey];
    NSString *password = [[BTUserDefault getUserInfo] objectForKey:PasswordKey];
    NSString *school_id = [NSString stringWithFormat:@"%ld", (long)sid];

    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"school_id":school_id};
    
    NSArray *attdcourse = [[NSUserDefaults standardUserDefaults] objectForKey:AttendingCoursesKey];
    NSArray *supvcourse = [[NSUserDefaults standardUserDefaults] objectForKey:SupervisingCoursesKey];

    NSLog(@"user info : %@",params);
    [AFmanager GET:[BTURL stringByAppendingString:@"/school/courses"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Get Joinable Courses List success : %@", responseObject);
        NSDictionary *courselist = responseObject;
        NSLog(@"course count : %lu", (unsigned long)courselist.count);
        
        if(attdcourse.count != 0){
            for(int i = 0 ; i < courselist.count; i++){
                Boolean joined = false;
                for(int j = 0; j < attdcourse.count; j++){
                    int attd_int = [attdcourse[j] intValue];
                    int course_int = [[[responseObject objectAtIndex:i] objectForKey:@"id"] intValue];
                    
                    if(attd_int == course_int){
                        joined = true;
                        break;
                    }
                }
                Boolean supved = false;
                for(int j = 0; j < supvcourse.count; j++){
                    int attd_int = [supvcourse[j] intValue];
                    int course_int = [[[responseObject objectAtIndex:i] objectForKey:@"id"] intValue];
                    
                    if(attd_int == course_int){
                        supved = true;
                        break;
                    }
                }
                if(joined)
                    [data0 addObject:[responseObject objectAtIndex:i]];
                else if (!supved)
                    [data1 addObject:[responseObject objectAtIndex:i]];
            }
            rowcount0 = data0.count;
            rowcount1 = data1.count;
            [self.tableview reloadData];
        } else{
            data0 = nil;
            rowcount0 = 0;
            data1 = responseObject;
            rowcount1 = data1.count;
            [self.tableview reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get Joinable Courses List fail %@", error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

-(IBAction)check_button_action:(id)sender{
    
    UIButton *comingbutton = (UIButton *)sender;
    CourseInfoCell *comingcell = (CourseInfoCell *)comingbutton.superview.superview.superview;
    currentcell = comingcell;
    
    NSArray *enrolledSchools = [[BTUserDefault getUserInfo] objectForKey:EnrolledSchoolsKey];
    BOOL hasBeenEnrolled = NO;
    for (int i=0;i<[enrolledSchools count];i++)
        if ([[enrolledSchools[i] objectForKey:@"id"] integerValue] == sid)
            hasBeenEnrolled = YES;
    
    if (hasBeenEnrolled) {
        NSString *string = [NSString stringWithFormat:@"%@ %@\n%@\n%@ ", comingcell.Info_CourseNumber, comingcell.Info_CourseName.text, comingcell.Info_ProfName.text, comingcell.Info_SchoolName ] ;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Course" message:string delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [alert show];
    } else {
        UIAlertView * alert2 = [[UIAlertView alloc] initWithTitle:@"Student ID or Phone Number"
                                                          message:[NSString stringWithFormat:@"Before you join course %@, you need to enter your student ID or your phone number", comingcell.Info_CourseName.text]
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Confirm", Nil];
        alert2.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert2 show];
    }

    NSLog(@"sender to button %@",comingbutton);
    NSLog(@"button's cell : %@", comingcell);
    NSLog(@"button's coursename : %@", comingcell.Info_CourseName.text);
    NSLog(@"button's profname : %@",comingcell.Info_ProfName.text);
    NSLog(@"button's courseid : %ld",(long)comingcell.Info_CourseID);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return rowcount0;
        case 1:
        default:
            return rowcount1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Attending Courses";
        case 1:
        default:
            return @"Joinable Courses";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CourseInfoCell";
    
    CourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(indexPath.section == 0){
        cell.Info_ProfName.text = [[data0 objectAtIndex:indexPath.row] objectForKey:@"professor_name"];
        cell.Info_CourseName.text = [[data0 objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.Info_CourseID = [[[data0 objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.backgroundColor  = [BTColor BT_white:1];
        [cell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_SchoolName = [[data0 objectAtIndex:indexPath.row] objectForKey:@"school_name"];
        cell.Info_CourseNumber = [[data0 objectAtIndex:indexPath.row] objectForKey:@"number"];
    }
    if(indexPath.section == 1){
        cell.Info_ProfName.text = [[data1 objectAtIndex:indexPath.row] objectForKey:@"professor_name"];
        cell.Info_CourseName.text = [[data1 objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.Info_CourseID = [[[data1 objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.backgroundColor  = [BTColor BT_white:1];
        [cell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrolladd@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_SchoolName = [[data1 objectAtIndex:indexPath.row] objectForKey:@"school_name"];
        cell.Info_CourseNumber = [[data1 objectAtIndex:indexPath.row] objectForKey:@"number"];
        [cell.Info_Button addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){//cancel
        //restore button event
        [currentcell.Info_Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    
    if ([alertView alertViewStyle] == UIAlertViewStyleDefault) {
        [self attendCourse];
    }
    
    if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput) {
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        
        NSString *username = [[BTUserDefault getUserInfo] objectForKey:UsernameKey];
        NSString *password = [[BTUserDefault getUserInfo] objectForKey:PasswordKey];
        
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                @"school_id":[NSString stringWithFormat:@"%d",sid],
                               @"student_id":[[alertView textFieldAtIndex:0] text]};
        
        [AFmanager PUT:[BTURL stringByAppendingString:@"/user/enroll/school"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
            [BTUserDefault setUserInfo:responsObject];
            [self attendCourse];
        }failure:^(AFHTTPRequestOperation *opration, NSError *error){
            NSString *string = @"Could not join course, please try again";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

-(void) attendCourse {

    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];

    NSString *username = [[BTUserDefault getUserInfo] objectForKey:UsernameKey];
    NSString *password = [[BTUserDefault getUserInfo] objectForKey:PasswordKey];
    NSString *cid = [NSString stringWithFormat:@"%ld",(long)currentcell.Info_CourseID];

    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":cid};

    [AFmanager PUT:[BTURL stringByAppendingString:@"/user/attend/course"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        NSLog(@"join course success : %@", responsObject);
        [BTUserDefault setUserInfo:responsObject];
        
        [[self tableview] beginUpdates];
        [currentcell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
        rowcount1--;
        rowcount0++;
        NSIndexPath *comingcell_index = [[self tableview] indexPathForCell:currentcell];
        for (int i = 0; i < [data1 count]; i++) {
            if ([[[data1 objectAtIndex:i] objectForKey:@"id"] intValue] == currentcell.Info_CourseID) {
                [data0 addObject:[data1 objectAtIndex:i]];
                [data1 removeObjectAtIndex:i];
            }
        }
        [[self tableview] moveRowAtIndexPath:comingcell_index toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[self tableview] endUpdates];

    }failure:^(AFHTTPRequestOperation *opration, NSError *error){
        NSString *string = @"Could not join course, please try again";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [currentcell.Info_Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

@end
