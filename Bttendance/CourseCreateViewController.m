//
//  SignUpController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "CourseCreateViewController.h"
#import <AFNetworking.h>
#import "TextInputCell.h"
#import "ChooseSchoolCell.h"
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface CourseCreateViewController ()
@end

@implementation CourseCreateViewController
@synthesize schoolId, schoolName, prfName;

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
    titlelabel.text = NSLocalizedString(@"Create Course", @"");
    [titlelabel sizeToFit];

    //Navigation showing
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    name_index = [NSIndexPath indexPathForRow:0 inSection:0];
    profname_index = [NSIndexPath indexPathForRow:1 inSection:0];
    school_index = [NSIndexPath indexPathForRow:2 inSection:0];
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = close;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    self.prfName = [BTUserDefault getFullName];
}

- (void)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index];
    [cell.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
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
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:NSLocalizedString(@"Name", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard

            [[(TextInputCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 1: {
            [[cell textLabel] setText:NSLocalizedString(@"Professor", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(TextInputCell *) cell textfield].enabled = YES;
            [(TextInputCell *) cell textfield].text = self.prfName;
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyDone;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting

            [[(TextInputCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }

        case 2: {
            static NSString *CellIdentifier1 = @"ChooseSchoolCell";
            ChooseSchoolCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell_new == nil) {
                cell_new = [[ChooseSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell_new contentView].backgroundColor = [BTColor BT_white:1];
            }
            
            [[cell_new textLabel] setText:NSLocalizedString(@"School", nil)];
            [[cell_new textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell_new textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(TextInputCell *) cell_new textfield].enabled = NO;
            [(TextInputCell *) cell_new textfield].text = self.schoolName;
            [(TextInputCell *) cell_new textfield].placeholder = NSLocalizedString(@"Please choose a school.", nil);
            [(TextInputCell *) cell_new textfield].delegate = self;
            [(TextInputCell *) cell_new textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell_new textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell_new textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting

            [[(TextInputCell *) cell textfield] setTextColor:[BTColor BT_silver:1]];
            [[(TextInputCell *) cell_new textfield] setFont:[UIFont systemFontOfSize:15]];
            
            return cell_new;
        }

        case 3: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }

            [cell_new.button setTitle:NSLocalizedString(@"Create Course", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:1.0] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateSelected];
            
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
    
    NSString *name = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).textfield text];
    NSString *prof = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:profname_index]).textfield text];
    NSString *sid = [NSString stringWithFormat:@"%ld", (long) self.schoolId];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Creating Course", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs createCourseInstantWithName:name
                                 school:sid
                          professorName:prof
                                success:^(User *user) {
                                    [hud hide:YES];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                } failure:^(NSError *error) {
                                    button.enabled = YES;
                                    [hud hide:YES];
                                }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:profname_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:profname_index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:profname_index]).textfield resignFirstResponder];
        return YES;
    }
    
    return NO;
}

#pragma SchoolChooseViewControllerDelegate
- (void)chosenSchool:(School *)chosen {
    self.schoolName = chosen.name;
    self.schoolId = chosen.id;
    ((TextInputCell *) [self.tableView cellForRowAtIndexPath:school_index]).textfield.text = self.schoolName;
}

@end
