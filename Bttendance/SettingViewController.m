//
//  SettingViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SettingViewController.h"
#import "BTColor.h"
#import "User.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import <AFNetworking/AFNetworking.h>
#import "BTNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SettingViewController ()

@property(strong, nonatomic) User *user;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [BTUserDefault getUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Setting", nil);
    [titlelabel sizeToFit];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.barTintColor = [BTColor BT_navy:1];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Menu", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
}

@end
