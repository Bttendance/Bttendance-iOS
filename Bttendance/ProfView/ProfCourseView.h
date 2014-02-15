//
//  ProfCourseView.h
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
#import "ProfCourseDetailView.h"
#import "CourseCreateController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ProfCourseView : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>{
    
    NSUInteger rowcount;
    
    NSMutableArray *data;
    
    NSDictionary *userinfo;
    
    CourseCell *currentcell;

    NSString *pid;
    
    NSString *cid;
    
    CBMutableService *myservice;
    CBPeripheralManager *myPmanager;
    CBCentralManager *myCmanager;
    
    int time;
    
    

}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

-(void)move_to_addpcv:(id)sender;
-(void)send_push1:(id)sender;

@end
