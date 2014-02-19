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
    CustomCell *cell1 = (CustomCell *)[self.tableview cellForRowAtIndexPath:username_index];
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
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }
    
    switch(indexPath.row){
        case 0:{
            [[cell textLabel] setText:@"User ID"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].placeholder = @"or Email";
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(CustomCell *)cell textfield].keyboardType = UIKeyboardTypeEmailAddress;

            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 1:{
            [[cell textLabel] setText:@"Password"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].secureTextEntry = YES;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyDone;
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 2:{
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if(cell_new == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:@"Log In" forState:UIControlStateNormal];
            cell_new.button.layer.cornerRadius = 3;
            [cell_new.button addTarget:self action:@selector(signinButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
            
        }
        case 3:{
            BVUnderlineButton *partnership = [BVUnderlineButton buttonWithType:UIButtonTypeCustom];
            partnership.frame = CGRectMake(0.0f, 5.0f, 320.0f, 60.0f);
            partnership.backgroundColor = [UIColor clearColor];
            [partnership setTitle:@"Forgot Password?" forState:UIControlStateNormal];
            [partnership setTitleColor:[BTColor BT_silver:1.0f] forState:UIControlStateNormal];
            partnership.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
            [partnership addTarget:self action:@selector(forgot:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:partnership];
            [cell contentView].backgroundColor = [BTColor BT_grey:1];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 2:
            return 78;
        case 3:
            return 60;
        default:
            return 44;
    }
}

-(void)forgot:(id)sender{
    ForgotViewController *forgotView = [[ForgotViewController alloc] initWithNibName:@"ForgotViewController" bundle:nil];
    [self.navigationController pushViewController:forgotView animated:YES];
}

-(IBAction)signinButton:(id)sender{
    NSString *username = [((CustomCell *)[self.tableview cellForRowAtIndexPath:username_index]).textfield text];
    NSString *password = [((CustomCell *)[self.tableview cellForRowAtIndexPath:password_index]).textfield text];
    
    [self JSONSigninRequest:username :password];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:((CustomCell *)[self.tableview cellForRowAtIndexPath:username_index]).textfield]){
        
        [((CustomCell *)[self.tableview cellForRowAtIndexPath:password_index]).textfield becomeFirstResponder];
        return YES;
    }
    
    if([textField isEqual:((CustomCell *)[self.tableview cellForRowAtIndexPath:password_index]).textfield]){
        
        [((CustomCell *)[self.tableview cellForRowAtIndexPath:password_index]).textfield resignFirstResponder];
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

        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:FirstLaunchKey];
        [BTUserDefault setUserInfo:responseObject];
        
        NSLog(@"signup data %@",[BTUserDefault getUserInfo]);
        
        MainViewController *stdMainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        [self.navigationController pushViewController:stdMainView animated:YES];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:stdMainView] animated:YES];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"SignIn fail %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Sign In Failed. Please check your username and password again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
