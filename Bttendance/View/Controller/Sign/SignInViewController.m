//
//  SignInController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "SignInViewController.h"
#import "UITableViewController+Bttendance.h"
#import "TextInputCell.h"
#import "SideMenuViewController.h"
#import "SignButtonCell.h"
#import "ForgotPassViewController.h"
#import "BVUnderlineButton.h"
#import "BTUUID.h"

NSString *signinRequest;

@interface SignInViewController ()

@end

@implementation SignInViewController
@synthesize user_info;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"Log In", @"") withSubTitle:nil];
    [self setLeftMenu:LeftMenuType_Back];
    [self initTableView];
    
    emaiIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    passwordIndex = [NSIndexPath indexPathForRow:1 inSection:0];

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
    TextInputCell *cell1 = (TextInputCell *) [self.tableView cellForRowAtIndexPath:emaiIndex];
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
    ForgotPassViewController *forgotView = [[ForgotPassViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:forgotView animated:YES];
}

- (IBAction)signinButton:(id)sender {
    NSString *email = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:emaiIndex]).textfield text];
    NSString *password = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).textfield text];
    
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    BOOL pass = YES;
    
    if (email == nil || email.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:emaiIndex]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:emaiIndex]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (password == nil || password.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        button.enabled = YES;
        return;
    }
    
    [MBProgressHUD showWithMessage:NSLocalizedString(@"Loging In Bttendance", nil) toView:self.view];
    [BTAPIs signInWithEmail:email password:password success:^(User *user) {
        [MBProgressHUD hideForView:self.view];
        SideMenuViewController *sideMenu = [[SideMenuViewController alloc] initByItSelf];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:sideMenu] animated:NO];
    } failure:^(NSError *error) {
        [MBProgressHUD hideForView:self.view];
        button.enabled = YES;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:emaiIndex]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).textfield resignFirstResponder];
        [self signinButton:nil];
    }

    return NO;
}

@end
