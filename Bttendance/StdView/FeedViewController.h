//
//  StdFeedView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface FeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {

    NSArray *data;
    User *user;

    NSString *pid;
    NSString *cid;

    NSInteger rowcount;
    NSTimer *refreshTimer;
    
    NSTimeInterval lastScroll;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@end
