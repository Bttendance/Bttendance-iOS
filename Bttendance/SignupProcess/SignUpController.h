//
//  SignUpController.h
//  Bttendance
//
//  Created by HAJE on 2013. 11. 19..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "CustomCell.h"
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "NIAttributedLabel.h"
#import "WebViewController.h"
#import "CatchPointController.h"


@interface SignUpController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate, NIAttributedLabelDelegate>{
    NSIndexPath *fullname_index, *email_index, *username_index, *password_index;
    NSDictionary *user_info;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger schoolId;
@property (nonatomic) NSString *serial;

@end
