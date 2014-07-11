//
//  SignInController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <AFNetworking.h>
#import "SignInViewController.h"
#import "CustomCell.h"
#import "SideMenuViewController.h"
#import "SignButtonCell.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "ForgotPassViewController.h"
#import "BTColor.h"
#import "BVUnderlineButton.h"
#import "BTUUID.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString *signinRequest;


@interface SignInViewController ()

@end

@implementation SignInViewController
@synthesize user_info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        username_index = [NSIndexPath indexPathForRow:0 inSection:0];
        password_index = [NSIndexPath indexPathForRow:1 inSection:0];
        
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
    titlelabel.text = NSLocalizedString(@"Log In", @"");
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
    //set autofocus on Usernamefield
    CustomCell *cell1 = (CustomCell *) [self.tableview cellForRowAtIndexPath:username_index];
    [cell1.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showNavigation];
}

#pragma Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
            [[cell textLabel] setText:NSLocalizedString(@"User ID", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = NSLocalizedString(@"or Email", nil);
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(CustomCell *) cell textfield].keyboardType = UIKeyboardTypeEmailAddress;

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 1: {
            [[cell textLabel] setText:NSLocalizedString(@"Password", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].secureTextEntry = YES;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyDone;

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 2: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }

            [cell_new.button setTitle:NSLocalizedString(@"Log In", nil) forState:UIControlStateNormal];
            [cell_new.button addTarget:self action:@selector(signinButton:) forControlEvents:UIControlEventTouchUpInside];

            return cell_new;

        }
        case 3: {
            BVUnderlineButton *partnership = [BVUnderlineButton buttonWithType:UIButtonTypeCustom];
            partnership.backgroundColor = [UIColor clearColor];
            [partnership setTitle:NSLocalizedString(@"Forgot Password?", nil) forState:UIControlStateNormal];
            [partnership setTitleColor:[BTColor BT_silver:1.0f] forState:UIControlStateNormal];
            partnership.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
            [partnership addTarget:self action:@selector(forgot:) forControlEvents:UIControlEventTouchUpInside];
            [partnership sizeToFit];
            partnership.center = CGPointMake(cell.frame.size.width / 2, cell.frame.size.height / 2 + 10);
            [cell addSubview:partnership];
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
        case 2:
            return 78;
        case 3:
            return 60;
        default:
            return 44;
    }
}

- (void)forgot:(id)sender {
    ForgotPassViewController *forgotView = [[ForgotPassViewController alloc] initWithNibName:@"ForgotPassViewController" bundle:nil];
    [self.navigationController pushViewController:forgotView animated:YES];
}

- (IBAction)signinButton:(id)sender {
    NSString *username = [((CustomCell *) [self.tableview cellForRowAtIndexPath:username_index]).textfield text];
    NSString *password = [((CustomCell *) [self.tableview cellForRowAtIndexPath:password_index]).textfield text];
    
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Loging In Bttendance", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs signInWithUsername:username password:password success:^(User *user) {
        [hud hide:YES];
        SideMenuViewController *sideMenu = [[SideMenuViewController alloc] initWithNibName:@"SideMenuViewController" bundle:nil];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:sideMenu] animated:NO];
    } failure:^(NSError *error) {
        [hud hide:YES];
        button.enabled = YES;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:((CustomCell *) [self.tableview cellForRowAtIndexPath:username_index]).textfield]) {
        [((CustomCell *) [self.tableview cellForRowAtIndexPath:password_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((CustomCell *) [self.tableview cellForRowAtIndexPath:password_index]).textfield]) {
        [((CustomCell *) [self.tableview cellForRowAtIndexPath:password_index]).textfield resignFirstResponder];
        [self signinButton:nil];
    }

    return NO;
}

@end
