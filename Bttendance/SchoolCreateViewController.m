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
#import "BTColor.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SchoolCreateViewController ()

@end

@implementation SchoolCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    name_index = [NSIndexPath indexPathForRow:0 inSection:0];
    
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
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TextInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }
    
    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:NSLocalizedString(@"기관명", nil)];
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
            break;
        }
            
        case 2: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 26)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BTColor BT_grey:1.0];
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 280, 15)];
            title .textAlignment = NSTextAlignmentCenter;
            title.text = NSLocalizedString(@"해당 기관을 선택해주세요.", nil);
            title.numberOfLines = 0;
            title.font = [UIFont systemFontOfSize:12];
            title.textColor = [BTColor BT_silver:1.0];
            [cell addSubview:title];
            return cell;
        }
            
        case 3: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:NSLocalizedString(@"Create School", nil) forState:UIControlStateNormal];
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

- (void)createButton:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    NSString *name = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).textfield text];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Creating School", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs createSchoolWithName:name
                            type:@"asdf"
                         success:^(School *school) {

                         } failure:^(NSError *error) {

                         }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}

@end
