//
//  StdCourseDetailView.h
//  Bttendance
//
//  Created by HAJE on 2014. 1. 24..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    __weak CourseCell *currentcell;

    NSDictionary *userinfo;
    NSInteger rowcount;
    NSMutableArray *data;

    NSString *my_id;
    Boolean auth;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@property(weak, nonatomic) CourseCell *currentcell;
@property(nonatomic) Boolean auth;

@end
