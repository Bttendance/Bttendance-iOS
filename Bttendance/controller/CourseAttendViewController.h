//
//  CourseView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseInfoCell.h"

@interface CourseAttendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    
    NSUInteger rowcount0;
    NSUInteger rowcount1;

    NSMutableArray *data0;
    NSMutableArray *data1;

    CourseInfoCell *currentcell;

    NSInteger sid;
    NSString *sname;
}
@property(weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic) NSInteger sid;
@property(nonatomic) NSString *sname;

- (IBAction)check_button_action:(id)sender;

@end