//
//  SignInController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <AFNetworking.h>
#import "SignInViewController.h"
#import "TextInputCell.h"
#import "SideMenuViewController.h"
#import "SignButtonCell.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "ForgotPassViewController.h"
#import "UIColor+Bttendance.h"
#import "BVUnderlineButton.h"
#import "BTUUID.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>
#import "UIImage+Bttendance.h"

NSString *signinRequest;


@interface SignInViewController ()

@end

@implementation SignInViewController
@synthesize user_info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        email_index = [NSIndexPath indexPathForRow:0 inSection:0];
        password_index = [NSIndexPath indexPathForRow:1 inSection:0];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
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
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Log In", @"");
    [titlelabel sizeToFit];
    
    self.navigationController.navigationBar.translucent = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //set autofocus on Usernamefield
    TextInputCell *cell1 = (TextInputCell *) [self.tableview cellForRowAtIndexPath:email_index];
    [cell1.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
        cell = [[TextInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:NSLocalizedString(@"Email", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];

            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"john@bttendance.com", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(TextInputCell *) cell textfield].keyboardType = UIKeyboardTypeEmailAddress;

            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 1: {
            [[cell textLabel] setText:NSLocalizedString(@"Password", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];

            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].secureTextEntry = YES;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyDone;

            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 2: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
                cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            [cell_new.button setTitle:NSLocalizedString(@"Log In", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
            [cell_new.button addTarget:self action:@selector(signinButton:) forControlEvents:UIControlEventTouchUpInside];

            return cell_new;

        }
        case 3: {
            BVUnderlineButton *partnership = [BVUnderlineButton buttonWithType:UIButtonTypeCustom];
            partnership.backgroundColor = [UIColor clearColor];
            [partnership setTitle:NSLocalizedString(@"Forgot Password?", nil) forState:UIControlStateNormal];
            [partnership setTitleColor:[UIColor silver:1.0f] forState:UIControlStateNormal];
            partnership.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
            [partnership addTarget:self action:@selector(forgot:) forControlEvents:UIControlEventTouchUpInside];
            [partnership sizeToFit];
            partnership.center = CGPointMake(cell.frame.size.width / 2, cell.frame.size.height / 2 + 10);
            [cell addSubview:partnership];
            [cell contentView].backgroundColor = [UIColor grey:1];
            [(TextInputCell *) cell textfield].hidden = YES;
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
    NSString *email = [((TextInputCell *) [self.tableview cellForRowAtIndexPath:email_index]).textfield text];
    NSString *password = [((TextInputCell *) [self.tableview cellForRowAtIndexPath:password_index]).textfield text];
    
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    BOOL pass = YES;
    
    if (email == nil || email.length == 0) {
        ((TextInputCell *) [self.tableview cellForRowAtIndexPath:email_index]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableview cellForRowAtIndexPath:email_index]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (password == nil || password.length == 0) {
        ((TextInputCell *) [self.tableview cellForRowAtIndexPath:password_index]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableview cellForRowAtIndexPath:password_index]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        button.enabled = YES;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Loging In Bttendance", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs signInWithEmail:email password:password success:^(User *user) {
        [hud hide:YES];
        SideMenuViewController *sideMenu = [[SideMenuViewController alloc] initByItSelf];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:sideMenu] animated:NO];
    } failure:^(NSError *error) {
        [hud hide:YES];
        button.enabled = YES;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:((TextInputCell *) [self.tableview cellForRowAtIndexPath:email_index]).textfield]) {
        [((TextInputCell *) [self.tableview cellForRowAtIndexPath:password_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableview cellForRowAtIndexPath:password_index]).textfield]) {
        [((TextInputCell *) [self.tableview cellForRowAtIndexPath:password_index]).textfield resignFirstResponder];
        [self signinButton:nil];
    }

    return NO;
}

@end
