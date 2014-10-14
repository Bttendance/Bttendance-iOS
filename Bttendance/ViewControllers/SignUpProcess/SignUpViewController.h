//
//  SignUpController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate> {
    NSIndexPath *fullname_index, *email_index, *password_index;
    NSDictionary *user_info;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSInteger schoolId;
@property(nonatomic) NSString *serial;

@end
