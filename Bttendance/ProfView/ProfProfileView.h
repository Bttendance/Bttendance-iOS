//
//  ProfProfileView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfProfileHeaderView.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BttendanceColor.h"
#import "ProfProfileNameEditView.h"
#import "ProfProfileEmailEditView.h"
#import "ProfileCell.h"
#import "ButtonCell.h"
#import "SchoolChooseView.h"
#import "SchoolInfoCell.h"
#import "NoticeView.h"

@interface ProfProfileView : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSUInteger rowcount;
    NSDictionary *userinfo;
    
    NSMutableArray *data;
    
    __strong NSString *fullname;
    __strong NSString *email;
    
    Boolean first;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationbar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSString *fullname;
@property (strong, nonatomic) NSString *email;

-(void)move_to_addppv;

@end
