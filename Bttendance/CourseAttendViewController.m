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
#import "BTColor.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface CourseAttendViewController ()

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
    TextInputCell *cell = (TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index];
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
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }
    
    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:NSLocalizedString(@"Code", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(TextInputCell *) cell textfield].frame = CGRectMake(68, 1, 252, 40);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard
            
            [[(TextInputCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 1: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:NSLocalizedString(@"Attend Course", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:1.0] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateSelected];
            
            [cell_new.button addTarget:self action:@selector(attendButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)attendButton:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    NSString *code = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:code_index]).textfield text];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Searching Course", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs searchCourseWithCode:code success:^(Course *course) {
        hud.detailsLabelText = NSLocalizedString(@"Attending Course", nil);
        [BTAPIs attendCourse:[NSString stringWithFormat:@"%ld", (long)course.id] success:^(User *user) {
            [hud hide:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            button.enabled = YES;
            [hud hide:YES];
        }];
    } failure:^(NSError *error) {
        button.enabled = YES;
        [hud hide:YES];
    }];
}

@end
