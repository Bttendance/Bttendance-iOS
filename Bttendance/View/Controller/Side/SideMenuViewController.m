//
//  StdMainView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 26..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "SideMenuViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIColor+Bttendance.h"
#import "BTUserDefault.h"
#import "BTAPIs.h"
#import "BTNotification.h"
#import "AttendanceAgent.h"
#import "SocketAgent.h"
#import "LeftMenuViewController.h"
#import "CourseDetailViewController.h"
#import "NoCourseViewController.h"
#import "GuidePageViewController.h"
#import "CourseCreateViewController.h"
#import "CourseAttendViewController.h"

@interface SideMenuViewController ()

@property (strong, nonatomic) UIViewController *popupController;
@property (assign) BOOL anim;

@end

@implementation SideMenuViewController

- (id)initByItSelf {
    
    UINavigationController *navigationController;
    
    if ([BTUserDefault getLastSeenCourse] == 0 || [[BTUserDefault getUser] getCourse:[BTUserDefault getLastSeenCourse]] == nil) {
        NoCourseViewController *noCourse = [[NoCourseViewController alloc] initWithNibName:@"NoCourseViewController" bundle:nil];
        navigationController = [[UINavigationController alloc] initWithRootViewController:noCourse];
    } else {
        CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
        courseDetail.simpleCourse = [[BTUserDefault getUser] getCourse:[BTUserDefault getLastSeenCourse]];
        navigationController = [[UINavigationController alloc] initWithRootViewController:courseDetail];
    }
    
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    self = [self initWithContentViewController:navigationController
                        leftMenuViewController:leftMenuViewController
                       rightMenuViewController:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = [UIColor white:1.0];
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor black:1.0];
    self.contentViewShadowOpacity = 0.4;
    self.contentViewShadowRadius = 10;
    self.contentViewShadowEnabled = YES;
    self.contentViewScaleValue = 1.0;
    self.contentViewInPortraitOffsetCenterX = 110.0f;
    self.panGestureEnabled = NO;
    self.parallaxEnabled = NO;
    self.bouncesHorizontally = YES;
    self.menuPrefersStatusBarHidden = YES;
    self.animationDuration = 0.3f;
    self.delegate = self;
    
    self.contentViewController.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20);
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    [AttendanceAgent sharedInstance];
    
    [BTAPIs autoSignInInSuccess:^(User *user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SideRefresh object:nil];
    } failure:^(NSError *error) {
    }];
    
    [[SocketAgent sharedInstance] socketConnect];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCourse:) name:OpenCourse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setModalView:) name:OpenModalView object:nil];
    
    if (![BTUserDefault getSeenGuide]) {
        GuidePageViewController *guidePage = [[GuidePageViewController alloc] initWithNibName:@"GuidePageViewController" bundle:nil];
        self.popupController = guidePage;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[SocketAgent sharedInstance] socketConnect];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.popupController != nil) {
        [self presentViewController:self.popupController animated:self.anim completion:nil];
        self.popupController = nil;
        self.anim = NO;
    }
}

#pragma NSNotification
- (void)openCourse:(NSNotification *)aNotification {
    NSDictionary *dict = [aNotification userInfo];
    SimpleCourse *course = [dict objectForKey:SimpleCourseInfo];
    if (course == nil)
        return;
    
    if ([self.contentViewController.childViewControllers[0] isKindOfClass:[CourseDetailViewController class]]
         && ((CourseDetailViewController*) self.contentViewController.childViewControllers[0]).simpleCourse.id == course.id)
         return;
    
    CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
    courseDetail.simpleCourse = course;
    [self setContentViewController:[[UINavigationController alloc] initWithRootViewController:courseDetail] animated:YES];
    [self hideMenuViewController];
}

- (void)setModalView:(NSNotification *)aNotification {
    NSDictionary *dict = [aNotification userInfo];
    self.popupController = [dict objectForKey:ModalViewController];
    self.anim = [[dict objectForKey:ModalViewAnim] boolValue];
}

#pragma Override RESideMenu
- (void)hideMenuViewController {
    [super hideMenuViewController];
    self.contentViewController.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
}

#pragma mark RESideMenu Delegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    self.panGestureEnabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:SideRefresh object:nil];
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    self.panGestureEnabled = NO;
    [[SocketAgent sharedInstance] socketConnect];
}

@end
