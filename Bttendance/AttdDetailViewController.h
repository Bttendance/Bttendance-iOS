//
//  AttdDetailViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 6..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface AttdDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property(retain, nonatomic) Post *post;
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UIButton *detailBt;
@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) UILabel *messageLabel;

-(IBAction)showDetail:(id)sender;

@end
