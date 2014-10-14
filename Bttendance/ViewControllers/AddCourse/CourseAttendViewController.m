//
//  CourseAttendViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 25..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CourseAttendViewController.h"
#import <AFNetworking.h>
#import "TextInputCell.h"
#import "SignButtonCell.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "BTNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>
#import "GuideCourseAttendViewController.h"

@interface CourseAttendViewController ()

@property (strong, nonatomic) Course *attendingCourse;

@end

@implementation CourseAttendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Attend Course", @"");
    [titlelabel sizeToFit];
    
    //Navigation showing
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    code_index = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = close;
    self.navigationItem.leftItemsSupplementBackButton = NO;
}

- (void)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index];
    [cell.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
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
            [[cell textLabel] setText:NSLocalizedString(@"Code", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];
            
            [(TextInputCell *) cell textfield].frame = CGRectMake(68, 1, 252, 40);
            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"클래스 코드를 입력해 주세요.", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].keyboardType = UIKeyboardTypeASCIICapable;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard
            
            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 1: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell_new.button setTitle:NSLocalizedString(@"Attend Course", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
            
            [cell_new.button addTarget:self action:@selector(attendButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)attendButton:(id)sender {
    
    NSString *code = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index]).textfield text];
    
    BOOL pass = YES;
    
    if (code == nil || code.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index]).contentView.backgroundColor = [UIColor red:0.1];
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index]).textfield setValue:[UIColor red:0.5]
                                                                                       forKeyPath:@"_placeholderLabel.textColor"];
        pass = NO;
    }
    
    NSString *nameRegex = @"[A-Za-z0-9]+";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    
    if(![nameTest evaluateWithObject:code]){
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index]).contentView.backgroundColor = [UIColor red:0.1];
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index]).textfield.text = @"";
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index]).textfield setValue:[UIColor red:0.5]
                                                                                       forKeyPath:@"_placeholderLabel.textColor"];
        pass = NO;
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Searching Course", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs searchCourseWithCode:code orId:@"0" success:^(Course *course) {
        [hud hide:YES];
        
        self.attendingCourse = course;
        if ([[BTUserDefault getUser] enrolled:course.school.id]) {
            [self attendCourse];
        } else {
            
            NSString *title;
            NSString *message;
            
            if ([course.school.type isEqualToString:@"university"]) {
                title = NSLocalizedString(@"Student Number for univ", nil);
                message = [NSString stringWithFormat:NSLocalizedString(@"Before you join course %@, you need to enter your student number for univ", nil), self.attendingCourse.name];
            } else if ([course.school.type isEqualToString:@"school"]) {
                title = NSLocalizedString(@"Student Number for school", nil);
                message = [NSString stringWithFormat:NSLocalizedString(@"Before you join course %@, you need to enter your student number for school", nil), self.attendingCourse.name];
            } else if ([course.school.type isEqualToString:@"institute"]) {
                title = NSLocalizedString(@"Phone Number", nil);
                message = [NSString stringWithFormat:NSLocalizedString(@"Before you join course %@, you need to enter your phone number", nil), self.attendingCourse.name];
            } else {
                title = NSLocalizedString(@"Identity", nil);
                message = [NSString stringWithFormat:NSLocalizedString(@"Before you join course %@, you need to enter your identity", nil), self.attendingCourse.name];
            }
            
            //iOS8 Bug
            TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index];
            [cell.textfield resignFirstResponder];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Confirm", nil), Nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }
        
    } failure:^(NSError *error) {
        self.attendingCourse = nil;
        [hud hide:YES];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.attendingCourse == nil)
        return;
    
    if (buttonIndex == 0) //cancel
        return;
    
    if ([alertView alertViewStyle] == UIAlertViewStyleDefault) {
        [self attendCourse];
    }
    
    if ([alertView alertViewStyle] == UIAlertViewStylePlainTextInput) {
        if ([[alertView textFieldAtIndex:0] text] == nil
            || [[alertView textFieldAtIndex:0] text].length == 0) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertView.title
                                                            message:alertView.message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor navy:0.7];
        hud.labelText = NSLocalizedString(@"Loading", nil);
        hud.detailsLabelText = NSLocalizedString(@"Attending Course", nil);
        hud.yOffset = -40.0f;
        
        [BTAPIs enrollSchool:[NSString stringWithFormat:@"%ld", (long)self.attendingCourse.school.id]
                    identity:[[alertView textFieldAtIndex:0] text]
                     success:^(User *user) {
                         [hud hide:YES];
                         [self attendCourse];
                     } failure:^(NSError *error) {
                         [hud hide:YES];
                     }];
    }
}

- (void)attendCourse {
    
    if (self.attendingCourse == nil)
        return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Attending Course", nil);
    hud.yOffset = -40.0f;
    
    NSArray *old_courses = [[BTUserDefault getUser] getOpenedCourses];
    
    [BTAPIs attendCourse:[NSString stringWithFormat:@"%ld", (long)self.attendingCourse.id]
                 success:^(User *user) {
                     [hud hide:YES];
                     
                     SimpleCourse *createdCourse;
                     NSArray *new_courses = [[BTUserDefault getUser] getOpenedCourses];
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
                     
                     GuideCourseAttendViewController *courseAttendView = [[GuideCourseAttendViewController alloc] initWithNibName:@"GuideCourseAttendViewController" bundle:nil];
                     NSDictionary *data2 = [[NSDictionary alloc] initWithObjectsAndKeys:courseAttendView, ModalViewController, nil];
                     [[NSNotificationCenter defaultCenter] postNotificationName:OpenModalView object:nil userInfo:data2];
                     
                     [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                 } failure:^(NSError *error) {
                     [hud hide:YES];
                 }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:index]).textfield resignFirstResponder];
        [self attendButton:nil];
    }
    
    return NO;
}

@end
