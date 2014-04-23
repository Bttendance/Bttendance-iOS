//
//  StdProfileEmailEditView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 22..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileEmailEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

    __weak NSString *email;

    NSDictionary *userinfo;
}

@property(weak, nonatomic) NSString *email;
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong, nonatomic) IBOutlet UITextField *email_field;

- (void)save_email;

@end
