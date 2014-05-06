//
//  StdMainView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 26..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "MainViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTColor.h"
#import "BTUserDefault.h"
#import "BTAPIs.h"
#import "BTNotification.h"
#import "AttendanceAgent.h"
#import "SocketAgent.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view addSubview:tabBarController.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7) {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                                        NSForegroundColorAttributeName : [BTColor BT_navy:1]
                                                        } forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                                        NSForegroundColorAttributeName : [BTColor BT_silver:1]
                                                        } forState:UIControlStateNormal];
    
    [[UITabBar appearance] setTintColor:[BTColor BT_navy:1]];
    [[UITabBar appearance] setBarTintColor:[BTColor BT_black:1]];

    UITabBarItem *item0 = [tabBarController.tabBar.items objectAtIndex:0];
    item0.image = [[UIImage imageNamed:@"iostabbari0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.selectedImage = [[UIImage imageNamed:@"iostabbara0"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *item1 = [tabBarController.tabBar.items objectAtIndex:1];
    item1.image = [[UIImage imageNamed:@"iostabbari1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"iostabbara1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UITabBarItem *item2 = [tabBarController.tabBar.items objectAtIndex:2];
    item2.image = [[UIImage imageNamed:@"iostabbari2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"iostabbara2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    tabBarController.selectedIndex = 1;

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    
    id barButtonAppearance = [UIBarButtonItem appearance];
    NSDictionary *barButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0f], NSFontAttributeName, nil];
    [barButtonAppearance setTitleTextAttributes:barButtonTextAttributes
                                       forState:UIControlStateNormal];
    [barButtonAppearance setTitleTextAttributes:barButtonTextAttributes
                                       forState:UIControlStateHighlighted];
    
    [AttendanceAgent sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [BTAPIs autoSignInInSuccess:^(User *user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserUpdated object:nil];
    } failure:^(NSError *error) {
    }];
    
    [[SocketAgent sharedInstance] socketConnet];
}

@end
