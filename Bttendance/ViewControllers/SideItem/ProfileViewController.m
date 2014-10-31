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
#import "CatchPointViewController.h"
#import "ProfileCell.h"
#import "SchoolInfoCell.h"
#import "PasswordCell.h"
#import "BTAPIs.h"
#import "UIColor+Bttendance.h"
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
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuButtonItem];
    
    self.tableView.backgroundColor = [UIColor grey:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.user = [BTUserDefault getUser];
}

- (void)reloadTableView:(NSNotification *)noti {
    self.user = [BTUserDefault getUser];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.user.employed_schools count] + [self.user.enrolled_schools count] + 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger employedSchools = [self.user.employed_schools count];
    NSInteger enrolledSchools = [self.user.enrolled_schools count];
    
    if (indexPath.row == 0
        || indexPath.row == 1
        || indexPath.row == employedSchools + enrolledSchools + 4
        || indexPath.row == employedSchools + enrolledSchools + 5)
        return 47;
    
    if (indexPath.row == 2) {
        if (employedSchools + enrolledSchools == 0)
            return 0;
        else
            return 60;
    }
    
    
    if (indexPath.row == employedSchools + enrolledSchools + 3)
        return 55;
    
    if (indexPath.row == employedSchools + enrolledSchools + 6)
        return 33;
    
    if (indexPath.row < employedSchools + enrolledSchools + 3)
        return 74;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger employedSchools = [self.user.employed_schools count];
    NSInteger enrolledSchools = [self.user.enrolled_schools count];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        static NSString *CellIdentifier = @"ProfileCell";
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.row) {
            case 0:
                cell.title.text = NSLocalizedString(@"Name for profile", nil);
                cell.data.text = self.user.full_name;
                return cell;
            case 1:
            default:
                cell.title.text = NSLocalizedString(@"Email", nil);
                cell.data.text = self.user.email;
                return cell;
        }
    }
    
    else if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 39, 280, 14)];
        if (employedSchools + enrolledSchools > 0)
            title.text = NSLocalizedString(@"SCHOOL", nil);
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [UIColor silver:1.0];
        [cell addSubview:title];
        return cell;
    }
    
    else if (indexPath.row < employedSchools + enrolledSchools + 3) {
        static NSString *CellIdentifier = @"SchoolInfoCell";
        SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.Info_SchoolName.textColor = [UIColor navy:1.0];
        
        NSInteger index = indexPath.row - 3;
        if (index < employedSchools) {
            cell.simpleSchool = self.user.employed_schools[index];
            cell.Info_SchoolName.text = ((SchoolInfoCell *) cell).simpleSchool.name;
            cell.Info_SchoolID.text = NSLocalizedString(@"Professor for profile", nil);
            cell.arrow.hidden = YES;
            cell.selected_bg.backgroundColor = [UIColor cyan:0.0];
        } else {
            cell.simpleSchool = self.user.enrolled_schools[index - employedSchools];
            cell.Info_SchoolName.text = ((SchoolInfoCell *) cell).simpleSchool.name;
            NSString *identity = @"";
            for (int j = 0; j < [self.user.identifications count]; j++)
                if (((SimpleIdentification *)self.user.identifications[j]).school == ((SchoolInfoCell *) cell).simpleSchool.id)
                    identity = ((SimpleIdentification *)self.user.identifications[j]).identity;
            ((SchoolInfoCell *) cell).Info_SchoolID.text = [NSString stringWithFormat:NSLocalizedString(@"Student - %@", nil), identity];
            cell.arrow.hidden = NO;
            cell.selected_bg.backgroundColor = [UIColor cyan:0.1];
        }
        return  cell;
    }
    
    else if (indexPath.row == employedSchools + enrolledSchools + 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        return cell;
    }
    
    else if (indexPath.row < employedSchools + enrolledSchools + 6) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.row - employedSchools - enrolledSchools) {
            case 4:
                cell.password.text = NSLocalizedString(@"Update Password", nil);
                break;
            case 5:
            default:
                cell.password.text = NSLocalizedString(@"Sign Out", nil);
                break;
        }
        
        cell.password.textColor = [UIColor red:1.0];
        return cell;
    }
    
    else if (indexPath.row == employedSchools + enrolledSchools + 6) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        return cell;
    }
}

//#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger employedSchools = [self.user.employed_schools count];
    NSInteger enrolledSchools = [self.user.enrolled_schools count];
    
    if (indexPath.row == 0)
        [self editName];
    
    if (indexPath.row == 1)
        [self editEmail];
    
    if (indexPath.row == employedSchools + enrolledSchools + 4)
        [self updatePass];
    
    if (indexPath.row == employedSchools + enrolledSchools + 5)
        [self signOut];
    
    else if (indexPath.row > employedSchools + 2 && indexPath.row < employedSchools + enrolledSchools + 3) {
        NSInteger index = indexPath.row - employedSchools - 3;
        SimpleSchool *school = self.user.enrolled_schools[index];
        BOOL found = NO;
        for (int j = 0; j < [self.user.identifications count]; j++) {
            if (((SimpleIdentification *)self.user.identifications[j]).school == school.id) {
                found = YES;
                [self editIdentity:self.user.identifications[j] andSchoolID:school.id];
            }
        }
        
        if (!found)
            [self editIdentity:nil andSchoolID:school.id];
    }
}

#pragma Actions
- (void)editName {
    ProfileNameEditViewController *profileNameEditView = [[ProfileNameEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
    profileNameEditView.fullname = self.user.full_name;
    [self.navigationController pushViewController:profileNameEditView animated:YES];
}

- (void)editEmail {
    ProfileEmailEditViewController *profileEmailEditView = [[ProfileEmailEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
    profileEmailEditView.email = self.user.email;
    [self.navigationController pushViewController:profileEmailEditView animated:YES];
}

- (void)editIdentity:(SimpleIdentification *)identification andSchoolID:(NSInteger)schoolID {
    ProfileIdentityEditViewController *profileIdentityEditView = [[ProfileIdentityEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
    profileIdentityEditView.identification = identification;
    profileIdentityEditView.schoolID = schoolID;
    [self.navigationController pushViewController:profileIdentityEditView animated:YES];
}

- (void)updatePass {
    ProfileUpdatePassViewController *profileUpdatePassView = [[ProfileUpdatePassViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:profileUpdatePassView animated:YES];
}

- (void)signOut {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sign Out", nil)
                                       message:NSLocalizedString(@"Are you sure you want to sign out of Bttendance?", nil)
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                             otherButtonTitles:NSLocalizedString(@"Sign Out", nil), nil];
    [alert show];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [BTUserDefault clear];
        CatchPointViewController *catchview = [[CatchPointViewController alloc] initWithNibName:@"CatchPointViewController" bundle:nil];
        UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:catchview];
        navcontroller.navigationBarHidden = YES;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:catchview] animated:NO];
    }
}

@end
