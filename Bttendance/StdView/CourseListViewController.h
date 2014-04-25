//
//  StdCourseView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <socket.IO/SocketIO.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "User.h"

@interface CourseListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate, SocketIODelegate, UIActionSheetDelegate> {

    NSInteger rowcount1;
    NSInteger rowcount2;
    NSInteger sectionCount;

    NSArray *data;
    User *user;

    NSMutableArray *attdingPostIDs;
    NSString *attdStartingCid;

    CBMutableService *myservice;
    CBPeripheralManager *myPmanager;
    CBCentralManager *myCmanager;

    SocketIO *socketIO;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;

@end
