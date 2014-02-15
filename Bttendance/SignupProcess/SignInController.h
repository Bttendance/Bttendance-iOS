//
//  SignInController.h
//  Bttendance
//
//  Created by HAJE on 2013. 11. 19..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "customCell.h"
#import "MainViewController.h"
#import "ProfMainView.h"
#import "SignButtonCell.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"

@interface SignInController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
//    IBOutlet UITextField *usernameField;
//    IBOutlet UITextField *passwordField;
    
    NSIndexPath *username_index, *password_index;
}



@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) NSDictionary *user_info;

-(IBAction)signinButton:(id)sender;

-(void)JSONSigninRequest:(NSString *) username :(NSString *) password;


@end
