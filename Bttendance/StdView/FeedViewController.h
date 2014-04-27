//
//  StdFeedView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    NSArray *data;

    NSString *pid;
    NSString *cid;

    NSInteger rowcount;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@end
