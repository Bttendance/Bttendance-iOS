//
//  SignInController.h
//  Bttendance
//
//  Created by HAJE on 2013. 11. 19..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "CustomCell.h"
#import "MainViewController.h"
#import "SignButtonCell.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "ForgotViewController.h"

@interface SignInController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    NSIndexPath *username_index, *password_index;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) NSDictionary *user_info;

@end
