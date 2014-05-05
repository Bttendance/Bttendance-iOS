//
//  StdCourseView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface CoursesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    
    NSInteger rowcount1;
    NSInteger rowcount2;
    NSInteger sectionCount;

    NSArray *data;
    User *user;
    
    NSTimer *refreshTimer;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UIView *noCourseView;

@end
