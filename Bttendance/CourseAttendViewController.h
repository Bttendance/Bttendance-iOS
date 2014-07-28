//
//  CourseAttendViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 25..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseAttendViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *code_index;
    NSDictionary *user_info;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end
