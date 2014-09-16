//
//  ManagerViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ManagerViewController.h"
#import <AFNetworking.h>
#import "TextInputCell.h"
#import "SignButtonCell.h"
#import "BTUserDefault.h"
#import "BTAPIs.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ManagerViewController ()

@end

@implementation ManagerViewController
@synthesize courseId;
@synthesize courseName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        searchField = [NSIndexPath indexPathForRow:0 inSection:0];

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

    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Add Manager", nil);
    [titlelabel sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:searchField];
    [cell.textfield becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [cell contentView].backgroundColor = [UIColor white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:NSLocalizedString(@"Email", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(TextInputCell *) cell textfield].frame = CGRectMake(68, 1, 222, 40);
            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"john@bttendance.com", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyDone;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting

            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
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

            [cell_new.button setTitle:NSLocalizedString(@"ADD", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
            
            [cell_new.button addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];

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

- (IBAction)add:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Searching User", nil);
    hud.yOffset = -40.0f;
    
    NSString *search = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:searchField]).textfield text];
    [BTAPIs searchUser:search
               success:^(User *user) {
                   [hud hide:YES];
                   managerFullName = user.full_name;
                   managerEmail = user.email;
                   NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Would you like to add %1$@ as a manager of course %2$@", nil), user.full_name, courseName];
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add Manager", nil)
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                         otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
                   alert.tag = 200;
                   [alert show];
               } failure:^(NSError *error) {
                   [hud hide:YES];
               }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == 200) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor navy:0.7];
        hud.labelText = NSLocalizedString(@"Loading", nil);
        hud.detailsLabelText = NSLocalizedString(@"Adding Manager", nil);
        hud.yOffset = -40.0f;
        
        [BTAPIs addManagerWithCourse:courseId
                             manager:managerEmail
                             success:^(Course *course) {
                                 [hud hide:YES];
                                 NSString *message = [NSString stringWithFormat:NSLocalizedString(@"%@ is now manager of %@.", nil), managerFullName, courseName];
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Manager Added", nil)
                                                                                 message:message
                                                                                delegate:nil
                                                                       cancelButtonTitle:nil
                                                                       otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                                 [alert show];
                                 [self.navigationController popViewControllerAnimated:YES];
                             } failure:^(NSError *error) {
                                 [hud hide:YES];
                             }];
    }
}

@end
