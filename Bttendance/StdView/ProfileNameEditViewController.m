//
//  StdProfileNameEditView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 22..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ProfileNameEditViewController.h"

@interface ProfileNameEditViewController ()

@end

@implementation ProfileNameEditViewController

@synthesize fullname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userinfo = [BTUserDefault getUserInfo];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save_fullname)];
    self.navigationItem.rightBarButtonItem = save;
    
    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Edit Name", @"");
    [titlelabel sizeToFit];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_name_field becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save_fullname{
    //save data in textfield to temp var;
    NSString *temp = ((UITextField *)[[[self tableview] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView.subviews objectAtIndex:0]).text;
    
    fullname = temp;
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *device_uuid = [userinfo objectForKey:UUIDKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":device_uuid,
                             @"full_name":fullname};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    [AFmanager PUT:[BTURL stringByAppendingString:@"/user/update/full_name"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [[NSUserDefaults standardUserDefaults] setObject:fullname forKey:FullNameKey];
        //load previous view
        ((ProfileViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -2]).fullname = [NSString stringWithString:temp];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"NameEditCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    _name_field = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 290, 44)];
//    name_field.text = fullname;
    ProfileViewController *parentView = (ProfileViewController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -2];
    _name_field.text = parentView.fullname;
    _name_field.textColor = [BTColor BT_black:1];
    _name_field.backgroundColor = [BTColor BT_white:1];
    _name_field.autocorrectionType = UITextAutocorrectionTypeNo;
    _name_field.keyboardType = UIKeyboardTypeDefault;
    _name_field.clearButtonMode = UITextFieldViewModeAlways;
    _name_field.returnKeyType = UIReturnKeyDone;
    _name_field.delegate = self;
    
    cell.contentView.backgroundColor = [BTColor BT_white:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:_name_field];
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self save_fullname];
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Enter New name";
}

@end
