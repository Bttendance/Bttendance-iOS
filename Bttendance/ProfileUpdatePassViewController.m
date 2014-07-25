//
//  ProfileUpdatePassViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 17..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ProfileUpdatePassViewController.h"
#import "BTColor.h"
#import "ProfileViewController.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import <AFNetworking/AFNetworking.h>
#import "BTNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ProfileUpdatePassViewController ()

@end

@implementation ProfileUpdatePassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(update_pass)];
    self.navigationItem.rightBarButtonItem = save;
    
    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Update Password", @"");
    [titlelabel sizeToFit];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_password_old_field becomeFirstResponder];
}

- (void)update_pass {
    //save data in textfield to temp var;
    NSString *old_pass = ((UITextField *) [[[self tableview] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView.subviews objectAtIndex:0]).text;
    
    NSString *new_pass = ((UITextField *) [[[self tableview] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].contentView.subviews objectAtIndex:0]).text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"updating password", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs updatePasswordWithOldOne:old_pass
                              newOne:new_pass
                             success:^(User *user) {
                                 [hud hide:YES];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:UserUpdated object:nil];
                                 [self.navigationController popViewControllerAnimated:YES];
                             } failure:^(NSError *error) {
                                 [hud hide:YES];
                             }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NameEditCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            _password_old_field = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 290, 44)];
            _password_old_field.textColor = [BTColor BT_black:1];
            _password_old_field.tintColor = [BTColor BT_silver:1];
            _password_old_field.backgroundColor = [BTColor BT_white:1];
            _password_old_field.autocorrectionType = UITextAutocorrectionTypeNo;
            _password_old_field.keyboardType = UIKeyboardTypeDefault;
            _password_old_field.clearButtonMode = UITextFieldViewModeAlways;
            _password_old_field.returnKeyType = UIReturnKeyDone;
            _password_old_field.secureTextEntry = YES;
            _password_old_field.delegate = self;
            
            cell.contentView.backgroundColor = [BTColor BT_white:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:_password_old_field];
            break;
        case 1:
        default:
            _password_new_field = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 290, 44)];
            _password_new_field.textColor = [BTColor BT_black:1];
            _password_new_field.tintColor = [BTColor BT_silver:1];
            _password_new_field.backgroundColor = [BTColor BT_white:1];
            _password_new_field.autocorrectionType = UITextAutocorrectionTypeNo;
            _password_new_field.keyboardType = UIKeyboardTypeDefault;
            _password_new_field.clearButtonMode = UITextFieldViewModeAlways;
            _password_new_field.returnKeyType = UIReturnKeyDone;
            _password_new_field.secureTextEntry = YES;
            _password_new_field.delegate = self;
            
            cell.contentView.backgroundColor = [BTColor BT_white:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:_password_new_field];
            break;
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_password_old_field]) {
        [_password_new_field becomeFirstResponder];
        return YES;
    }
         
    if ([textField isEqual:_password_new_field]) {
        [self update_pass];
        return NO;
    }
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Enter Current Passwrod", nil);
        case 1:
        default:
            return NSLocalizedString(@"Enter New Password", nil);
    }
}

@end
