//
//  ManagerViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate> {
    NSInteger courseId;
    NSString *courseName;
    NSIndexPath *searchField;
    NSString *managerName;
    NSString *managerFullName;
}

@property(nonatomic) NSInteger courseId;
@property(nonatomic) NSString *courseName;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end
