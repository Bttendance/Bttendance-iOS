//
//  SignInController.m
//  Bttendance
//
//  Created by HAJE on 2013. 11. 19..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "SignInController.h"

NSString *signinRequest;


@interface SignInController ()

@end

@implementation SignInController
@synthesize user_info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    signinRequest = [BTURL stringByAppendingString:@"/user/signin"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        username_index = [NSIndexPath indexPathForRow:0 inSection:0];
        password_index = [NSIndexPath indexPathForRow:1 inSection:0];
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
    titlelabel.text = NSLocalizedString(@"Log in", @"");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    //set autofocus on Usernamefield
    customCell *cell1 = (customCell *)[self.tableview cellForRowAtIndexPath:username_index];
    [cell1.textfield becomeFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void) viewWillAppear:(BOOL)animated {
    [self showNavigation];
}

#pragma Tableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BttendanceColor BT_white:1];
    }
    
    switch(indexPath.row){
        case 0:{
            [[cell textLabel] setText:@"Username"];
            [[cell textLabel] setTextColor:[BttendanceColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(customCell *)cell textfield].placeholder = @"or Email";
            [(customCell *)cell textfield].delegate = self;
            [(customCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(customCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(customCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(customCell *)cell textfield].keyboardType = UIKeyboardTypeEmailAddress;

            [[(customCell *)cell textfield] setTextColor:[BttendanceColor BT_black:1]];
            [[(customCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 1:{
            [[cell textLabel] setText:@"Password"];
            [[cell textLabel] setTextColor:[BttendanceColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(customCell *)cell textfield].delegate = self;
            [(customCell *)cell textfield].secureTextEntry = YES;
            [(customCell *)cell textfield].returnKeyType = UIReturnKeyDone;
            
            [[(customCell *)cell textfield] setTextColor:[BttendanceColor BT_black:1]];
            [[(customCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 2:{
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if(cell_new == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:@"Log In" forState:UIControlStateNormal];
            cell_new.button.titleLabel.textColor = [BttendanceColor BT_navy:1];
            cell_new.button.layer.cornerRadius = 3;
            [cell_new.button addTarget:self action:@selector(signinButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
            
        }
        case 3:{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell contentView].backgroundColor = [BttendanceColor BT_white:1];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell textLabel].numberOfLines = 0;
            NSString *forgot =@"Forgot password?";
            [[cell textLabel] setText:forgot];
            [[cell textLabel] attributedText];
            [[cell textLabel] setTextColor:[UIColor grayColor]];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
            [[cell textLabel] setFont:[UIFont systemFontOfSize:12]];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(IBAction)signinButton:(id)sender{
    NSString *username = [((customCell *)[self.tableview cellForRowAtIndexPath:username_index]).textfield text];
    NSString *password = [((customCell *)[self.tableview cellForRowAtIndexPath:password_index]).textfield text];
    
    [self JSONSigninRequest:username :password];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    if([textField isEqual:usernameField]){
    //        [[self passwordField] becomeFirstResponder];
    //        return YES;
    //    }
    //
    //    if([textField isEqual:passwordField]){
    //        [[self passwordField] resignFirstResponder];
    //    }
    if([textField isEqual:((customCell *)[self.tableview cellForRowAtIndexPath:username_index]).textfield]){
        
        [((customCell *)[self.tableview cellForRowAtIndexPath:password_index]).textfield becomeFirstResponder];
        return YES;
    }
    
    if([textField isEqual:((customCell *)[self.tableview cellForRowAtIndexPath:password_index]).textfield]){
        
        [((customCell *)[self.tableview cellForRowAtIndexPath:password_index]).textfield resignFirstResponder];
    }
    
    return NO;
}

-(void)JSONSigninRequest:(NSString *)username :(NSString *)password{
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSString *uuid = [BTUserDefault representativeString:[BTUserDefault getUserService].UUID];
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":uuid};
    
    [AFmanager GET:signinRequest parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"SignIn success : %@", responseObject);

        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"btd_isSignup"];
        [BTUserDefault setUserInfo:responseObject];
        
        NSLog(@"signup data %@",[BTUserDefault getUserInfo]);
        
        MainViewController *stdMainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:stdMainView animated:YES];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"SignIn fail %@", error);
    }];
}




@end
