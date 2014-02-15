//
//  ViewController.h
//  Bttendance
//
//  Created by HAJE on 2013. 11. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customCell.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSIndexPath *fullname_index;
    NSIndexPath *email_index;
    NSIndexPath *username_index;
    NSIndexPath *password_index;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
