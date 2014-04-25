//
//  CourseView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoCell.h"

@interface AttdStatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    NSUInteger rowcount0;
    NSUInteger rowcount1;

    NSMutableArray *data0;
    NSMutableArray *data1;

    UserInfoCell *currentcell;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@property(assign, nonatomic) NSInteger postId;
@property(assign, nonatomic) NSInteger courseId;
@property(assign, nonatomic) NSString *courseName;

- (IBAction)check_button_action:(id)sender;

@end
