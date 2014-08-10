//
//  AttdDetailListViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface AttdDetailListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *data;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UISegmentedControl *segmentcontrol;
@property(weak, nonatomic) IBOutlet UIButton *left;
@property(weak, nonatomic) IBOutlet UIButton *center;
@property(weak, nonatomic) IBOutlet UIButton *right;

- (IBAction)left:(id)sender;
- (IBAction)center:(id)sender;
- (IBAction)right:(id)sender;

@property(strong, nonatomic) Post *post;

@end
