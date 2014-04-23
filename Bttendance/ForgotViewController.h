//
//  ForgotViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *email_index;
}

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end
