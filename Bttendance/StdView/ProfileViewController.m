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

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        userinfo = [BTUserDefault getUserInfo];
        fullname = [userinfo objectForKey:FullNameKey];
        email = [userinfo objectForKey:EmailKey];
        employedschoollist = [[NSUserDefaults standardUserDefaults] objectForKey:EmployedSchoolsKey];
        enrolledschoollist = [[NSUserDefaults standardUserDefaults] objectForKey:EnrolledSchoolsKey];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    profileheaderview.accountType.text = @"Student";
    profileheaderview.userName.text = username;
    
    self.tableview.tableHeaderView = profileheaderview;
    rowcount = 0;
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
        rowcount = [employedschoollist count] + [enrolledschoollist count];
        [self.tableview reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
        case 1:
        default:
            return rowcount;
    }
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
        
        for(int i = 0; i < [alluserschools count]; i++) {
            int school_id = [[[alluserschools objectAtIndex:i] objectForKey:@"id"] intValue];
            if (indexPath.row < [employedschoollist count]
                && [[employedschoollist[indexPath.row] objectForKey:@"id"] integerValue] == school_id) {
                ((SchoolInfoCell *)cell).Info_SchoolName.text = [[alluserschools objectAtIndex:i] objectForKey:@"name"];
                ((SchoolInfoCell *)cell).Info_SchoolID.text = @"Professor";
                break;
            }
            if (indexPath.row >= [employedschoollist count]
                && [[enrolledschoollist[indexPath.row - [employedschoollist count]] objectForKey:@"id"] integerValue] == school_id) {
                ((SchoolInfoCell *)cell).Info_SchoolName.text = [[alluserschools objectAtIndex:i] objectForKey:@"name"];
                ((SchoolInfoCell *)cell).Info_SchoolID.text = [enrolledschoollist[indexPath.row - [employedschoollist count]] objectForKey:@"key"];
                break;
            }
        }
        ((SchoolInfoCell *)cell).Info_SchoolID_int = [[[employedschoollist objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 44;
        default:
            return 53;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1)
        return;
    
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

@end
