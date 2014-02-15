//
//  StdProfileView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize fullname, email;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        rowcount = 3;
        userinfo = [BTUserDefault getUserInfo];

        fullname = [userinfo objectForKey:FullNameKey];
        email = [userinfo objectForKey:EmailKey];
        employedschoollist = [[NSUserDefaults standardUserDefaults] objectForKey:EmployedSchoolsKey];
        enrolledschoollist = [[NSUserDefaults standardUserDefaults] objectForKey:EnrolledSchoolsKey];
        rowcount1 = employedschoollist.count;
        rowcount2 = enrolledschoollist.count;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _navigationbar.barTintColor = [UIColor colorWithRed:0.0 green:0.287 blue:0.59 alpha:1];
    
    _navigationbar.tintColor = [UIColor whiteColor];
    
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/schools"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        alluserschools = responseObject;
        [self.tableview reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
    
    ProfileHeaderView *profileheaderview = [[ProfileHeaderView alloc] init];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:self options:nil];
    profileheaderview = [topLevelObjects objectAtIndex:0];
    
    profileheaderview.edit_button.titleLabel.textColor = [BttendanceColor BT_white:0.7];
    profileheaderview.edit_button.backgroundColor = [BttendanceColor BT_black:0.5];
    profileheaderview.Profile_image.backgroundColor = [BttendanceColor BT_navy:1];
    
    profileheaderview.accountType.text = @"Student";
    profileheaderview.userName.text = username;
    
    self.tableview.tableHeaderView = profileheaderview;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/schools"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        alluserschools = responseObject;
//        rowcount = 3 + data.count;
        [self.tableview reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return @"Employed schools";
    }
    else if(section ==2){
        return @"Enrolled schools";
    }
    else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section ==0){
        return 0.0f;
    }
    else{
        return 30.0f;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return rowcount;
    else if (section == 1)
        return rowcount1;
    else
        return rowcount2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
                
                ((ProfileCell *)cell).title.text = @"Name";
                ((ProfileCell *)cell).data.text = fullname;
                break;
            }
            case 1:{
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
                
                ((ProfileCell *)cell).title.text = @"Email";
                ((ProfileCell *)cell).data.text = email;
                break;
            }
            case 2:{
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
                
                ((ProfileCell *)cell).title.text = @"School";
                ((ProfileCell *)cell).data.text = @"";
                ((ProfileCell *)cell).accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            default:{
                break;
            }
        }
    }
    else if(indexPath.section == 1){
        NSArray *topLevelObejcts = [[NSBundle mainBundle] loadNibNamed:@"SchoolInfoCell" owner:self options:nil];
        cell = [topLevelObejcts objectAtIndex:0];
        
        for(int i = 0; i< alluserschools.count ; i++){
            if([[[alluserschools objectAtIndex:i] objectForKey:@"id"] intValue] == [[[employedschoollist objectAtIndex:indexPath.row] objectAtIndex:0] intValue]){
                ((SchoolInfoCell *)cell).Info_SchoolName.text = [[alluserschools objectAtIndex:i] objectForKey:@"name"];
                ((SchoolInfoCell *)cell).Info_SchoolID.text = [[alluserschools objectAtIndex:i] objectForKey:@"website"];
                break;
            }
        }
        ((SchoolInfoCell *)cell).Info_SchoolID_int = [[[employedschoollist objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        ((SchoolInfoCell *)cell).Info_SchoolID.textColor = [UIColor grayColor];
        
    }
    else{
        NSArray *topLevelObejcts = [[NSBundle mainBundle] loadNibNamed:@"SchoolInfoCell" owner:self options:nil];
        cell = [topLevelObejcts objectAtIndex:0];
        for(int i = 0; i< alluserschools.count ; i++){
            if([[[alluserschools objectAtIndex:i] objectForKey:@"id"] intValue] == [[[enrolledschoollist objectAtIndex:indexPath.row] objectAtIndex:0] intValue]){
                ((SchoolInfoCell *)cell).Info_SchoolName.text = [[alluserschools objectAtIndex:i] objectForKey:@"name"];
                ((SchoolInfoCell *)cell).Info_SchoolID.text = [[alluserschools objectAtIndex:i] objectForKey:@"website"];
                break;
            }
        }
        ((SchoolInfoCell *)cell).Info_SchoolID_int = [[[enrolledschoollist objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        ((SchoolInfoCell *)cell).Info_SchoolID.textColor = [UIColor grayColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //for edit name
        ProfileNameEditViewController *stdProfileNameEditView = [[ProfileNameEditViewController alloc] init];
        
        stdProfileNameEditView.fullname = fullname;
        
        [self.navigationController pushViewController:stdProfileNameEditView animated:YES];
    }
    if(indexPath.row == 1){
        //for edit email
        ProfileEmailEditViewController *stdProfileEmailEditView = [[ProfileEmailEditViewController alloc] init];
        
        stdProfileEmailEditView.email = email;
        
        [self.navigationController pushViewController:stdProfileEmailEditView animated:YES];
    }
}

-(void)move_to_add{
    SchoolChooseView *schoolView = [[SchoolChooseView alloc] init];
    [self.navigationController pushViewController:schoolView animated:YES];
}

@end
