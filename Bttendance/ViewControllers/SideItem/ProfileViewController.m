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
#import "ClickerQuestionViewController.h"
#import "ProfileIdentityEditViewController.h"
#import "CourseDetailViewController.h"
#import "ProfileUpdatePassViewController.h"
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.user getClosedCourses] count] + [self.user.employed_schools count] + [self.user.enrolled_schools count] + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger closedCourses = [[self.user getClosedCourses] count];
    NSInteger employedSchools = [self.user.employed_schools count];
    NSInteger enrolledSchools = [self.user.enrolled_schools count];
    
    if (indexPath.row == 0
        || indexPath.row == 1
        || indexPath.row == 3
        || indexPath.row == 4
        || indexPath.row == closedCourses + employedSchools + enrolledSchools + 8)
        return 46;
    
    if (indexPath.row == 2)
        return 60;
    
    if (indexPath.row == 5) {
        if (closedCourses == 0)
            return 0;
        else
            return 60;
    }
    
    if (indexPath.row == closedCourses + 6) {
        if (employedSchools + enrolledSchools == 0)
            return 0;
        else
            return 60;
    }
    
    
    if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 7)
        return 55;
    
    if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 9)
        return 33;
    
    if (indexPath.row < closedCourses + employedSchools + enrolledSchools + 7)
        return 74;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger closedCourses = [[self.user getClosedCourses] count];
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
        title.text = NSLocalizedString(@"CLICKER", nil);
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [UIColor silver:1.0];
        [cell addSubview:title];
        return cell;
    }
    
    else if (indexPath.row == 3) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.password.text = [NSString stringWithFormat:NSLocalizedString(@"%ld Saved Clicker Questions", nil), (long) self.user.questions_count];
        cell.password.textColor = [UIColor navy:1.0];
        return cell;
    }
    
    else if (indexPath.row == 4) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.password.text = NSLocalizedString(@"설문 기본 옵션", nil);
        cell.password.textColor = [UIColor navy:1.0];
        return cell;
    }
    
    else if (indexPath.row == 5) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 39, 280, 14)];
        if (closedCourses > 0)
            title.text = NSLocalizedString(@"CLOSED LECTURES", nil);
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [UIColor silver:1.0];
        [cell addSubview:title];
        return cell;
    }
    
    else if (indexPath.row > 5 && indexPath.row < closedCourses + 6) {
        static NSString *CellIdentifier = @"SchoolInfoCell";
        SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.Info_SchoolName.textColor = [UIColor cyan:1.0];
        
        NSArray *closedCourses = [self.user getClosedCourses];
        SimpleCourse *course = [closedCourses objectAtIndex:indexPath.row - 6];
        cell.Info_SchoolName.text = course.name;
        cell.Info_SchoolID.text = [self.user getSchoolNameFromId:course.school];
        cell.arrow.hidden = NO;
        return  cell;
    }
    
    else if (indexPath.row == closedCourses + 6) {
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
    
    else if (indexPath.row > closedCourses + 6 && indexPath.row < closedCourses + employedSchools + enrolledSchools + 7) {
        static NSString *CellIdentifier = @"SchoolInfoCell";
        SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.Info_SchoolName.textColor = [UIColor navy:1.0];
        
        NSInteger index = indexPath.row - closedCourses - 7;
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
    
    else if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 7) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        return cell;
    }
    
    else if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 8) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.password.text = NSLocalizedString(@"Update Password", nil);
        cell.password.textColor = [UIColor red:1.0];
        return cell;
    }
    
    else if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 9) {
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
    
    NSInteger closedCourses = [[self.user getClosedCourses] count];
    NSInteger employedSchools = [self.user.employed_schools count];
    NSInteger enrolledSchools = [self.user.enrolled_schools count];
    
    if (indexPath.row == 0)
        [self editName];
    
    if (indexPath.row == 1)
        [self editEmail];
    
    if (indexPath.row == 3)
        [self questions];
    
    if (indexPath.row == 4)
        [self questionOption];
    
    if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 8)
        [self updatePass];
    
    
    else if (indexPath.row > 4 && indexPath.row < closedCourses + 6) {
        NSArray *closedCourses = [self.user getClosedCourses];
        CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
        courseDetail.simpleCourse = [closedCourses objectAtIndex:indexPath.row - 6];
        [self.navigationController pushViewController:courseDetail animated:YES];
    }
    
    else if (indexPath.row > closedCourses + employedSchools + 6 && indexPath.row < closedCourses + employedSchools + enrolledSchools + 7) {
        NSInteger index = indexPath.row - closedCourses - employedSchools - 7;
        SimpleSchool *school = self.user.enrolled_schools[index];
        for (int j = 0; j < [self.user.identifications count]; j++)
            if (((SimpleIdentification *)self.user.identifications[j]).school == school.id)
                [self editIdentity:self.user.identifications[j]];
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

- (void)questions {
    ClickerQuestionViewController *questionView = [[ClickerQuestionViewController alloc] init];
    questionView.questionType = SHOW;
    [self.navigationController pushViewController:questionView animated:YES];
}

- (void)questionOption {
    ClickerOptionViewController *clickerOption = [[ClickerOptionViewController alloc] init];
    User *user = [BTUserDefault getUser];
    clickerOption.progressTime = user.setting.progress_time;
    clickerOption.showInfoOnSelect = user.setting.show_info_on_select;
    clickerOption.detailPrivacy = user.setting.detail_privacy;
    clickerOption.delegate = self;
    [self.navigationController pushViewController:clickerOption animated:YES];
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

#pragma ClickerOptionViewControllerDelegate
- (void)chosenOptionTime:(NSInteger)progressTime andOnSelect:(BOOL)showInfoOnSelect andDetail:(NSString *)detailPrivacy {
    [BTAPIs updateClickerDefaultsWithTime:[NSString stringWithFormat:@"%ld", progressTime]
                                andSelect:showInfoOnSelect
                               andPrivacy:detailPrivacy
                                  success:nil failure:nil];
}

@end
