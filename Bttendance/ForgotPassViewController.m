//
//  ForgotViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <AFNetworking.h>
#import "ForgotPassViewController.h"
#import "TextInputCell.h"
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ForgotPassViewController ()

@end

@implementation ForgotPassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        email_index = [NSIndexPath indexPathForRow:0 inSection:0];
        
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
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Forgot Password", @"");
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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //set autofocus on Usernamefield
    TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index];
    [cell.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showNavigation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[TextInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:NSLocalizedString(@"Email", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"john@bttendance.com", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].frame = CGRectMake(78, 1, 222, 40);
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard

            [[(TextInputCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 1: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }

            [cell_new.button setTitle:NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:1.0] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:0.7] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:0.3] forState:UIControlStateDisabled];
            [cell_new.button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
            cell.contentView.backgroundColor = [BTColor BT_grey:1];

            return cell_new;
        }
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            return 78;
        default:
            return 44;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield becomeFirstResponder];
        return YES;
    }
    return NO;
}

- (IBAction)submit:(id)sender {
    NSString *email = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield text];
    [self JSONForgotRequest:email];
}

- (void)JSONForgotRequest:(NSString *)email {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Recoverying Password", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs forgotPasswordWithEmail:email
                            success:^(Email *email) {
                                [hud hide:YES];
                                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Password recovery has been succeeded.\nPlease check your email.\n\"%@\"", nil), email.email];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Password Recovery Success", nil)
                                                                                message:message
                                                                               delegate:self
                                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                      otherButtonTitles:nil];
                                [alert show];
                            } failure:^(NSError *error) {
                                [hud hide:YES];
                            }];
}

@end
