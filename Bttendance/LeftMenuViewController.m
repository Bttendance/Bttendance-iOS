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
#import "BTColor.h"

@interface LeftMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation LeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
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
    
    self.tableView.backgroundColor = [BTColor BT_black:1.0];
    self.view.backgroundColor = [BTColor BT_black:1.0];
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            ProfileViewController *profileView = [[ProfileViewController alloc] initWithCoder:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:profileView]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 1: {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Create Course", @"Attend Course", nil];
            [actionSheet showInView:self.view];
            break;
        }
        case 2: {
            CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:courseDetail]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        case 3: {
            GuidePageViewController *guidePage = [[GuidePageViewController alloc] initWithNibName:@"GuidePageViewController" bundle:nil];
            //            [UIView animateWithDuration:0.75
            //                             animations:^{
            //                                 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            //                                 [self.navigationController pushViewController:guidePage animated:NO];
            //                                 guidePage.view.alpha = 1;
            //                             }];
            [self presentViewController:guidePage animated:YES completion:nil];
            break;
        }
        case 4: {
            SettingViewController *settingView = [[SettingViewController alloc] initWithCoder:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:settingView]];
            [self.sideMenuViewController hideMenuViewController];
            break;
        }
        default:
            break;
    }
}

#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"Profile", @"Add Course", @"Course #1", @"Guide", @"Setting", @"Facebook Page"];
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
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
