//
//  StdProfileView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "ClickerOptionViewController.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ClickerOptionViewControllerDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@end
