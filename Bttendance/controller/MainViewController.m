//
//  StdMainView.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 26..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view addSubview:tbc.view];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 7){
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UITabBarItem *item0 = [tbc.tabBar.items objectAtIndex:0];
    item0.image = [UIImage imageNamed:@"iostabbari0"];
    item0.selectedImage = [UIImage imageNamed:@"iostabbara0"];
    
    UITabBarItem *item1 = [tbc.tabBar.items objectAtIndex:1];
    item1.image = [UIImage imageNamed:@"iostabbari1"];
    item1.selectedImage = [UIImage imageNamed:@"iostabbara1"];
    
    UITabBarItem *item2 = [tbc.tabBar.items objectAtIndex:2];
    item2.image = [UIImage imageNamed:@"iostabbari2"];
    item2.selectedImage = [UIImage imageNamed:@"iostabbara2"];
    
    tbc.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
