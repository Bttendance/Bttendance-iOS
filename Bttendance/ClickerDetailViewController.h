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

@interface ClickerDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    XYPieChart *chart;
}

@property(retain, nonatomic) Post *post;
@property(weak, atomic) IBOutlet UITableView *tableview;

@end
