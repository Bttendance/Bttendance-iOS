//
//  StdMainView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 26..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "SideMenuViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTColor.h"
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
#import "GuideCourseCreateViewController.h"
#import "GuideCourseAttendViewController.h"

@interface SideMenuViewController ()

@property (strong, nonatomic) UIViewController *popupController;

@end

@implementation SideMenuViewController

- (id)initByItSelf {
    
    UINavigationController *navigationController;
    
    if ([BTUserDefault getLastSeenCourse] == 0) {
        NoCourseViewController *noCourse = [[NoCourseViewController alloc] initWithNibName:@"NoCourseViewController" bundle:nil];
        navigationController = [[UINavigationController alloc] initWithRootViewController:noCourse];
    } else {
        NoCourseViewController *noCourse = [[NoCourseViewController alloc] initWithNibName:@"NoCourseViewController" bundle:nil];
        navigationController = [[UINavigationController alloc] initWithRootViewController:noCourse];
//        CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
//        courseDetail.simpleCourse = [[BTUserDefault getUser] getCourse:[BTUserDefault getLastSeenCourse]];
//        navigationController = [[UINavigationController alloc] initWithRootViewController:courseDetail];
    }
    
    LeftMenuViewController *leftMenuViewController = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
    self = [self initWithContentViewController:navigationController
                        leftMenuViewController:leftMenuViewController
                       rightMenuViewController:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.view.backgroundColor = [BTColor BT_white:1.0];
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [BTColor BT_black:1.0];
    self.contentViewShadowOpacity = 0.4;
    self.contentViewShadowRadius = 10;
    self.contentViewShadowEnabled = YES;
    self.contentViewScaleValue = 1.0;
    self.contentViewInPortraitOffsetCenterX = 110.0f;
    self.panGestureEnabled = NO;
    self.parallaxEnabled = NO;
    self.bouncesHorizontally = YES;
    self.menuPrefersStatusBarHidden = YES;
    self.delegate = self;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    [AttendanceAgent sharedInstance];
    
    [BTAPIs autoSignInInSuccess:^(User *user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SideRefresh object:nil];
    } failure:^(NSError *error) {
    }];
    
    [[SocketAgent sharedInstance] socketConnet];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCourse:) name:OpenCourse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPost:) name:OpenPost object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setModalView:) name:OpenModalView object:nil];
    
    if (![BTUserDefault getSeenGuide]) {
        GuidePageViewController *guidePage = [[GuidePageViewController alloc] initWithNibName:@"GuidePageViewController" bundle:nil];
        self.popupController = guidePage;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.popupController != nil) {
        if ([self.popupController isKindOfClass:[CourseCreateViewController class]]) {
            [self presentViewController:self.popupController animated:YES completion:nil];
        } else if ([self.popupController isKindOfClass:[CourseAttendViewController class]]) {
            [self presentViewController:self.popupController animated:YES completion:nil];
        } else
            [self presentViewController:self.popupController animated:NO completion:nil];
        self.popupController = nil;
    }
}

#pragma NSNotification
- (void)openCourse:(NSNotification *)aNotification {
    NSDictionary *dict = [aNotification userInfo];
    SimpleCourse *course = [dict objectForKey:SimpleCourseInfo];
    if (course == nil)
        return;
    
    CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
    courseDetail.simpleCourse = course;
    [self setContentViewController:[[UINavigationController alloc] initWithRootViewController:courseDetail]];
    [self hideMenuViewController];
}

- (void)openPost:(NSNotification *)aNotification {
//    NSDictionary *dict = [aNotification userInfo];
//    NSString *courseId = [dict objectForKey:CourseId];
//    SimpleCourse *course = [[BTUserDefault getUser] getCourse:[courseId integerValue]];
//    if (course == nil)
//        return;
//    
//    CourseDetailViewController *courseDetail = [[CourseDetailViewController alloc] initWithCoder:nil];
//    courseDetail.simpleCourse = course;
//    [self setContentViewController:[[UINavigationController alloc] initWithRootViewController:courseDetail]];
//    [self hideMenuViewController];
}

- (void)setModalView:(NSNotification *)aNotification {
    NSDictionary *dict = [aNotification userInfo];
    self.popupController = [dict objectForKey:ModalViewController];
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
}

@end
