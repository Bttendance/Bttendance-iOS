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
#import "TextInputCell.h"
#import "TextCommentCell.h"
#import "SignButtonCell.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTAPIs.h"
#import "WebViewController.h"
#import "BTUserDefault.h"
#import "BTUUID.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>

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
        password_index = [NSIndexPath indexPathForRow:2 inSection:0];
        
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

    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //Navigation title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Sign Up", @"");
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
    TextInputCell *cell1 = (TextInputCell *) [self.tableView cellForRowAtIndexPath:fullname_index];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
            [[cell textLabel] setText:NSLocalizedString(@"Full Name", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];

            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"John Smith", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard

            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 1: {
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
        case 2: {
            [[cell textLabel] setText:NSLocalizedString(@"Password", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];

            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"more than 6 letters..", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].secureTextEntry = YES;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyDone;

            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 3: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
                cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            [cell_new.button setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
            
            [cell_new.button addTarget:self action:@selector(SignUnButton:) forControlEvents:UIControlEventTouchUpInside];

            return cell_new;
        }
        case 4: {
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, 20, 280, 60)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor silver:1];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
            label.delegate = self;
            
            label.text = NSLocalizedString(@"By tapping \"Sign Up\" above, you are agreeing to the Terms of Service and Privacy Policy.", nil);
            
            NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
            if ([locale isEqualToString:@"ko"]) {
                [label addLinkToURL:[NSURL URLWithString:@"http://www.bttendance.com/terms"]
                         withRange:[label.text rangeOfString:NSLocalizedString(@"Terms of Service", nil)]];
                [label addLinkToURL:[NSURL URLWithString:@"http://www.bttendance.com/privacy"]
                         withRange:[label.text rangeOfString:NSLocalizedString(@"Privacy Policy", nil)]];
            } else {
                [label addLinkToURL:[NSURL URLWithString:@"http://www.bttendance.com/terms-en"]
                         withRange:[label.text rangeOfString:NSLocalizedString(@"Terms of Service", nil)]];
                [label addLinkToURL:[NSURL URLWithString:@"http://www.bttendance.com/privacy-en"]
                         withRange:[label.text rangeOfString:NSLocalizedString(@"Privacy Policy", nil)]];
            }
            
            NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName, nil];
            NSArray *objects = [[NSArray alloc] initWithObjects:[UIColor navy:1],[NSNumber numberWithInt:kCTUnderlineStyleSingle], nil];
            NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            label.linkAttributes = linkAttributes;
            label.activeLinkAttributes = linkAttributes;
            
            [cell addSubview:label];
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
        case 0:
            return 44;
        case 1:
            return 44;
        case 2:
            return 44;
        case 3:
            return 78;
        case 4:
            return 60;
        default:
            return 44;
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    WebViewController *webView = [[WebViewController alloc] initWithURLString:[url absoluteString]];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)SignUnButton:(id)sender {
    NSString *fullname = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:fullname_index]).textfield text];
    NSString *email = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield text];
    NSString *password = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield text];

    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    BOOL pass = YES;
    
    if (fullname == nil || fullname.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:fullname_index]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:fullname_index]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (email == nil || email.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (password == nil || password.length < 6) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:password_index]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:password_index]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        button.enabled = YES;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Signing Up Bttendance", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs signUpWithFullName:fullname email:email password:password success:^(User *user) {
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
    
    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:fullname_index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield resignFirstResponder];
        [self SignUnButton:nil];
    }

    return NO;

}

@end
