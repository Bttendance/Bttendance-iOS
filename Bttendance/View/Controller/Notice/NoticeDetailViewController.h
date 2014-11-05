//
//  NoticeDetailViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;

@interface NoticeDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property(retain, nonatomic) Post *post;
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UIButton *detailBt;

-(IBAction)showDetail:(id)sender;

@end
