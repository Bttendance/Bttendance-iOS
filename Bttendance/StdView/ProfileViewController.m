//
//  StdProfileView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "ProfileNameEditViewController.h"
#import "ProfileEmailEditViewController.h"
#import "ProfileCell.h"
#import "SchoolChooseViewController.h"
#import "BTAPIs.h"
#import "BTColor.h"
#import "Identification.h"
#import "BTNotification.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize fullname, email;

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];

    if (self) {
        user = [BTUserDefault getUser];
        fullname = user.full_name;
        email = user.email;
        
        UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [settingButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setBackgroundImage:[UIImage imageNamed:@"setting@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *plusButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
        [self.navigationItem setRightBarButtonItem:plusButtonItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
    }

    return self;
}

- (void)setting:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Edit Name", @"Edit Email", nil];
    [actionSheet showFromTabBar:[[self tabBarController] tabBar]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    
    ProfileHeaderView *profileheaderview = [[ProfileHeaderView alloc] init];

    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:self options:nil];
    profileheaderview = [topLevelObjects objectAtIndex:0];

    if ([user.employed_schools count] > 0 && [user.enrolled_schools count] > 0)
        profileheaderview.accountType.text = @"Professor & Student";
    else if ([user.employed_schools count] > 0)
        profileheaderview.accountType.text = @"Professor";
    else
        profileheaderview.accountType.text = @"Student";

    profileheaderview.userName.text = user.username;
    self.tableview.tableHeaderView = profileheaderview;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    user = [BTUserDefault getUser];
    fullname = user.full_name;
    email = user.email;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)reloadTableView:(NSNotification *)noti {
    [self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
        default:
            return [user.employed_schools count] + [user.enrolled_schools count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"ProfileCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];

                ((ProfileCell *) cell).title.text = @"Name";
                ((ProfileCell *) cell).data.text = fullname;
                break;
            }
            case 1: {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];

                ((ProfileCell *) cell).title.text = @"Email";
                ((ProfileCell *) cell).data.text = email;
                break;
            }
            case 2: {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];

                ((ProfileCell *) cell).title.text = @"School";
                ((ProfileCell *) cell).data.text = @"";
                ((ProfileCell *) cell).accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            default: {
                break;
            }
        }
    }
    else if (indexPath.section == 1) {
        NSArray *topLevelObejcts = [[NSBundle mainBundle] loadNibNamed:@"SchoolInfoCell" owner:self options:nil];
        cell = [topLevelObejcts objectAtIndex:0];
        
        if (indexPath.row < [user.employed_schools count]) {
            ((SchoolInfoCell *) cell).simpleSchool = user.employed_schools[indexPath.row];
            ((SchoolInfoCell *) cell).Info_SchoolName.text = ((SchoolInfoCell *) cell).simpleSchool.name;
            ((SchoolInfoCell *) cell).Info_SchoolID.text = @"Professor";
        } else {
            ((SchoolInfoCell *) cell).simpleSchool = user.enrolled_schools[indexPath.row - [user.employed_schools count]];
            ((SchoolInfoCell *) cell).Info_SchoolName.text = ((SchoolInfoCell *) cell).simpleSchool.name;
            NSString *identity = @"";
            for (int j = 0; j < [user.identifications count]; j++)
                if (((SimpleIdentification *)user.identifications[j]).school == ((SchoolInfoCell *) cell).simpleSchool.id)
                    identity = ((SimpleIdentification *)user.identifications[j]).identity;
            ((SchoolInfoCell *) cell).Info_SchoolID.text = [NSString stringWithFormat:@"Student - %@", identity];
        }
        ((SchoolInfoCell *) cell).backgroundColor = [UIColor clearColor];
        ((SchoolInfoCell *) cell).contentView.backgroundColor = [UIColor clearColor];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 44;
        default:
            return 53;
    }
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self editName];
            break;
        case 1:
            [self editEmail];
            break;
        case 2:
        default:
            break;
    }
}

#pragma Actions
- (void)editName {
    ProfileNameEditViewController *stdProfileNameEditView = [[ProfileNameEditViewController alloc] init];
    stdProfileNameEditView.fullname = fullname;
    [self.navigationController pushViewController:stdProfileNameEditView animated:YES];
}

- (void)editEmail {
    ProfileEmailEditViewController *stdProfileEmailEditView = [[ProfileEmailEditViewController alloc] init];
    stdProfileEmailEditView.email = email;
    [self.navigationController pushViewController:stdProfileEmailEditView animated:YES];
}

@end
