
//  AppDelegate.m
//  Bttendance
//
//  Created by H AJE on 2013. 11. 7..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Crashlytics/Crashlytics.h>

#import "UIColor+Bttendance.h"
#import "BTAPIs.h"
#import "PushNoti.h"
#import "BTNotification.h"
#import "BTUserDefault.h"
#import "BTDatabase.h"
#import "AttendanceAgent.h"
#import "SocketAgent.h"

#import "SideMenuViewController.h"
#import "CatchPointViewController.h"

#import "Attendance.h"
#import "Post.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Crashlytics
    [Crashlytics startWithAPIKey:@"933280081941175a775ecfe701fefa562b7f8a01"];
    
    //StatusBar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //UINavigationBar
    [[UINavigationBar appearance] setBarTintColor:[UIColor navy:1.0]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    //UIBarButton
    NSDictionary* barButtonItemAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                              NSForegroundColorAttributeName: [UIColor white:1.0]};
    [[UIBarButtonItem appearanceWhenContainedIn: [UINavigationController class], nil] setTitleTextAttributes:barButtonItemAttributes
                                                                                                    forState:UIControlStateNormal];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [BTUserDefault migrate];
    
    if([BTUserDefault getEmail] == nil || [BTUserDefault getPassword] == nil) {
        [BTUserDefault clear];
        CatchPointViewController *catchview = [[CatchPointViewController alloc] initWithNibName:@"CatchPointViewController" bundle:nil];
        self.topController = catchview;
        UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:catchview];
        navcontroller.navigationBarHidden = YES;
        self.window.rootViewController = navcontroller;
    } else {
        SideMenuViewController *sideview = [[SideMenuViewController alloc] initByItSelf];
        self.topController = sideview;
        self.window.rootViewController = sideview;
    }
    
    [self.window makeKeyAndVisible];
  
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=7){
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
        application.applicationIconBadgeNumber = 0;
    }
    
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSDictionary *dictionary = @{@"type":@"attendance"};
    for (int i = 0; i < 100; i ++)
        [Post alloc];
//        [[Post alloc] initWithObject:dictionary];
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    
    return YES;
}

#pragma RemoteNotification
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"fail to register remote notification, %@", error);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSMutableString *deviceId= [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*)[deviceToken bytes];
    for(int i =0; i < 32; i++)
        [deviceId appendFormat:@"%02x", ptr[i]];
    NSString *device_token = [NSString stringWithString:deviceId];
    [BTAPIs updateNotificationKey:device_token
                          success:^(User *user) {
                          } failure:^(NSError *error) {
                          }];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    User *user = [BTDatabase getUser];
    if(user == nil
       || user.email == nil
       || user.password == nil)
        return;
    
    if (application.applicationState == UIApplicationStateActive
        || application.applicationState == UIApplicationStateBackground)
        AudioServicesPlaySystemSound(1007);
    
    PushNoti *noti = [[PushNoti alloc] initWithObject:userInfo];
    switch ([noti getPushNotiType]) {
        case PushNotiType_Attendance_Will_Start:
            break;
        case PushNotiType_Attendance_Started: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            [[AttendanceAgent sharedInstance] startAttdScanWithCourseIDs:[NSArray arrayWithObject:noti.courseID]];
            [[AttendanceAgent sharedInstance] alertForClassicBT];
            
            SimpleCourse *course = [user getCourse:[noti.courseID integerValue]];
            if(course == nil || [user supervising:course.id])
                return;
            
            if (application.applicationState == UIApplicationStateInactive) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                return;
            }
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:course.name
                                               message:noti.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = course.id;
            [alert show];
            break;
        }
        case PushNotiType_Attendance_On_Going: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            [[AttendanceAgent sharedInstance] startAttdScanWithCourseIDs:[NSArray arrayWithObject:noti.courseID]];
            [[AttendanceAgent sharedInstance] alertForClassicBT];
            break;
        }
        case PushNotiType_Attendance_Checked: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            SimpleCourse *course = [user getCourse:[noti.courseID integerValue]];
            if(course == nil || [user supervising:course.id])
                return;
            
            if (application.applicationState == UIApplicationStateInactive) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                return;
            }
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:course.name
                                               message:noti.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = 0;
            [alert show];
            break;
        }
        case PushNotiType_Clicker_Started: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            SimpleCourse *course = [user getCourse:[noti.courseID integerValue]];
            if(course == nil || [user supervising:course.id])
                return;
            
            if (application.applicationState == UIApplicationStateInactive) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                return;
            }
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:course.name
                                               message:noti.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = course.id;
            [alert show];
            break;
        }
        case PushNotiType_Clicker_On_Going: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            break;
        }
        case PushNotiType_Notice_Created: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FeedRefresh object:nil];
            
            SimpleCourse *course = [user getCourse:[noti.courseID integerValue]];
            if(course == nil || [user supervising:course.id])
                return;
            
            if (application.applicationState == UIApplicationStateInactive) {
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                return;
            }
            
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:course.name
                                               message:noti.message
                                              delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            alert.tag = course.id;
            [alert show];
            break;
        }
        case PushNotiType_Notice_Updated:
            break;
        case PushNotiType_Curious_Commented:
            break;
        case PushNotiType_Added_As_Manager: {
            [BTAPIs autoSignInInSuccess:^(User *user) {
                
                SimpleCourse *course = [user getCourse:[noti.courseID integerValue]];
                if(course == nil)
                    return;
                
                if (application.applicationState == UIApplicationStateInactive) {
                    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
                    return;
                }
                
                [[SocketAgent sharedInstance] socketConnectToServer];
                
                UIAlertView *alert;
                alert = [[UIAlertView alloc] initWithTitle:course.name
                                                   message:noti.message
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                alert.tag = course.id;
                [alert show];
                
            } failure:^(NSError *error) {
            }];
            break;
        }
        case PushNotiType_Course_Created:
            break;
        case PushNotiType_Etc:
        default:
            break;
    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
        return;

    SimpleCourse *course = [[BTDatabase getUser] getCourse:alertView.tag];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:course, SimpleCourseInfo, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenCourse object:nil userInfo:data];
}

#pragma StatusBar
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {

}

@end
