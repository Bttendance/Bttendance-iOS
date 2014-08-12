//
//  ClickerDetailViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Clicker.h"
#import "Post.h"

@interface ClickerDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property(strong, nonatomic) XYPieChart *chart;
@property(strong, nonatomic) Post *post;
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UIButton *detailBt;
@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) UILabel *messageLabel;

-(IBAction)showDetail:(id)sender;

@end
