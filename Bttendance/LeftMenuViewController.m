//
//  LeftMenuViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "GuidePageViewController.h"
#import "CourseCreateViewController.h"
#import "CourseDetailViewController.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "BTUserDefault.h"
#import "BTColor.h"
#import "SideHeaderView.h"
#import "SideInfoCell.h"
#import "SideCourseInfoCell.h"

@interface LeftMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) SideHeaderView *header;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SideHeaderView" owner:self options:nil];
    self.header = [topLevelObjects objectAtIndex:0];
    [self.header.headerBT addTarget:self action:@selector(goToProfile:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:
                                  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                              style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.header;
    
    self.tableView.backgroundColor = [BTColor BT_white:1.0];
    self.view.backgroundColor = [BTColor BT_white:1.0];
    
    [self refreshUser];
}

- (void)refreshUser
{
    self.user = [BTUserDefault getUser];
    self.header.name.text = self.user.full_name;
    if (self.user.supervising_courses.count > 0)
        self.header.type.text = NSLocalizedString(@"PROFESSOR", nil);
    else
        self.header.type.text = NSLocalizedString(@"STUDENT", nil);
}

- (void)goToProfile:(id)sender
{
    ProfileViewController *profileView = [[ProfileViewController alloc] initWithCoder:nil];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:profileView]];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                         delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:NSLocalizedString(@"Create Course", nil), NSLocalizedString(@"Attend Course", nil), nil];
                [actionSheet showInView:self.view];
                break;
            } else if (indexPath.row > self.user.supervising_courses.count) {
                CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
                courseDetail.auth = NO;
                courseDetail.simpleCourse = self.user.attending_courses[indexPath.row - self.user.supervising_courses.count - 1];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:courseDetail]];
                [self.sideMenuViewController hideMenuViewController];
                break;
            } else {
                CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
                courseDetail.auth = NO;
                courseDetail.simpleCourse = self.user.supervising_courses[indexPath.row - 1];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:courseDetail]];
                [self.sideMenuViewController hideMenuViewController];
                break;
            }
        }
        case 1:
        default:
            switch (indexPath.row) {
                case 0: {
                    GuidePageViewController *guidePage = [[GuidePageViewController alloc] initWithNibName:@"GuidePageViewController" bundle:nil];
                    [self presentViewController:guidePage animated:NO completion:nil];
                    break;
                }
                case 1: {
                    SettingViewController *settingView = [[SettingViewController alloc] initWithCoder:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:settingView]];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                }
                default: {
                    // facebook page
                    break;
                }
            }
    }
}

#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    switch (sectionIndex) {
        case 0:
            return 1 + self.user.attending_courses.count + self.user.supervising_courses.count;
        case 1:
            return 3;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"LECTURES", nil);
        case 1:
            return NSLocalizedString(@"BTTENDANCE", nil);
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0)
                return 44;
            else
                return 113;
        case 1:
        default:
            return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"SideInfoCell";
                SideInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
                if (cell == nil) {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                cell.Info.text = NSLocalizedString(@"Add Course", nil);
                return cell;
            } else if (indexPath.row > self.user.supervising_courses.count) {
                static NSString *CellIdentifier = @"SideCourseInfoCell";
                SideCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
                if (cell == nil) {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                cell.name.text = ((SimpleCourse *)self.user.attending_courses[indexPath.row - self.user.supervising_courses.count - 1]).name;
                return cell;
            } else {
                static NSString *CellIdentifier = @"SideCourseInfoCell";
                SideCourseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
                if (cell == nil) {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                cell.name.text = ((SimpleCourse *)self.user.supervising_courses[indexPath.row - 1]).name;
                return cell;
            }
        }
        case 1:
        default: {
            static NSString *CellIdentifier = @"SideInfoCell";
            SideInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            switch (indexPath.row) {
                case 0:
                    cell.Info.text = NSLocalizedString(@"Guide", nil);
                    break;
                case 1:
                    cell.Info.text = NSLocalizedString(@"Setting", nil);
                    break;
                default:
                    cell.Info.text = NSLocalizedString(@"Feedback", nil);
                    break;
            }
            return cell;
        }
    }
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: { //create course
            CourseCreateViewController *schoolChooseView = [[CourseCreateViewController alloc] init];
            [self.navigationController pushViewController:schoolChooseView animated:YES];
            break;
        }
        case 1: //attend course
            break;
        case 2:
        default:
            break;
    }
}

@end
