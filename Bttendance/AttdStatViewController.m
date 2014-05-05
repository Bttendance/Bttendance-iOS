//
//  CourseView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "AttdStatViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface AttdStatViewController ()

@end

@implementation AttdStatViewController
@synthesize post;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rowcount0 = 0;
        rowcount1 = 0;
        data0 = [[NSMutableArray alloc] init];
        data1 = [[NSMutableArray alloc] init];

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

    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = post.course.name;
    [titlelabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshStat];
}

- (void)refreshStat {
    if (post == nil || post.attendance == nil || post.attendance.checked_students == nil)
        return;
    
    [BTAPIs studentsForCourse:[NSString stringWithFormat: @"%ld", post.course.id]
                      success:^(NSArray *simpleUsers) {
                          
                          [data0 removeAllObjects];
                          [data1 removeAllObjects];
                          
                          NSArray *checks = post.attendance.checked_students;

                          for (int i = 0; i < simpleUsers.count; i++) {
                              BOOL checked = false;
                              for (int j = 0; j < checks.count; j++)
                                  if (((SimpleUser *)simpleUsers[i]).id == [checks[j] integerValue])
                                      checked = true;
                              
                              if (checked)
                                  [data1 addObject:simpleUsers[i]];
                              else
                                  [data0 addObject:simpleUsers[i]];
                          }

                          
                          rowcount0 = data0.count;
                          rowcount1 = data1.count;
                          [self.tableview reloadData];
                          
                      } failure:^(NSError *error) {
                      }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return rowcount0;
        case 1:
        default:
            return rowcount1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Attendance un-checked students";
        case 1:
        default:
            return @"Attendance checked students";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserInfoCell";

    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    if (indexPath.section == 0) {
        cell.simpleUser = [data0 objectAtIndex:indexPath.row];
        cell.Username.text = cell.simpleUser.full_name;
        cell.Email.text = cell.simpleUser.student_id;
        cell.backgroundColor = [BTColor BT_white:1];
        [cell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.Check setBackgroundImage:[UIImage imageNamed:@"enrolladd@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 1) {
        cell.simpleUser = [data1 objectAtIndex:indexPath.row];
        cell.Username.text = cell.simpleUser.full_name;
        cell.Email.text = cell.simpleUser.student_id;
        cell.backgroundColor = [BTColor BT_white:1];
        [cell.Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

#pragma Actions
- (IBAction)check_button_action:(id)sender {
    
    //attendance check manually
    UIButton *comingbutton = (UIButton *) sender;
    UserInfoCell *comingcell = (UserInfoCell *) comingbutton.superview.superview.superview;
    currentcell = comingcell;
    
    //alert showing
    NSString *string = [NSString stringWithFormat:@"Do you wish to check %@'s attendance manually?", comingcell.simpleUser.full_name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Manual Check"
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:@"Confirm"
                                          otherButtonTitles:@"Cancel", nil];
    [alert show];
    
    //disable button
    [comingbutton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [BTColor BT_navy:0.7];
        hud.labelText = @"Loading";
        hud.detailsLabelText = @"Attendance Checking";
        hud.yOffset = -40.0f;
        
        [BTAPIs checkManuallyWithAttendance:[NSString stringWithFormat:@"%ld", (long) post.attendance.id]
                                       user:[NSString stringWithFormat:@"%ld", (long) currentcell.simpleUser.id]
                                    success:^(Attendance *attendance) {
                                        [hud hide:YES];
                                        [[self tableview] beginUpdates];
                                        [currentcell.Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
                                        rowcount1++;
                                        rowcount0--;
                                        NSIndexPath *comingcell_index = [[self tableview] indexPathForCell:currentcell];
                                        for (int i = 0; i < [data0 count]; i++) {
                                            if (((SimpleUser *)[data0 objectAtIndex:i]).id == currentcell.simpleUser.id) {
                                                [data1 addObject:[data0 objectAtIndex:i]];
                                                [data0 removeObjectAtIndex:i];
                                                break;
                                            }
                                        }
                                        [[self tableview] moveRowAtIndexPath:comingcell_index toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                                        [[self tableview] endUpdates];
                                    } failure:^(NSError *error) {
                                        [hud hide:YES];
                                        [currentcell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
                                    }];
    }
    if (buttonIndex == 0) {
        [currentcell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
