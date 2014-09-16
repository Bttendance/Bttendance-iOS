//
//  GradeView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *data;
    NSInteger rowcount;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) NSString *cid;
@property(weak, nonatomic) NSString *type;

@end
