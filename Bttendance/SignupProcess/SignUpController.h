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
#import "MainViewController.h"
#import "ProfMainView.h"
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "NIAttributedLabel.h"


@interface SignUpController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath *fullname_index, *email_index, *username_index, *password_index;
    NSDictionary *user_info;
}


//@property (retain, nonatomic) IBOutlet UINavigationItem *navigation;

@property (strong, nonatomic) IBOutlet UIButton *SignUp;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)SignUnButton:(id)sender;

-(void)JSONSignupRequest:(NSString *)username :(NSString *)email :(NSString *)fullname :(NSString *)password;

@end
