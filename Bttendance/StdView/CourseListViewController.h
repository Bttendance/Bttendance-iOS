//
//  StdCourseView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BTColor.h"
#import "ButtonCell.h"
#import "CourseCell.h"
#import "CourseAttendView.h"
#import "CourseDetailViewController.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "SchoolChooseView.h"
#import "BTDateFormatter.h"

@interface CourseListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate>{
    
    NSInteger rowcount1;
    NSInteger rowcount2;
    
    NSMutableArray *data;
    NSDictionary *userinfo;
    NSArray *supervisingCourses;
    NSArray *attendingCourses;
    
    NSMutableArray *attdingPostIDs;
    NSString *attdStartingCid;
    
    CBMutableService *myservice;
    CBPeripheralManager *myPmanager;
    CBCentralManager *myCmanager;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
