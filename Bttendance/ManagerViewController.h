//
//  ManagerViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate> {
    NSString *courseId;
    NSString *courseName;
    NSIndexPath *searchField;
    NSString *managerEmail;
    NSString *managerFullName;
}

@property(nonatomic) NSString *courseId;
@property(nonatomic) NSString *courseName;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end
