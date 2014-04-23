//
//  SignInController.h
//  Bttendance
//
//  Created by HAJE on 2013. 11. 19..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {

    NSIndexPath *username_index, *password_index;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) NSDictionary *user_info;

@end
