//
//  SignUpController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <AFNetworking.h>
#import "SignUpViewController.h"
#import "SideMenuViewController.h"
#import "CustomCell.h"
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "WebViewController.h"
#import "BTUserDefault.h"
#import "BTUUID.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString *signupRequest;


@interface SignUpViewController ()
@end

@implementation SignUpViewController
@synthesize schoolId;
@synthesize serial;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    signupRequest = [BTURL stringByAppendingString:@"/user/signup"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fullname_index = [NSIndexPath indexPathForRow:0 inSection:0];
        email_index = [NSIndexPath indexPathForRow:1 inSection:0];
        username_index = [NSIndexPath indexPathForRow:2 inSection:0];
        password_index = [NSIndexPath indexPathForRow:3 inSection:0];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Sign Up", @"");
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    CustomCell *cell1 = (CustomCell *) [self.tableView cellForRowAtIndexPath:fullname_index];
    [cell1.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showNavigation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:NSLocalizedString(@"Full Name", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = NSLocalizedString(@"John Smith", nil);
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 1: {
            [[cell textLabel] setText:NSLocalizedString(@"Email", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = NSLocalizedString(@"john@bttendance.com", nil);
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(CustomCell *) cell textfield].keyboardType = UIKeyboardTypeEmailAddress;
            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 2: {
            [[cell textLabel] setText:NSLocalizedString(@"User ID", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = NSLocalizedString(@"@ID", nil);
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 3: {
            [[cell textLabel] setText:NSLocalizedString(@"Password", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = NSLocalizedString(@"Required", nil);
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].secureTextEntry = YES;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyDone;

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 4: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }

            [cell_new.button setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
            [cell_new.button addTarget:self action:@selector(SignUnButton:) forControlEvents:UIControlEventTouchUpInside];

            return cell_new;
        }
        case 5: {
            NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(20, 20, 280, 60)];
            label.backgroundColor = [UIColor clearColor];
            label.text = NSLocalizedString(@"By tapping \"Sign Up\" above, you are agreeing to the Terms of Service and Privacy Policy.", nil);
            [label addLink:[NSURL URLWithString:@"http://www.bttendance.com/terms"]
                     range:[label.text rangeOfString:NSLocalizedString(@"Terms of Service", nil)]];
            [label addLink:[NSURL URLWithString:@"http://www.bttendance.com/privacy"]
                     range:[label.text rangeOfString:NSLocalizedString(@"Privacy Policy", nil)]];
            label.textAlignment = NSTextAlignmentRight;
            label.linkColor = [BTColor BT_navy:1];
            label.linksHaveUnderlines = YES;
            label.textColor = [BTColor BT_silver:1];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
            label.numberOfLines = 0;
            label.delegate = self;
            [cell addSubview:label];
            [cell contentView].backgroundColor = [BTColor BT_grey:1];
            [(CustomCell *) cell textfield].hidden = YES;
            break;
        }
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4:
            return 78;
        case 5:
            return 60;
        default:
            return 44;
    }
}

- (void)attributedLabel:(NIAttributedLabel *)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
    WebViewController *webView = [[WebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@", result.URL]];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)SignUnButton:(id)sender {
    NSString *fullname = [((CustomCell *) [self.tableView cellForRowAtIndexPath:fullname_index]).textfield text];
    NSString *email = [((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield text];
    NSString *username = [((CustomCell *) [self.tableView cellForRowAtIndexPath:username_index]).textfield text];
    NSString *password = [((CustomCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield text];

    if (username.length < 5 || username.length > 20) {
        //alert showing
        NSString *title = NSLocalizedString(@"Username is too short", nil);
        NSString *string = NSLocalizedString(@"Username need to be longer than 5 and less than 20 letters.", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];

    } else if (password.length < 6) {
        //alert showing
        NSString *title = NSLocalizedString(@"Password is too short", nil);
        NSString *string = NSLocalizedString(@"Password need to be longer than 6 letters.", nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alert show];

    } else {
        UIButton *button = (UIButton *) sender;
        button.enabled = NO;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [BTColor BT_navy:0.7];
        hud.labelText = NSLocalizedString(@"Loading", nil);
        hud.detailsLabelText = NSLocalizedString(@"Signing Up Bttendance", nil);
        hud.yOffset = -40.0f;
        
        [BTAPIs signUpWithFullName:fullname username:username email:email password:password success:^(User *user) {
            [hud hide:YES];
            SideMenuViewController *sideMenu = [[SideMenuViewController alloc] initWithNibName:@"SideMenuViewController" bundle:nil];
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController setViewControllers:[NSArray arrayWithObject:sideMenu] animated:NO];
        } failure:^(NSError *error) {
            [hud hide:YES];
            button.enabled = YES;
        }];
    }

}


- (NSDictionary *)loadAccountinfor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = @{@"username" : [defaults objectForKey:UsernameKey],
            @"password" : [defaults objectForKey:PasswordKey]};
    return userinfo;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:fullname_index]).textfield]) {
        [((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield]) {
        [((CustomCell *) [self.tableView cellForRowAtIndexPath:username_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:username_index]).textfield]) {
        [((CustomCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield]) {
        [((CustomCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield resignFirstResponder];
        [self SignUnButton:nil];
    }

    return NO;

}

@end
