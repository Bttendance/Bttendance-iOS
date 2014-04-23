//
//  CourseView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseInfoCell.h"

@interface CourseAttendView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    NSUInteger rowcount0;
    //for section 0
    NSUInteger rowcount1;//for section 1

    NSMutableArray *data0;
    NSMutableArray *data1;

    NSDictionary *userinfo;

    CourseInfoCell *currentcell;

    int sid;
    NSString *sname;

}
@property(weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic) int sid;
@property(nonatomic) NSString *sname;

- (IBAction)check_button_action:(id)sender;

@end