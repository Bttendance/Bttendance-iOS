//
//  CourseView.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "AttdStatViewController.h"

@interface AttdStatViewController ()

@end

@implementation AttdStatViewController
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
        self.navigationItem.hidesBackButton = NO;
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
    titlelabel.text = courseName;
    [titlelabel sizeToFit];
}

-(void)viewWillAppear:(BOOL)animated{
    [self refreshStat];
}

-(void)refreshStat {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    NSString *username = [[BTUserDefault getUserInfo] objectForKey:UsernameKey];
    NSString *password = [[BTUserDefault getUserInfo] objectForKey:PasswordKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":[NSString stringWithFormat:@"%ld", (long)courseId]};
    
    NSLog(@"params info : %@",params);
    [AFmanager GET:[BTURL stringByAppendingString:@"/course/students"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *studentlist = responseObject;
        NSString *postAPI = [NSString stringWithFormat:[BTURL stringByAppendingString:@"/post/%ld"],(long)postId];
        [AFmanager GET:postAPI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject_){
            NSDictionary *checks = [responseObject_ objectForKey:@"checks"];
            
            [data0 removeAllObjects];
            [data1 removeAllObjects];
            
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
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Get Post Fail : %@", error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Get Course Student List fail %@", error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
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
    
    //disable button
    [comingbutton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return rowcount0;
        case 1:
        default:
            return rowcount1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Attendance un-checked students";
        case 1:
        default:
            return @"Attendance checked students";
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
        cell.backgroundColor  = [BTColor BT_white:1];
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
        cell.backgroundColor  = [BTColor BT_white:1];
        [cell.Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_Username = [[data1 objectAtIndex:indexPath.row] objectForKey:@"full_name"];
        cell.Info_Email = [[data1 objectAtIndex:indexPath.row] objectForKey:@"email"];

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
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

            [[self tableview] beginUpdates];
            [currentcell.Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
            rowcount1++;
            rowcount0--;
            NSIndexPath *comingcell_index = [[self tableview] indexPathForCell:currentcell];
            for (int i = 0; i < [data0 count]; i++) {
                if ([[[data0 objectAtIndex:i] objectForKey:@"id"] intValue] == currentcell.Info_UserID) {
                    [data1 addObject:[data0 objectAtIndex:i]];
                    [data0 removeObjectAtIndex:i];
                }
            }
            [[self tableview] moveRowAtIndexPath:comingcell_index toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            [[self tableview] endUpdates];
            
        }failure:^(AFHTTPRequestOperation *opration, NSError *error){
            NSString *string = @"Attendance check failed, please try again";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [currentcell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    if(buttonIndex == 0){
        [currentcell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
