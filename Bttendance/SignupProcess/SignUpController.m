//
//  SignUpController.m
//  Bttendance
//
//  Created by HAJE on 2013. 11. 19..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "SignUpController.h"

NSString *signupRequest;


@interface SignUpController ()
@end

@implementation SignUpController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    signupRequest = [BTURL stringByAppendingString:@"/user/signup"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fullname_index = [NSIndexPath indexPathForRow:0 inSection:0];
        email_index= [NSIndexPath indexPathForRow:1 inSection:0];
        username_index = [NSIndexPath indexPathForRow:2 inSection:0];
        password_index = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    
    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Sign up", @"");
    [titlelabel sizeToFit];
    
    [self showNavigation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self showNavigation];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self showNavigation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showNavigation {
    //Navigation showing
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ){
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"set autofocus");
    CustomCell *cell1 = (CustomCell *)[self.tableView cellForRowAtIndexPath:fullname_index];
    [cell1.textfield becomeFirstResponder];

}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [self showNavigation];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
            [[cell textLabel] setText:@"Fullname"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].placeholder = @"John Smith";
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 1:{
            [[cell textLabel] setText:@"Email"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].placeholder = @"example@example.com";
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(CustomCell *)cell textfield].keyboardType = UIKeyboardTypeEmailAddress;
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 2:{
            [[cell textLabel] setText:@"Username"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].placeholder = @"@ID";
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 3:{
            [[cell textLabel] setText:@"Password"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].placeholder = @"Required";
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].secureTextEntry = YES;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyDone;
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 4:{
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if(cell_new == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:@"Sign Up" forState:UIControlStateNormal];
            cell_new.button.titleLabel.textColor = [BTColor BT_navy:1];
            cell_new.button.layer.cornerRadius = 3;
            [cell_new.button addTarget:self action:@selector(SignUnButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        case 5:{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell contentView].backgroundColor = [BTColor BT_white:1];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell textLabel].numberOfLines = 0;
            [[cell textLabel] setText:@"By tapping \"Sign up\" above, you are\nagreeing to the terms and conditions."];
            [[cell textLabel] setTextColor:[UIColor grayColor]];
            [[cell textLabel]setTextAlignment:NSTextAlignmentCenter];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:10]];
            break;
        }
        default:
            break;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4:
            return 78;
        case 5:
            return 60;
        default:
            return 44;
    }
}

-(IBAction)SignUnButton:(id)sender{
    NSString *fullname = [((CustomCell *)[self.tableView cellForRowAtIndexPath:fullname_index]).textfield text];
    NSString *email = [((CustomCell *)[self.tableView cellForRowAtIndexPath:email_index]).textfield text];
    NSString *username = [((CustomCell *)[self.tableView cellForRowAtIndexPath:username_index]).textfield text];
    NSString *password = [((CustomCell *)[self.tableView cellForRowAtIndexPath:password_index]).textfield text];
    
    if(username.length < 5 || username.length > 20){
        //alert showing
        NSString *string = @"Username must be between 5 to 20 letters in length";
        NSString *title = @"Invalidate Username";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    else if(password.length < 6){
        //alert showing
        NSString *string = @"Password must be longer than 6 letters";
        NSString *title = @"Invalidate Password";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    
    else{
        [self JSONSignupRequest:username :email :fullname :password];
        NSLog(@"fullname : %@",fullname);
        NSLog(@"email : %@",email);
        NSLog(@"usename : %@",username);
        NSLog(@"password : %@",password);

    }
    
}


-(NSDictionary *) loadAccountinfor{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = @{@"username":[defaults objectForKey:UsernameKey],
                               @"password":[defaults objectForKey:PasswordKey]};
    return userinfo;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"return call!");
    
    if([textField isEqual:((CustomCell *)[self.tableView cellForRowAtIndexPath:fullname_index]).textfield]){
        
        [((CustomCell *)[self.tableView cellForRowAtIndexPath:email_index]).textfield becomeFirstResponder];
        return YES;
    }
    
    if([textField isEqual:((CustomCell *)[self.tableView cellForRowAtIndexPath:email_index]).textfield]){
        
        [((CustomCell *)[self.tableView cellForRowAtIndexPath:username_index]).textfield becomeFirstResponder];
        return YES;
    }
    
    if([textField isEqual:((CustomCell *)[self.tableView cellForRowAtIndexPath:username_index]).textfield]){
        
        [((CustomCell *)[self.tableView cellForRowAtIndexPath:password_index]).textfield becomeFirstResponder];
        return YES;
    }
    
    if([textField isEqual:((CustomCell *)[self.tableView cellForRowAtIndexPath:password_index]).textfield]){

        [((CustomCell *)[self.tableView cellForRowAtIndexPath:password_index]).textfield resignFirstResponder];
    }
    
    return NO;

}

-(void)JSONSignupRequest:(NSString *)username :(NSString *)email :(NSString *)fullname :(NSString *)password {

    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSString *uuid = [BTUserDefault representativeString:[BTUserDefault getUserService].UUID];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *token;
    token = app.device_token;
    NSLog(@"token %@", token);
    NSDictionary *params = @{@"username":username,
                             @"email":email,
                             @"full_name":fullname,
                             @"password":password,
                             @"device_type":@"iphone",
                             @"device_uuid":uuid,
                             @"notification_key": token};
    
    [AFmanager POST:signupRequest parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"SignUp success : %@", responseObject);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:TRUE forKey:@"btd_isSignup"];
        [BTUserDefault setUserInfo:responseObject];
        
        MainViewController *stdMainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:stdMainView animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"SignUp fail %@", error);
        
        NSLog(@"Status Code : %ld",(long)[operation.response statusCode]);
        
        NSLog(@"error object : %@", [operation responseObject]);
        
        NSString *rawstring = [[[operation responseObject] objectForKey:@"message"] objectAtIndex:0];
        
        NSLog(@"error json : %@", rawstring);
        
        NSRange user_email = [rawstring rangeOfString:@"\"user_email_key\"" options:NSCaseInsensitiveSearch];
        NSRange user_name = [rawstring rangeOfString:@"\"user_username_key\"" options:NSCaseInsensitiveSearch];
        NSRange user_uuid = [rawstring rangeOfString:@"\"user_device_uuid_key\"" options:NSCaseInsensitiveSearch];
        
//        NSString *user
        if(user_email.location != NSNotFound){ //email duplicate
            //alert showing
            NSString *string = @"Email currently in use.\nPlease try a different address.";
            NSString *title = @"Duplication Error";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
        if (user_name.location != NSNotFound){ //username duplicate
            //alert showing
            NSString *string = @"Username currently in use.\nPlease try a different Username";
            NSString *title = @"Duplication Error";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        if(user_uuid.location != NSNotFound){ //uuid duplicate!!! critical!
            //alert showing
            NSString *string = @"Your device currently in use.\n Any further progress in signing up may result in disadvantage on your end.";
            NSString *title = @"Critical Error in Validation";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }

    }];

}

@end
