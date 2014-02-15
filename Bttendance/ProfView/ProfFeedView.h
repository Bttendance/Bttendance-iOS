//
//  ProfFeedView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "CourseAttendView.h"
#import "CourseInfoCell.h"
#import "BttendanceColor.h"
#import "PostCell.h"
#import "ButtonCell.h"
#import "AppDelegate.h"
#import "CourseCreateController.h"
#import "AttdStatView.h"

@interface ProfFeedView : UIViewController<UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>{
    CBMutableService *myservice;
    CBPeripheralManager *myPmanager;
    CBCentralManager *myCmanager;
    CLLocationManager *locationmanager;
    
    NSDictionary *userinfo;
    
    NSMutableArray * data;
    
    NSString *pid;
    
    NSString *cid;
    
    NSString *my_id;
    
    PostCell *currentpostcell;
    
    CourseCell *currentcoursecell;
    
    NSInteger rowcount;
    
    int time;
    
    Boolean locationcheck;
    Boolean first_launch;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationbar;

-(void)showing_timer_postpfv:(PostCell *) cell;
-(void)change_check_postpfv:(NSTimer *)timer;
-(void)send_attendance_checkpfv:(id)sender;

@end
