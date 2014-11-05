//
//  SignUpController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "CourseCreateViewController.h"
#import "UITableViewController+Bttendance.h"
#import "TextInputCell.h"
#import "ChooseSchoolCell.h"
#import "SignButtonCell.h"
#import "GuideCourseCreateViewController.h"

@interface CourseCreateViewController ()
@end

@implementation CourseCreateViewController
@synthesize schoolId, schoolName, prfName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"Create Course", @"") withSubTitle:nil];
    [self setLeftMenu:LeftMenuType_Close];
    [self initTableView];
    
    nameIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    profnameIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    schoolIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    prfName = [BTDatabase getUser].full_name;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:nameIndex];
    [cell.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:nameIndex];
    [cell.textfield resignFirstResponder];
    TextInputCell *cell2 = (TextInputCell *) [self.tableView cellForRowAtIndexPath:profnameIndex];
    [cell2.textfield resignFirstResponder];
    TextInputCell *cell3 = (TextInputCell *) [self.tableView cellForRowAtIndexPath:schoolIndex];
    [cell3.textfield resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
            return 78;
        default:
            return 44;
    }
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
            [[cell textLabel] setText:NSLocalizedString(@"Name", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];
            
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard
            
            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 1: {
            [[cell textLabel] setText:NSLocalizedString(@"Professor", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];
            
            [(TextInputCell *) cell textfield].enabled = YES;
            [(TextInputCell *) cell textfield].text = self.prfName;
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyDone;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
            
        case 2: {
            static NSString *CellIdentifier1 = @"ChooseSchoolCell";
            ChooseSchoolCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell_new == nil) {
                cell_new = [[ChooseSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
                cell_new.backgroundColor = [UIColor white:1];
            }
            
            [[cell_new textLabel] setText:NSLocalizedString(@"School", nil)];
            [[cell_new textLabel] setTextColor:[UIColor navy:1]];
            [[cell_new textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell_new textLabel].backgroundColor = [UIColor clearColor];
            
            [(TextInputCell *) cell_new textfield].enabled = NO;
            [(TextInputCell *) cell_new textfield].text = self.schoolName;
            [(TextInputCell *) cell_new textfield].placeholder = NSLocalizedString(@"Please choose a school.", nil);
            [(TextInputCell *) cell_new textfield].delegate = self;
            [(TextInputCell *) cell_new textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell_new textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell_new textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(TextInputCell *) cell_new textfield] setTextColor:[UIColor silver:1]];
            [[(TextInputCell *) cell_new textfield] setFont:[UIFont systemFontOfSize:15]];
            [(TextInputCell *) cell_new textfield].backgroundColor = [UIColor clearColor];
            
            return cell_new;
        }
            
        case 3: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell_new.button setTitle:NSLocalizedString(@"Create Course", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
            
            [cell_new.button addTarget:self action:@selector(createButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        SchoolChooseViewController *schoolChoose = [[SchoolChooseViewController alloc] initWithNibName:@"SchoolChooseViewController" bundle:nil];
        schoolChoose.delegate = self;
        [self.navigationController pushViewController:schoolChoose animated:YES];
    }
}

- (void)createButton:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    NSString *name = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:nameIndex]).textfield text];
    NSString *prof = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:profnameIndex]).textfield text];
    NSString *sid = [NSString stringWithFormat:@"%ld", (long) self.schoolId];
    
    BOOL pass = YES;
    
    if (name == nil || name.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:nameIndex]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:nameIndex]).contentView.backgroundColor = [UIColor clearColor];
    
    if (prof == nil || prof.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:profnameIndex]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:profnameIndex]).contentView.backgroundColor = [UIColor clearColor];
    
    if (self.schoolId == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:schoolIndex]).contentView.backgroundColor = [UIColor red:0.1];
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:schoolIndex]).textfield setValue:[UIColor red:0.5]
                                                                                         forKeyPath:@"_placeholderLabel.textColor"];
        pass = NO;
    } else
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:schoolIndex]).contentView.backgroundColor = [UIColor clearColor];
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        button.enabled = YES;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Creating Course", nil);
    hud.yOffset = -40.0f;
    
    NSArray *old_courses = [[BTDatabase getUser] getOpenedCourses];
    
    [BTAPIs createCourseInstantWithName:name
                                 school:sid
                          professorName:prof
                                success:^(User *user) {
                                    
                                    SimpleCourse *createdCourse;
                                    NSArray *new_courses = [[BTDatabase getUser] getOpenedCourses];
                                    for (SimpleCourse *newCourse in new_courses) {
                                        BOOL isNew = YES;
                                        for (SimpleCourse *oldCourse in old_courses) {
                                            if (newCourse.id == oldCourse.id) {
                                                isNew = NO;
                                                break;
                                            }
                                        }
                                        if (isNew)
                                            createdCourse = newCourse;
                                    }
                                    
                                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:createdCourse, SimpleCourseInfo, nil];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                                    
                                    [BTAPIs searchCourseWithCode:@""
                                                            orId:[NSString stringWithFormat:@"%ld", (long)createdCourse.id]
                                                         success:^(Course *course) {
                                                             [hud hide:YES];
                                                             
                                                             GuideCourseCreateViewController *courseCreateView = [[GuideCourseCreateViewController alloc] initWithNibName:@"GuideCourseCreateViewController" bundle:nil];
                                                             courseCreateView.courseCode = course.code;
                                                             NSDictionary *data2 = [[NSDictionary alloc] initWithObjectsAndKeys:courseCreateView, ModalViewController, nil];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:OpenModalView object:nil userInfo:data2];
                                                             
                                                             [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                                         } failure:^(NSError *error) {
                                                             button.enabled = YES;
                                                             [hud hide:YES];
                                                         }];
                                } failure:^(NSError *error) {
                                    button.enabled = YES;
                                    [hud hide:YES];
                                }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:nameIndex]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:profnameIndex]).textfield becomeFirstResponder];
        return YES;
    }
    
    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:profnameIndex]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:profnameIndex]).textfield resignFirstResponder];
        return YES;
    }
    
    return NO;
}

#pragma SchoolChooseViewControllerDelegate
- (void)chosenSchool:(School *)chosen {
    self.schoolName = chosen.name;
    self.schoolId = chosen.id;
    ((TextInputCell *) [self.tableView cellForRowAtIndexPath:schoolIndex]).textfield.text = self.schoolName;
}

@end
