//
//  ForgotViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <AFNetworking.h>
#import "ForgotViewController.h"
#import "CustomCell.h"
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"

NSString *forgotRequest;

@interface ForgotViewController ()

@end

@implementation ForgotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    forgotRequest = [BTURL stringByAppendingString:@"/user/forgot/password"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        email_index = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
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
    CustomCell *cell = (CustomCell *) [self.tableView cellForRowAtIndexPath:email_index];
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
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:@" Email"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = @"john@bttendance.com";
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].frame = CGRectMake(78, 1, 222, 40);
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
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

            [cell_new.button setTitle:@"Submit" forState:UIControlStateNormal];
            cell_new.button.layer.cornerRadius = 3;
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
    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield]) {
        [((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield becomeFirstResponder];
        return YES;
    }
    return NO;
}

- (IBAction)submit:(id)sender {
    NSString *email = [((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield text];
    [self JSONForgotRequest:email];
}

- (void)JSONForgotRequest:(NSString *)email {

    NSDictionary *params = @{@"email" : email};

    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager PUT:forgotRequest parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Password recovery has been succeeded.\nPlease check your email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Password recovery is unavailable.\nPlease check your email again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];

}

- (void)backbuttonpressed:(id)aResponder {
    //move to view which has index 1 in viewstack;
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}

@end
