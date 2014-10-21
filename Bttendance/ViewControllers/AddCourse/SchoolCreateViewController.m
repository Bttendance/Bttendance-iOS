//
//  SchoolCreateViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 9..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SchoolCreateViewController.h"
#import <AFNetworking.h>
#import "TextInputCell.h"
#import "SignButtonCell.h"
#import "ChooseTypeCell.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "CourseCreateViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>

@interface SchoolCreateViewController ()

@property (strong, nonatomic) UILabel *info;

@end

@implementation SchoolCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    name_index = [NSIndexPath indexPathForRow:0 inSection:0];
    type_index = [NSIndexPath indexPathForRow:1 inSection:0];
    info_index = [NSIndexPath indexPathForRow:2 inSection:0];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Create School", @"");
    [titlelabel sizeToFit];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    self.tableView.backgroundColor = [UIColor grey:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index];
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 44;
        case 1:
            return 85;
        case 2:
            return 26;
        case 3:
            return 78;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            static NSString *CellIdentifier = @"TextInputCell";
            TextInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[TextInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor white:1];
            }
            
            cell.textLabel.text = NSLocalizedString(@"기관명", nil);
            cell.textLabel.textColor = [UIColor navy:1];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            
            cell.textfield.delegate = self;
            cell.textfield.frame = CGRectMake(68, 1, 252, 40);
            cell.textfield.placeholder = NSLocalizedString(@"기관명을 영어로 입력해주세요.", nil);
            cell.textfield.returnKeyType = UIReturnKeyNext;
            cell.textfield.autocorrectionType = UITextAutocorrectionTypeNo;
            cell.textfield.keyboardType = UIKeyboardTypeASCIICapable;
            cell.textfield.textColor = [UIColor black:1];
            cell.textfield.font = [UIFont systemFontOfSize:15];
            cell.textfield.backgroundColor = [UIColor clearColor];
            
            return cell;
        }
            
        case 1: {
            static NSString *CellIdentifier1 = @"ChooseTypeCell";
            ChooseTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ChooseTypeCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.typeLable1.text = NSLocalizedString(@"University", nil);
            cell.typeLable2.text = NSLocalizedString(@"School for school create", nil);
            cell.typeLable3.text = NSLocalizedString(@"Institute for school create", nil);
            cell.typeLable4.text = NSLocalizedString(@"Etc.", nil);
            
            return cell;
        }
            
        case 2: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 26)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor grey:1.0];
            self.info = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 280, 15)];
            self.info.textAlignment = NSTextAlignmentCenter;
            self.info.text = NSLocalizedString(@"해당 기관을 선택해주세요.", nil);
            self.info.numberOfLines = 0;
            self.info.font = [UIFont systemFontOfSize:12];
            self.info.textColor = [UIColor silver:1.0];
            [cell addSubview:self.info];
            return cell;
        }
            
        case 3: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
                cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell_new.button setTitle:NSLocalizedString(@"Create School", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
            
            [cell_new.button addTarget:self action:@selector(createButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (void)createButton:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    NSString *name = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).textfield text];
    NSString *type = ((ChooseTypeCell *) [self.tableView cellForRowAtIndexPath:type_index]).type;
    
    BOOL pass = YES;
    
    if (name == nil || name.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).contentView.backgroundColor = [UIColor red:0.1];
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).textfield setValue:[UIColor red:0.5]
                                                                                       forKeyPath:@"_placeholderLabel.textColor"];
        pass = NO;
    }
    
    NSString *nameRegex = @"[A-Za-z0-9 .,]+";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    
    if(![nameTest evaluateWithObject:name]){
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).contentView.backgroundColor = [UIColor red:0.1];
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).textfield.text = @"";
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).textfield setValue:[UIColor red:0.5]
                                                                                       forKeyPath:@"_placeholderLabel.textColor"];
        pass = NO;
    }
        
    if (type == nil || type.length == 0) {
        ((ChooseTypeCell *) [self.tableView cellForRowAtIndexPath:type_index]).contentView.backgroundColor = [UIColor red:0.1];
        self.info.textColor = [UIColor red:1.0];
        pass = NO;
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        button.enabled = YES;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Creating School", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs createSchoolWithName:name
                            type:type
                         success:^(School *school) {
                             button.enabled = YES;
                             [hud hide:YES];
                             [self.delegate createdSchool:school];
                             
                             UIViewController *courseCreate;
                             for (UIViewController *controller in self.navigationController.viewControllers)
                                 if ([controller isKindOfClass:[CourseCreateViewController class]])
                                     courseCreate = controller;
                             if (courseCreate != nil)
                                 [self.navigationController popToViewController:courseCreate animated:YES];
                             else
                                 [self.navigationController popViewControllerAnimated:YES];
                         } failure:^(NSError *error) {
                             button.enabled = YES;
                             [hud hide:YES];
                         }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}

@end
