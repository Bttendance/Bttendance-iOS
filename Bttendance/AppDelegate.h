//
//  AppDelegate.h
//  Bttendance
//
//  Created by H AJE on 2013. 11. 7..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FeedViewController.h"
#import "CourseListViewController.h"
#import "ProfileViewController.h"
#import "MainViewController.h"
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIViewController *firstview;
}

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
