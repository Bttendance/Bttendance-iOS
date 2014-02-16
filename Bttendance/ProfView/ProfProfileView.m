//
//  ProfProfileView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ProfProfileView.h"

@interface ProfProfileView ()

@end

@implementation ProfProfileView

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
        rowcount = 4;
        userinfo = [BTUserDefault getUserInfo];

        fullname = [userinfo objectForKey:FullNameKey];
        email = [userinfo objectForKey:EmailKey];
        

        
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
    
    [AFmanager GET:@"http://www.bttendance.com/api/user/schools" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        data = responseObject;
        rowcount = 4 + data.count;
        [self.tableview reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
    
    ProfProfileHeaderView *profileheaderview = [[ProfProfileHeaderView alloc] init];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfProfileHeaderView" owner:self options:nil];
    profileheaderview = [topLevelObjects objectAtIndex:0];
    
    profileheaderview.edit_button.titleLabel.textColor = [BTColor BT_white:0.7];
    profileheaderview.edit_button.backgroundColor = [BTColor BT_black:0.5];
    profileheaderview.Profile_image.backgroundColor = [BTColor BT_navy:1];
    
    profileheaderview.accountType.text = @"Professor";
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
    
    [AFmanager GET:@"http://www.bttendance.com/api/user/schools" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        data = responseObject;
        rowcount = 4 + data.count;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rowcount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ProfileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
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
            if(indexPath.row == rowcount -1){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
                
                [((ButtonCell *)cell).button addTarget:self action:@selector(move_to_addppv) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else{
                //school list
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SchoolInfoCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
                
                ((SchoolInfoCell *)cell).Info_SchoolName.text = [[data objectAtIndex:indexPath.row - 3] objectForKey:@"name"];
                ((SchoolInfoCell *)cell).Info_SchoolName.textColor = [UIColor grayColor];
                
                ((SchoolInfoCell *)cell).Info_SchoolID_int = [[[data objectAtIndex:indexPath.row -3] objectForKey:@"id"] intValue];
                
                ((SchoolInfoCell *)cell).Info_SchoolID.text = [NSString stringWithFormat:@"%ld",(long)((SchoolInfoCell *)cell).Info_SchoolID_int];
                ((SchoolInfoCell *)cell).Info_SchoolID.textColor = [UIColor grayColor];
                
                [((SchoolInfoCell *)cell).Info_Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
            }
            break;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == rowcount-1){
        return 71.0f;
    }
    else{
        return 44.0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //for edit name
        ProfProfileNameEditView *profProfileNameEditView = [[ProfProfileNameEditView alloc] init];
        
        profProfileNameEditView.fullname = fullname;
        
        [self.navigationController pushViewController:profProfileNameEditView animated:YES];
    }
    if(indexPath.row == 1){
        //for edit email
        ProfProfileEmailEditView *profProfileEmailEditView = [[ProfProfileEmailEditView alloc] init];
        
        profProfileEmailEditView.email = email;
        
        [self.navigationController pushViewController:profProfileEmailEditView animated:YES];
    }
}

-(void)move_to_addppv{
    SchoolChooseView *schoolView = [[SchoolChooseView alloc] init];
    [self.navigationController pushViewController:schoolView animated:YES];
}

@end
