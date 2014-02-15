//
//  StdProfileView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileHeaderView.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BttendanceColor.h"
#import "ProfileNameEditViewController.h"
#import "ProfileEmailEditViewController.h"
#import "ProfileCell.h"
#import "ButtonCell.h"
#import "SchoolChooseView.h"
#import "SchoolInfoCell.h"
#import "BTAPIs.h"

@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSUInteger rowcount;
    NSUInteger rowcount1;
    NSUInteger rowcount2;
    
    NSDictionary *userinfo;
    
    NSMutableArray *data;
    NSMutableArray *alluserschools;
    NSMutableArray *employedschoollist;
    NSMutableArray *enrolledschoollist;
    
    __strong NSString *fullname;
    __strong NSString *email;
    
    Boolean first;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationbar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSString *fullname;
@property (strong, nonatomic) NSString *email;

-(void)move_to_add;

@end
