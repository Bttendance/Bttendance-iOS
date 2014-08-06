//
//  CourseSettingViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 25..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CourseSettingViewController.h"
#import "ManagerViewController.h"
#import "GradeViewController.h"
#import "Course.h"
#import "BTUserDefault.h"
#import "PasswordCell.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface CourseSettingViewController ()

@property (strong, nonatomic) Course *course;

@end

@implementation CourseSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.course = [BTUserDefault getCourse:self.simpleCourse.id];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [BTColor BT_white:1.0];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Course Setting", @"");
    [titlelabel sizeToFit];
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9 + self.course.managers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if (indexPath.row == self.course.managers.count + 2
        || indexPath.row == self.course.managers.count + 6)
        return 60;
    
    if (indexPath.row == 0
        ||indexPath.row == self.course.managers.count + 8)
        return 45;
    
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 24, 280, 14)];
        title.text = NSLocalizedString(@"MANAGERS", nil);
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [BTColor BT_silver:1.0];
        [cell addSubview:title];
        return cell;
    }
    
    else if (indexPath.row > 0 && indexPath.row < 2 + self.course.managers.count) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.password.textColor = [BTColor BT_silver:1.0];
        
        if (indexPath.row == 1 + self.course.managers.count) {
            cell.password.text = NSLocalizedString(@"Add Manager", nil);
            cell.arrow.hidden = NO;
        } else {
            cell.password.text = ((SimpleUser *)self.course.managers[indexPath.row - 1]).full_name;
            cell.arrow.hidden = YES;
        }
        return cell;
    }
    
    else if (indexPath.row == 2 + self.course.managers.count) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 39, 280, 14)];
        title.text = NSLocalizedString(@"GRADES", nil);
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [BTColor BT_silver:1.0];
        [cell addSubview:title];
        return cell;
    }
    
    else if (indexPath.row > 2 + self.course.managers.count && indexPath.row < 6 + self.course.managers.count) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.password.textColor = [BTColor BT_silver:1.0];
        cell.arrow.hidden = NO;
        
        switch (indexPath.row - self.course.managers.count) {
            case 3:
                cell.password.text = NSLocalizedString(@"Export Grades", nil);
                break;
            case 4:
                cell.password.text = NSLocalizedString(@"Clicker Grades", nil);
                break;
            case 5:
            default:
                cell.password.text = NSLocalizedString(@"Attendance Grades", nil);
                break;
        }
        return cell;
    }
    
    else if (indexPath.row == self.course.managers.count + 7) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.password.textColor = [BTColor BT_red:1.0];
        cell.arrow.hidden = NO;
        cell.password.text = NSLocalizedString(@"Close Course", nil);
        return cell;
    }
    
    else if (indexPath.row == self.course.managers.count + 8) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        return cell;
    }
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1 + self.course.managers.count) {
        [self addManager];
    }
        
    switch (indexPath.row - self.course.managers.count) {
        case 3:
            [self exportGrades];
            break;
        case 4:
            [self showClickerGrades];
            break;
        case 5:
            [self showAttendanceGrades];
            break;
        default:
            break;
    }
    
    if (indexPath.row == self.course.managers.count + 7) {
        [self closeCourse];
    }
}

#pragma Actions
- (void)addManager {
    ManagerViewController *managerView = [[ManagerViewController alloc] initWithNibName:@"ManagerViewController" bundle:nil];
    managerView.courseId = [NSString stringWithFormat:@"%ld", (long)self.simpleCourse.id];
    managerView.courseName = self.simpleCourse.name;
    [self.navigationController pushViewController:managerView animated:YES];
}

- (void)exportGrades {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Exporting Grades", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs exportGradesWithCourse:[NSString stringWithFormat:@"%ld", (long)self.simpleCourse.id]
                           success:^(Email *email) {
                               [hud hide:YES];
                               NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Exporting Grades has been finished.\nPlease check your email.\n%@", nil), email.email];
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Exporting Grades", nil)
                                                                               message:message
                                                                              delegate:self
                                                                     cancelButtonTitle:nil
                                                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                               [alert show];
                           } failure:^(NSError *error) {
                               [hud hide:YES];
                           }];
}

- (void)showClickerGrades {
    GradeViewController *gradeView = [[GradeViewController alloc] initWithNibName:@"GradeViewController" bundle:nil];
    gradeView.cid = [NSString stringWithFormat:@"%ld", (long)self.simpleCourse.id];
    gradeView.type = @"clicker";
    [self.navigationController pushViewController:gradeView animated:YES];
}

- (void)showAttendanceGrades {
    GradeViewController *gradeView = [[GradeViewController alloc] initWithNibName:@"GradeViewController" bundle:nil];
    gradeView.cid = [NSString stringWithFormat:@"%ld", (long)self.simpleCourse.id];
    gradeView.type = @"attendance";
    [self.navigationController pushViewController:gradeView animated:YES];
}

- (void)closeCourse {
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"Do you wish to close %@?", nil), self.simpleCourse.name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Close Course", nil)
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alert show];
}

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [BTColor BT_navy:0.7];
        hud.labelText = NSLocalizedString(@"Loading", nil);
        hud.detailsLabelText = NSLocalizedString(@"Closing Course", nil);
        hud.yOffset = -40.0f;
        
        [BTAPIs closeCourse:[NSString stringWithFormat:@"%ld", (long)self.simpleCourse.id]
                    success:^(User *user) {
                        [hud hide:YES];
                    } failure:^(NSError *error) {
                        [hud hide:YES];
                    }];
    }
}

@end
