//
//  BTAgent.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <socket.IO/SocketIO.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BTAgent : NSObject<UIAlertViewDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, SocketIODelegate> {
    
    CBMutableService *myservice;
    CBPeripheralManager *myPmanager;
    CBCentralManager *myCmanager;
    
    MCNearbyServiceBrowser *mMCBrowser;
    MCNearbyServiceAdvertiser *mMCAdvertiser;
    
    SocketIO *socketIO;
    
    NSString *attdStartingCourseID;
    NSMutableArray *attdScanningAttendanceIDs;
}

+ (BTAgent *)sharedInstance;
- (void)startAttdWithCourseName:(NSString *)courseName andID:(NSString *)courseID;
- (void)startAttdScanWithCourseIDs:(NSArray *)courseIDs;
- (void)startAttdScanWithAttendanceIDs:(NSArray *)attendanceIDs;

@end
