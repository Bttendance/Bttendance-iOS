//
//  StdFeedView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BTColor.h"
#import "PostCell.h"
#import "AppDelegate.h"
#import "AttdStatViewController.h"
#import "BTAPIs.h"
#import "BTDateFormatter.h"

@interface FeedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    NSDictionary *userinfo;
    NSMutableArray * data;
    
    NSString *pid;
    NSString *cid;
    NSString *my_id;
    
    NSInteger rowcount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
