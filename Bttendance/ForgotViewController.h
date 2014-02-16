//
//  ForgotViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "CustomCell.h"
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"

@interface ForgotViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath *email_index;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
