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
    [self tableview].backgroundColor = [BttendanceColor BT_grey:1];
    
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
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
        NSString *username = [[BTUserDefault getUserInfo] objectForKey:UsernameKey];
        NSString *password = [[BTUserDefault getUserInfo] objectForKey:PasswordKey];
        NSString *school_id = [NSString stringWithFormat:@"%ld", (long)sid];
    
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"school_id":school_id};
    
        NSArray *attdcourse = [[NSUserDefaults standardUserDefaults] objectForKey:AttendingCoursesKey];
    
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
                    if(joined)
                        [data0 addObject:[responseObject objectAtIndex:i]];
                    else
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
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Get Joinable Courses List fail %@", error);
        }];

    
}

-(IBAction)check_button_action1:(id)sender{
    
    //course join
    
    UIButton *comingbutton = (UIButton *)sender;
    
    CourseInfoCell *comingcell = (CourseInfoCell *)comingbutton.superview.superview.superview;
    
    currentcell = comingcell;
    
    
    //alert showing
    NSString *string = [NSString stringWithFormat:@"%@ %@\n%@\n%@ ", comingcell.Info_CourseNumber, comingcell.Info_CourseName.text, comingcell.Info_ProfName.text, comingcell.Info_SchoolName ] ;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Course" message:string delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert show];
    
    NSLog(@"sender to button %@",comingbutton);
    NSLog(@"button's cell : %@", comingcell);
    NSLog(@"button's coursename : %@", comingcell.Info_CourseName.text);
    NSLog(@"button's profname : %@",comingcell.Info_ProfName.text);
    NSLog(@"button's courseid : %ld",(long)comingcell.Info_CourseID);
    
    
    //disable button
    [comingbutton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section ==0)
        return rowcount0;
    
    else if(section == 1)
        return rowcount1;
    else
        return 0;
//    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section ==0){
        return @"Attending Courses";
    }
    else {
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
        cell.backgroundColor  = [BttendanceColor BT_white:1];
        [cell.Info_Check addTarget:self action:@selector(check_button_action1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrolladd@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_SchoolName = [[data0 objectAtIndex:indexPath.row] objectForKey:@"school_name"];
        cell.Info_CourseNumber = [[data0 objectAtIndex:indexPath.row] objectForKey:@"number"];
    }
    if(indexPath.section == 1){
        cell.Info_ProfName.text = [[data1 objectAtIndex:indexPath.row] objectForKey:@"professor_name"];
        cell.Info_CourseName.text = [[data1 objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.Info_CourseID = [[[data1 objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.backgroundColor  = [BttendanceColor BT_white:1];
        [cell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_SchoolName = [[data1 objectAtIndex:indexPath.row] objectForKey:@"school_name"];
        cell.Info_CourseNumber = [[data1 objectAtIndex:indexPath.row] objectForKey:@"number"];
    }
    return cell;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){//confirm
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        
        
        NSString *username = [[BTUserDefault getUserInfo] objectForKey:UsernameKey];
        NSString *password = [[BTUserDefault getUserInfo] objectForKey:PasswordKey];
        
        NSString *cid = [NSString stringWithFormat:@"%ld",(long)currentcell.Info_CourseID];
        
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"course_id":cid};
        
        [AFmanager PUT:[BTURL stringByAppendingString:@"/user/attend/course"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
            NSLog(@"join course success : %@", responsObject);
            //join!!
            
            //change icon
            [currentcell.Info_Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
            //move to section 1
            rowcount1++;
            [[self tableview] beginUpdates];
            NSIndexPath *comingcell_index = [[self tableview] indexPathForCell:currentcell];
            [[self tableview] moveRowAtIndexPath:comingcell_index toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            rowcount0--;
            [[self tableview] endUpdates];
            
        }failure:^(AFHTTPRequestOperation *opration, NSError *error){
            NSLog(@"join course fail : %@", error);
            //fail
            
            //display alert
            NSString *string = @"Could not join course, please try again";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            //restore button event
            [currentcell.Info_Check addTarget:self action:@selector(check_button_action1:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    if(buttonIndex == 0){//cancel
        //restore button event
        [currentcell.Info_Check addTarget:self action:@selector(check_button_action1:) forControlEvents:UIControlEventTouchUpInside];
    }

}

@end
