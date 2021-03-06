//
//  BTAgent.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Post.h"

@interface AttendanceAgent : NSObject<UIAlertViewDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate> {
    
    CBMutableService *myservice;
    CBPeripheralManager *myPmanager;
    CBCentralManager *myCmanager;
    
    MCNearbyServiceBrowser *mMCBrowser;
    MCNearbyServiceAdvertiser *mMCAdvertiser;
    
    NSString *attdStartingCourseID;
    NSMutableArray *attdScanningAttendanceIDs;
}

+ (AttendanceAgent *)sharedInstance;

- (void)startAttendanceWithCourse:(NSString *)courseID
                    andCourseName:(NSString *)courseName
                          andType:(NSString *)type
                          success:(void (^)(Post *post))success
                          failure:(void (^)(NSError *error))failure;

- (void)startAttdScanWithCourseIDs:(NSArray *)courseIDs;
- (void)startAttdScanWithAttendanceIDs:(NSArray *)attendanceIDs;
- (void)alertForClassicBT;

@end
