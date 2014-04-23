//
//  StdCourseView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <socket.IO/SocketIO.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CourseListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate, SocketIODelegate, UIActionSheetDelegate> {

    NSInteger rowcount1;
    NSInteger rowcount2;
    NSInteger sectionCount;

    NSMutableArray *data;
    NSDictionary *userinfo;
    NSArray *supervisingCourses;
    NSArray *attendingCourses;

    NSMutableArray *attdingPostIDs;
    NSString *attdStartingCid;

    CBMutableService *myservice;
    CBPeripheralManager *myPmanager;
    CBCentralManager *myCmanager;

    SocketIO *socketIO;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@end
