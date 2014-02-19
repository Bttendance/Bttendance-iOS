//
//  ManagerViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ManagerViewController.h"

@interface ManagerViewController ()

@end

@implementation ManagerViewController
@synthesize courseId;
@synthesize courseName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchField = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = @"Add Manager";
    [titlelabel sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated{
    CustomCell *cell = (CustomCell *)[self.tableView cellForRowAtIndexPath:searchField];
    [cell.textfield becomeFirstResponder];
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
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }
    
    switch(indexPath.row){
        case 0:{
            [[cell textLabel] setText:@"User ID"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].placeholder = @"or Email Address";
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyDone;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 1:{
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if(cell_new == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:@"ADD" forState:UIControlStateNormal];
            cell_new.button.layer.cornerRadius = 3;
            [cell_new.button addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            return 78;
        default:
            return 44;
    }
}

-(IBAction)add:(id)sender{
    NSString *search = [((CustomCell *)[self.tableView cellForRowAtIndexPath:searchField]).textfield text];
    NSDictionary *userinfo = [BTUserDefault getUserInfo];
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"search_id":search};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/search/user"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        managerFullName = [responseObject objectForKey:@"full_name"];
        managerName = [responseObject objectForKey:@"username"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Manager" message:[NSString stringWithFormat:@"Would you like to add \"%@\" as a manager of course %@", managerFullName, courseName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fail to find a user \"%@\".\nPlease check User Id of Email again.", search] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==1){
        //start attendance
        NSDictionary *userinfo = [BTUserDefault getUserInfo];
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                  @"manager":managerName,
                                @"course_id":[NSString stringWithFormat:@"%ld",courseId]};
        
        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
        [AFmanager PUT:[BTURL stringByAppendingString:@"/course/add/manager"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"\"%@\" is now a manager of course %@.", managerFullName, courseName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fail to add a user %@ as a manager.\nPlease check User Id of Email again.", managerFullName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

@end
