//
//  StdProfileEmailEditView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ProfileEmailEditViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIColor+Bttendance.h"
#import "ProfileViewController.h"
#import "BTAPIs.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "BTNotification.h"

@interface ProfileEmailEditViewController ()

@end

@implementation ProfileEmailEditViewController
@synthesize email;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(save_email)];
    self.navigationItem.rightBarButtonItem = save;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor white:1.0];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Edit Email", @"");
    [titlelabel sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_email_field becomeFirstResponder];
}

- (void)save_email {
    email = ((UITextField *) [[[self tableview] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView.subviews objectAtIndex:0]).text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Updating Email", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs updateEmail:email
                success:^(User *user) {
                    [hud hide:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSError *error) {
                    [hud hide:YES];
                }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NameEditCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    _email_field = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 290, 44)];
    _email_field.text = email;
    _email_field.textColor = [UIColor black:1];
    _email_field.tintColor = [UIColor silver:1];
    _email_field.backgroundColor = [UIColor white:1];
    _email_field.autocorrectionType = UITextAutocorrectionTypeNo;
    _email_field.keyboardType = UIKeyboardTypeEmailAddress;
    _email_field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _email_field.clearButtonMode = UITextFieldViewModeAlways;
    _email_field.returnKeyType = UIReturnKeyDone;
    _email_field.delegate = self;

    cell.contentView.backgroundColor = [UIColor white:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:_email_field];

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self save_email];
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Enter New Email address", nil);
}

@end
