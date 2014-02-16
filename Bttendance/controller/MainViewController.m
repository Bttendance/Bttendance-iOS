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
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 7){
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }
    
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [navigationArray removeAllObjects];    // This is just for remove all view controller from navigation stack.
//    [navigationArray removeObjectAtIndex: 2];  // You can pass your index here
//    self.navigationController.viewControllers = navigationArray;
//    [navigationArray release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
