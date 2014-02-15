//
//  Serial_Input.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 1..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "SerialViewController.h"

@interface SerialViewController ()
@end

@implementation SerialViewController
@synthesize type;
@synthesize isSignUp;
@synthesize schoolId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        serialcode = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //settitle
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Serial Code", @"");
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

- (void)viewDidAppear:(BOOL)animated{
    customCell *cell1 = (customCell *)[self.tableView cellForRowAtIndexPath:serialcode];
    [cell1.textfield becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [self showNavigation];
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
    if (isSignUp)
        return 4;
    else if (schoolId == 1)
        return 3;
    else
        return 2;
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
            [[cell textLabel] setText:@"  Serial"];
            [[cell textLabel] setTextColor:[BttendanceColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(customCell *)cell textfield].placeholder = @"Enter Serial Code";
            [(customCell *)cell textfield].delegate = self;
            [(customCell *)cell textfield].returnKeyType = UIReturnKeyDone;
            [(customCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(customCell *)cell textfield].secureTextEntry = YES;
            
            [[(customCell *)cell textfield] setTextColor:[BttendanceColor BT_black:1]];
            [[(customCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 1:{
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if(cell_new == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:@"Enter" forState:UIControlStateNormal];
            cell_new.button.titleLabel.textColor = [BttendanceColor BT_navy:1];
            cell_new.button.layer.cornerRadius = 3;
            [cell_new.button addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        case 2: {
            BVUnderlineButton *request = [BVUnderlineButton buttonWithType:UIButtonTypeCustom];
            request.frame = CGRectMake(0.0f, 5.0f, 320.0f, 20.0f);
            request.backgroundColor = [UIColor clearColor];
            [request setTitle:@"Request Serial" forState:UIControlStateNormal];
            [request setTitleColor:[BttendanceColor BT_silver:1.0f] forState:UIControlStateNormal];
            request.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [cell addSubview:request];
            break;
        }
        case 3: {
            BVUnderlineButton *partnership = [BVUnderlineButton buttonWithType:UIButtonTypeCustom];
            partnership.frame = CGRectMake(0.0f, 5.0f, 320.0f, 20.0f);
            partnership.backgroundColor = [UIColor clearColor];
            [partnership setTitle:@"Join Partnership" forState:UIControlStateNormal];
            [partnership setTitleColor:[BttendanceColor BT_silver:1.0f] forState:UIControlStateNormal];
            partnership.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [cell addSubview:partnership];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(IBAction)enter:(id)sender{
    
    enterBt.enabled = NO;
    NSString *serial = [((customCell *)[self.tableView cellForRowAtIndexPath:serialcode]).textfield text];
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    if (isSignUp) {
        NSDictionary *params = @{@"serial":serial};
        [AFmanager GET:[BTURL stringByAppendingString:@"/serial/validate"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"Getting success : %@",responseObject);
            NSLog(@"validate : %@",[responseObject objectForKey:@"validate"]);
            SignUpController *signUpController = [[SignUpController alloc] initWithNibName:@"SignUpController" bundle:nil];
            [self.navigationController pushViewController:signUpController animated:YES];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            enterBt.enabled = YES;
            UIAlertView *wrongserial = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Serial code is not valiable.\nPlease check again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [wrongserial show];
        }];
    } else {
        NSDictionary *userinfo = [BTUserDefault getUserInfo];
        NSString *username = [userinfo objectForKey:UsernameKey];
        NSString *password = [userinfo objectForKey:PasswordKey];
        
        NSDictionary *params = @{@"username":username,
                                 @"password":password,
                                 @"school_id":[NSString stringWithFormat:@"%ld",(long)schoolId],
                                 @"serial":serial};
        [AFmanager PUT:[BTURL stringByAppendingString:@"/user/employ/school"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"Getting success : %@",responseObject);
            [BTUserDefault setUserInfo:responseObject];
            CourseCreateController *createCourseController = [[CourseCreateController alloc] initWithNibName:@"CourseCreateController" bundle:nil];
            createCourseController.schoolId = schoolId;
            [self.navigationController pushViewController:createCourseController animated:YES];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            enterBt.enabled = YES;
            UIAlertView *wrongserial = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Serial code is not valiable.\nPlease check again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [wrongserial show];
        }];
    }
}



@end
