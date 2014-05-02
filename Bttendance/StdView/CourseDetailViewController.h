//
//  StdCourseDetailView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCell.h"

@interface CourseDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    __weak CourseCell *currentcell;

    NSInteger rowcount;
    NSArray *data;

    NSString *my_id;
    Boolean auth;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@property(weak, nonatomic) CourseCell *currentcell;
@property(nonatomic) Boolean auth;

@end
