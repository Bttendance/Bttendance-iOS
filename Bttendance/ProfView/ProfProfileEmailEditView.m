//
//  ProfProfileEmailEditView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 22..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ProfProfileEmailEditView.h"

@interface ProfProfileEmailEditView ()

@end

@implementation ProfProfileEmailEditView
@synthesize email;
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
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save_emailppeev)];
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
    titlelabel.text = NSLocalizedString(@"Edit Email", @"");
    [titlelabel sizeToFit];

    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save_emailppeev{
    
    NSString *temp = ((UITextField *)[[[self tableview] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView.subviews objectAtIndex:0]).text;
    
    email = temp;
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *device_uuid = [userinfo objectForKey:UUIDKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":device_uuid,
                             @"email":email};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    [AFmanager PUT:@"http://www.bttendance.com/api/user/update/email" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:EmailKey];
        //load previous view
        ((ProfProfileView *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -2]).email = temp;
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
    
    UITextField *email_field = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    email_field.text = email;
    email_field.textColor = [BttendanceColor BT_black:1];
    [cell.contentView addSubview:email_field];
    email_field.autocorrectionType = UITextAutocorrectionTypeNo;
    email_field.keyboardType = UIKeyboardTypeEmailAddress;
    email_field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    email_field.clearButtonMode = UITextFieldViewModeAlways;
    email_field.returnKeyType = UIReturnKeyDone;
    email_field.delegate = self;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self save_emailppeev];
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Enter New Email address";
}

@end
