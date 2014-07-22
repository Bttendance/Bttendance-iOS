//
//  StdProfileView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "ProfileNameEditViewController.h"
#import "ProfileEmailEditViewController.h"
#import "ProfileIdentityEditViewController.h"
#import "ProfileUpdatePassViewController.h"
#import "ProfileCell.h"
#import "SchoolInfoCell.h"
#import "PasswordCell.h"
#import "BTAPIs.h"
#import "BTColor.h"
#import "User.h"
#import "Identification.h"
#import "BTNotification.h"

@interface ProfileViewController ()

@property(strong, nonatomic) User *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [BTUserDefault getUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Profile", nil);
    [titlelabel sizeToFit];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.user = [BTUserDefault getUser];
}

- (void)reloadTableView:(NSNotification *)noti {
    self.user = [BTUserDefault getUser];
    [self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return [self.user.employed_schools count] + [self.user.enrolled_schools count];
        case 2:
        default:
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 47;
        case 1:
            return 74;
        case 2:
        default:
            return 47;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
        case 1:
        default:
            return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1: {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            header.backgroundColor = [BTColor BT_grey:1.0];
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 29, 280, 14)];
            title.text = NSLocalizedString(@"SCHOOL", nil);
            title.font = [UIFont boldSystemFontOfSize:12];
            title.textColor = [BTColor BT_silver:1.0];
            [header addSubview:title];
            return header;
        }
        case 2:
        default: {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            header.backgroundColor = [BTColor BT_grey:1.0];
            return header;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"ProfileCell";
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
                cell.title.text = NSLocalizedString(@"Name", nil);
                cell.data.text = self.user.full_name;
                return cell;
            case 1:
            default:
                cell.title.text = NSLocalizedString(@"Email", nil);
                cell.data.text = self.user.email;
                return cell;
        }
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"SchoolInfoCell";
        SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row < [self.user.employed_schools count]) {
            cell.simpleSchool = self.user.employed_schools[indexPath.row];
            cell.Info_SchoolName.text = ((SchoolInfoCell *) cell).simpleSchool.name;
            cell.Info_SchoolID.text = NSLocalizedString(@"Professor", nil);
            cell.arrow.hidden = YES;
        } else {
            cell.simpleSchool = self.user.enrolled_schools[indexPath.row - [self.user.employed_schools count]];
            cell.Info_SchoolName.text = ((SchoolInfoCell *) cell).simpleSchool.name;
            NSString *identity = @"";
            for (int j = 0; j < [self.user.identifications count]; j++)
                if (((SimpleIdentification *)self.user.identifications[j]).school == ((SchoolInfoCell *) cell).simpleSchool.id)
                    identity = ((SimpleIdentification *)self.user.identifications[j]).identity;
            ((SchoolInfoCell *) cell).Info_SchoolID.text = [NSString stringWithFormat:NSLocalizedString(@"Student - %@", nil), identity];
            cell.arrow.hidden = NO;
        }
        return  cell;
    } else {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.password.text = NSLocalizedString(@"Update Password", nil);
        return cell;
    }
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self editName];
                break;
            case 1:
            default:
                [self editEmail];
                break;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row >= [self.user.employed_schools count]) {
            SimpleSchool *school = self.user.enrolled_schools[indexPath.row - [self.user.employed_schools count]];
            for (int j = 0; j < [self.user.identifications count]; j++)
                if (((SimpleIdentification *)self.user.identifications[j]).school == school.id)
                    [self editIdentity:self.user.identifications[j]];
        }
    } else {
        [self updatePass];
    }
}

#pragma Actions
- (void)editName {
    ProfileNameEditViewController *profileNameEditView = [[ProfileNameEditViewController alloc] init];
    profileNameEditView.fullname = self.user.full_name;
    [self.navigationController pushViewController:profileNameEditView animated:YES];
}

- (void)editEmail {
    ProfileEmailEditViewController *profileEmailEditView = [[ProfileEmailEditViewController alloc] init];
    profileEmailEditView.email = self.user.email;
    [self.navigationController pushViewController:profileEmailEditView animated:YES];
}

- (void)editIdentity:(SimpleIdentification *)identification {
    ProfileIdentityEditViewController *profileIdentityEditView = [[ProfileIdentityEditViewController alloc] init];
    profileIdentityEditView.identification = identification;
    [self.navigationController pushViewController:profileIdentityEditView animated:YES];
}

- (void)updatePass {
    ProfileUpdatePassViewController *profileUpdatePassView = [[ProfileUpdatePassViewController alloc] init];
    [self.navigationController pushViewController:profileUpdatePassView animated:YES];
}

@end
