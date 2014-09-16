//
//  StudentListViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface StudentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *data;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong, nonatomic) Course *course;

@end
