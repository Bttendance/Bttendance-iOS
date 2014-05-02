//
//  ManagerViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ManagerViewController.h"
#import <AFNetworking.h>
#import "CustomCell.h"
#import "SignButtonCell.h"
#import "BTUserDefault.h"
#import "BTAPIs.h"
#import "BTColor.h"

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
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = @"Add Manager";
    [titlelabel sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated {
    CustomCell *cell = (CustomCell *) [self.tableView cellForRowAtIndexPath:searchField];
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
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:@"User ID"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = @"or Email Address";
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyDone;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
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

            [cell_new.button setTitle:@"ADD" forState:UIControlStateNormal];
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
    NSString *search = [((CustomCell *) [self.tableView cellForRowAtIndexPath:searchField]).textfield text];
    [BTAPIs searchUser:search
               success:^(User *user) {
                   NSString *message = [NSString stringWithFormat:@"Would you like to add \"%@\" as a manager of course %@", user.full_name, courseName];
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Manager"
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:@"Confirm", nil];
                   [alert show];
               } failure:^(NSError *error) {
                   NSString *message = [NSString stringWithFormat:@"Fail to find a user \"%@\".\nPlease check User Id of Email again.", search];
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:message
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                   [alert show];
               }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [BTAPIs addManagerWithCourse:courseId
                             manager:managerName
                             success:^(Course *course) {
                                 NSString *message = [NSString stringWithFormat:@"\"%@\" is now a manager of course %@.", managerFullName, courseName];
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                 message:message
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil, nil];
                                 [alert show];
                             } failure:^(NSError *error) {
                                 NSString *message = [NSString stringWithFormat:@"Fail to add a user %@ as a manager.\nPlease check User Id of Email again.", managerFullName];
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                 message:message
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil, nil];
                                 [alert show];
                             }];
    }
}

@end
