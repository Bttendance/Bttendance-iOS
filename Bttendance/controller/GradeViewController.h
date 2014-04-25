//
//  GradeView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCell.h"

@interface GradeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    __weak NSString *cid;

    NSString *Cid;

    __weak CourseCell *currentcell;

    NSArray *data;

    NSInteger rowcount;

}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) NSString *cid;
@property(weak, nonatomic) CourseCell *currentcell;

@end
