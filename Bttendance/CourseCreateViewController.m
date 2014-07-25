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
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString *createCourseRequest;


@interface CourseCreateViewController ()
@end

@implementation CourseCreateViewController
@synthesize schoolId, schoolName, prfName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    createCourseRequest = [BTURL stringByAppendingString:@"/course/create"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        name_index = [NSIndexPath indexPathForRow:0 inSection:0];
        number_index = [NSIndexPath indexPathForRow:1 inSection:0];
        school_index = [NSIndexPath indexPathForRow:3 inSection:0];
        profname_index = [NSIndexPath indexPathForRow:2 inSection:0];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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

}

- (void)viewDidAppear:(BOOL)animated {
    TextInputCell *cell1 = (TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index];
    [cell1.textfield becomeFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
            [[cell textLabel] setText:NSLocalizedString(@"Course ID", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting

            [[(TextInputCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }

        case 2: {
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

        case 3: {
            [[cell textLabel] setText:NSLocalizedString(@"School", nil)];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(TextInputCell *) cell textfield].enabled = NO;
            [(TextInputCell *) cell textfield].text = self.schoolName;
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting

            [[(TextInputCell *) cell textfield] setTextColor:[BTColor BT_silver:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }

        case 4: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }

            [cell_new.button setTitle:NSLocalizedString(@"Create Course", nil) forState:UIControlStateNormal];
            [cell_new.button addTarget:self action:@selector(CreateButton:) forControlEvents:UIControlEventTouchUpInside];

            return cell_new;
        }
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4:
            return 78;
        default:
            return 44;
    }
}

- (void)CreateButton:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    NSString *name = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:name_index]).textfield text];
    NSString *number = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:number_index]).textfield text];
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
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:number_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:number_index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:profname_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:profname_index]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:profname_index]).textfield resignFirstResponder];
        return NO;
    }
    return NO;
}

@end