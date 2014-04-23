//
//  Serial_Input.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 1..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerialViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSString *type;
    NSIndexPath *serialcode;

    Boolean isSignUp;
    NSInteger schoolId;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) Boolean isSignUp;
@property(nonatomic) NSInteger schoolId;
@property(nonatomic) NSString *schoolName;

@end
