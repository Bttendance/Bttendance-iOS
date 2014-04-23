//
//  GradeView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 28..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCell.h"

@interface GradeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *userinfo;

    __weak NSString *cid;

    NSString *Cid;

    __weak CourseCell *currentcell;

    NSMutableArray *data;

    NSInteger rowcount;

}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) NSString *cid;
@property(weak, nonatomic) CourseCell *currentcell;

@end
