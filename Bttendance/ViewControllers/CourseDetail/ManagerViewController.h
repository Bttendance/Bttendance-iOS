//
//  ManagerViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 19..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    NSString *courseId;
    NSString *courseName;
    NSIndexPath *searchField;
    NSString *managerEmail;
    NSString *managerFullName;
}

@property(nonatomic) NSString *courseId;
@property(nonatomic) NSString *courseName;

@end
