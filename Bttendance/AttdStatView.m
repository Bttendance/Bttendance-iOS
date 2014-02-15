//
//  CourseView.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "AttdStatView.h"

@interface AttdStatView ()

@end

@implementation AttdStatView

@synthesize courseId, courseName, postId;

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
        viewscope = true;
        self.navigationItem.hidesBackButton = NO;
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
    titlelabel.text = courseName;
    [titlelabel sizeToFit];
    
    
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"professor"]){
        
        [_tab_bar setSelectedItem:_Course];//setting for  temp
        [_Feed setEnabled:FALSE];
    }
    else{
        [_tab_bar setSelectedItem:_Feed];//setting for  temp
    }
    
    // Do any additional setup after loading the view from its nib.
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
        NSString *username = [[BTUserDefault getUserInfo] objectForKey:UsernameKey];
        NSString *password = [[BTUserDefault getUserInfo] objectForKey:PasswordKey];
    
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"course_id":[NSString stringWithFormat:@"%ld", (long)courseId]};
    
        NSLog(@"params info : %@",params);
        [AFmanager GET:[BTURL stringByAppendingString:@"/course/students"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"Get Joinable Courses List success : %@", responseObject);
            NSDictionary *studentlist = responseObject;
            NSLog(@"course count : %lu", (unsigned long)studentlist.count);
            
            NSString *postAPI = [NSString stringWithFormat:[BTURL stringByAppendingString:@"/post/%ld"],(long)postId];
            [AFmanager GET:postAPI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject_){
                NSDictionary *checks = [responseObject_ objectForKey:@"checks"];
                
                if(studentlist.count != 0){
                    for(int i = 0; i< studentlist.count; i++){
                        BOOL checked = false;
                        for(int j = 0; j < checks.count; j++){
                            
                            NSString *value = [[responseObject_ objectForKey:@"checks"] objectAtIndex:j];
                            int checkedId = [value intValue];
                            int studentId = [[[responseObject objectAtIndex:i] objectForKey:@"id"] intValue];
                            
                            if(studentId == checkedId){
                                checked = true;
                            }
                        }
                        
                        if (checked) {
                            NSLog(@"unchecked %@",[responseObject objectAtIndex:i]);
                            [data1 addObject:[responseObject objectAtIndex:i]];
                        } else {
                            NSLog(@"checked %@",[responseObject objectAtIndex:i]);
                            [data0 addObject:[responseObject objectAtIndex:i]];
                        }
                    }
                    rowcount0 = data0.count;
                    rowcount1 = data1.count;
                    [self.tableview reloadData];
                }
                else{
                    data0 = responseObject;
                    rowcount0 = data0.count;
                    data1 = nil;
                    rowcount1 = 0;
                    [self.tableview reloadData];
                }
                NSLog(@"section 0 info : %@", data0);
                NSLog(@"section 1 info : %@", data1);
                
            }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                NSLog(@"Get Post Fail : %@", error);
            }];
    
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Get Course Student List fail %@", error);
        }];

    
}

-(void)viewWillAppear:(BOOL)animated{
    viewscope = true;
    
    if([[userinfo objectForKey:@"btd_type"] isEqualToString:@"professor"]){
        
        [_tab_bar setSelectedItem:_Course];//setting for  temp
        [_Feed setEnabled:FALSE];
    }
    else{
        [_tab_bar setSelectedItem:_Course];//setting for  temp
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)check_button_action :(id)sender{
    
    //attendance check manually
    UIButton *comingbutton = (UIButton *)sender;
    UserInfoCell *comingcell = (UserInfoCell *)comingbutton.superview.superview.superview;
    currentcell = comingcell;
    
    
    //alert showing
    NSString *string = [NSString stringWithFormat:@"Do you want to approve %@'s attendance check manually?", comingcell.Info_Username] ;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attendance Check" message:string delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert show];
    
    NSLog(@"sender to button %@",comingbutton);
    NSLog(@"button's cell : %@", comingcell);
    NSLog(@"button's username : %@", comingcell.Info_Username);
    NSLog(@"button's email : %@",comingcell.Info_Email);
    NSLog(@"button's userid : %ld",(long)comingcell.Info_UserID);
    
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
        return @"Attendance un-checked students";
    }
    else if(section == 1){
        return @"Attendance checked students";
    }
    else{
        return @" ";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UserInfoCell";
    
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(indexPath.section == 0){
        cell.Username.text = [[data0 objectAtIndex:indexPath.row] objectForKey:@"full_name"];
        cell.Email.text = [[data0 objectAtIndex:indexPath.row] objectForKey:@"email"];
        cell.Info_UserID = [[[data0 objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.backgroundColor  = [BttendanceColor BT_white:1];
        [cell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.Check setBackgroundImage:[UIImage imageNamed:@"enrolladd@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_Username = [[data0 objectAtIndex:indexPath.row] objectForKey:@"full_name"];
        cell.Info_Email = [[data0 objectAtIndex:indexPath.row] objectForKey:@"email"];
    }
    if(indexPath.section == 1){
        cell.Username.text = [[data1 objectAtIndex:indexPath.row] objectForKey:@"full_name"];
        cell.Email.text = [[data1 objectAtIndex:indexPath.row] objectForKey:@"email"];
        cell.Info_UserID = [[[data1 objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.backgroundColor  = [BttendanceColor BT_white:1];
        [cell.Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_Username = [[data1 objectAtIndex:indexPath.row] objectForKey:@"full_name"];
        cell.Info_Email = [[data1 objectAtIndex:indexPath.row] objectForKey:@"email"];

    }
    return cell;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){//confirm
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        
        
        NSString *username = [[BTUserDefault getUserInfo] objectForKey:UsernameKey];
        NSString *password = [[BTUserDefault getUserInfo] objectForKey:PasswordKey];
        
        NSString *uid = [NSString stringWithFormat:@"%ld",(long)currentcell.Info_UserID];
        
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"post_id":[NSString stringWithFormat:@"%ld",(long)postId],
                                 @"user_id":uid};
        
        [AFmanager PUT:[BTURL stringByAppendingString:@"/post/attendance/check/manually"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
            NSLog(@"join course success : %@", responsObject);
            //join!!
            
            //change icon
            [currentcell.Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
            //move to section 1
            rowcount1++;
            [[self tableview] beginUpdates];
            NSIndexPath *comingcell_index = [[self tableview] indexPathForCell:currentcell];
            [[self tableview] moveRowAtIndexPath:comingcell_index toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            rowcount0--;
            [[self tableview] endUpdates];
            
        }failure:^(AFHTTPRequestOperation *opration, NSError *error){
            NSLog(@"Attendance check fail : %@", error);
            //fail
            
            //display alert
            NSString *string = @"Attendance check failed, please try again";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            //restore button event
            [currentcell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    if(buttonIndex == 0){//cancel
        //restore button event
        [currentcell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
    }

}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"item : %@", item);
    
    if(item == _Feed && viewscope
       &&[[userinfo objectForKey:@"btd_type"] isEqualToString:@"student"]){
        [self.navigationController popViewControllerAnimated:NO];
        viewscope = false;
    }
}

@end
