//
//  BTAgent.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTAgent.h"
#import "BTAPIs.h"
#import "BTUUID.h"
#import "SocketIOPacket.h"
#import "BTUserDefault.h"

@implementation BTAgent

+ (BTAgent *)sharedInstance {
    static BTAgent *agent;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[BTAgent alloc]init];
    });
    
    return agent;
}

- (id)init {
    self = [super init];
    myservice = [BTUUID getUserService];
    myCmanager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    [myPmanager addService:myservice];
    
    NSString *myUUID = [BTUserDefault getUUID];
    MCPeerID *mMCPeerID = [[MCPeerID alloc] initWithDisplayName:myUUID];
    mMCBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:mMCPeerID serviceType:@"Bttendance"];
    mMCAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:mMCPeerID
                                                      discoveryInfo:@{@"peerid": [mMCPeerID displayName]}
                                                        serviceType:@"Bttendance"];
    mMCBrowser.delegate = self;
    mMCAdvertiser.delegate = self;
    
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    //        [socketIO connectToHost:@"bttendance-dev.herokuapp.com" onPort:0];
    //        [socketIO connectToHost:@"localhost" onPort:1337 withParams:params withNamespace:@"api/clickers/click"];
//    [socketIO connectToHost:@"localhost" onPort:1337];
    
    attdStartingCourseID = @"";
    attdScanningAttendanceIDs = [[NSMutableArray alloc] init];
    return self;
}

#pragma Attendance Start Actions
- (void)startAttdWithCourseName:(NSString *)courseName andID:(NSString *)courseID {
    attdStartingCourseID = [NSString stringWithFormat:@"%@", courseID];
    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: //power-on
            alert = [[UIAlertView alloc] initWithTitle:courseName
                                               message:@"Do you want to start attendance check?"
                                              delegate:self
                                     cancelButtonTitle:@"Confrim"
                                     otherButtonTitles:@"Cancel", nil];
            alert.tag = 200;
            break;
        case CBCentralManagerStatePoweredOff: //powered off
            alert = [[UIAlertView alloc] initWithTitle:@"Turn On Bluetooth"
                                               message:@"Your bluetooth is powered off. Before start Attedance check turn your bluetooth on."
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil, nil];
            alert.tag = 400;
            break;
        case CBCentralManagerStateUnknown: //Unknown state
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        default: //default
            alert = [[UIAlertView alloc] initWithTitle:@"Device Unsupported"
                                               message:@"Your device doesn't support proper bluetooth version."
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil, nil];
            break;
    }
    [alert show];
}

- (void)startAttdCheckWithCourse {
    [BTAPIs startAttendanceWithCourse:attdStartingCourseID
                              success:^(Post *post) {
                              } failure:^(NSError *error) {
                              }];
}

#pragma Attendance Scan Courses Actions
- (void)startAttdScanWithCourseIDs:(NSArray *)courseIDs {
    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: //power-on
            myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
            [self checkAttdWithCourseIDs:courseIDs];
            break;
        case CBCentralManagerStatePoweredOff: //powered off
            alert = [[UIAlertView alloc] initWithTitle:@"Turn On Bluetooth"
                                               message:@"Your bluetooth is powered off. Currently, attedance check is in progress. Please turn your bluetooth on."
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil, nil];
            alert.tag = 400;
            [alert show];
            break;
        case CBCentralManagerStateUnknown: //Unknown state
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        default: //default
            alert = [[UIAlertView alloc] initWithTitle:@"Check Bluetooth Status"
                                               message:@"Go to Setting -> Bluetooth and turn on bluetooth."
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil, nil];
            alert.tag = 500;
            [alert show];
            break;
    }
}

- (void)checkAttdWithCourseIDs:(NSArray *)courseIDs {
    [BTAPIs fromCoursesWithCourses:courseIDs
                           success:^(NSArray *attendanceIDs) {
                               NSMutableArray *array = [[NSMutableArray alloc] init];
                               for (int i = 0; i < attendanceIDs.count; i++)
                                   [array addObject:[NSString stringWithFormat:@"%@", attendanceIDs[i]]];
                               [self checkAttdWithAttendanceIDs:array];
                           } failure:^(NSError *error) {
                           }];
}

#pragma Attendance Scan Feed Actions
- (void)startAttdScanWithAttendanceIDs:(NSArray *)attendanceIDs {
    UIAlertView *alert;
    switch ([myCmanager state]) {
        case CBCentralManagerStatePoweredOn: //power-on
            myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
            [self checkAttdWithAttendanceIDs:attendanceIDs];
            break;
        case CBCentralManagerStatePoweredOff: //powered off
            alert = [[UIAlertView alloc] initWithTitle:@"Turn On Bluetooth"
                                               message:@"Your bluetooth is powered off. Currently, attedance check is in progress. Please turn your bluetooth on."
                                              delegate:self
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil, nil];
            alert.tag = 400;
            [alert show];
            break;
        case CBCentralManagerStateUnknown: //Unknown state
        case CBCentralManagerStateUnsupported: //Bluetooth Low Energy not supported
        case CBCentralManagerStateUnauthorized: //Bluetooth Low Energy not authorized
        default: //default
            break;
    }
}

- (void)checkAttdWithAttendanceIDs:(NSArray *)attendanceIDs {
    BOOL refresh = NO;
    for (int i = 0; i < attendanceIDs.count; i++) {
        BOOL contain = NO;
        for (int j = 0; j < attdScanningAttendanceIDs.count; j++)
            if ([attdScanningAttendanceIDs[j] isEqualToString:attendanceIDs[i]])
                contain = YES;
        if (!contain)
            refresh = YES;
    }
    
    if (refresh) {
        [attdScanningAttendanceIDs removeAllObjects];
        for (id ID in attendanceIDs)
            [attdScanningAttendanceIDs addObject:ID];
        [myCmanager scanForPeripheralsWithServices:nil options:nil];
        [mMCAdvertiser stopAdvertisingPeer];
        [mMCBrowser stopBrowsingForPeers];
        [mMCAdvertiser startAdvertisingPeer];
        [mMCBrowser startBrowsingForPeers];
    }
}


#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 200 && buttonIndex == 0)
        [self startAttdCheckWithCourse];
    
    if (alertView.tag == 400)
        myPmanager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    if (alertView.tag == 500) {
        [mMCAdvertiser stopAdvertisingPeer];
        [mMCBrowser stopBrowsingForPeers];
        [mMCAdvertiser startAdvertisingPeer];
        [mMCBrowser startBrowsingForPeers];
    }
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *uuid = [BTUUID representativeString:[[advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0]];
    NSLog(@"Found %@", uuid);
    
    for (int i = 0; i < attdScanningAttendanceIDs.count; i++) {
        [BTAPIs foundDeviceWithAttendance:[NSString stringWithFormat:@"%@", attdScanningAttendanceIDs[i]]
                                     uuid:uuid
                                  success:^(Attendance *attendance) {
                                  } failure:^(NSError *error) {
                                  }];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSString *state = nil;
    switch ([central state]) {
        case CBCentralManagerStateUnsupported:
            state = @"The platform hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            [myCmanager scanForPeripheralsWithServices:nil options:nil];
            [mMCAdvertiser stopAdvertisingPeer];
            [mMCBrowser stopBrowsingForPeers];
            [mMCAdvertiser startAdvertisingPeer];
            [mMCBrowser startBrowsingForPeers];
            state = @"power-on";
            break;
        case CBCentralManagerStateUnknown:
            state = @"Unknown state";
            break;
        default:
            state = @"default";
            break;
    }
    NSLog(@"Central STATE : %@", state);
}

#pragma mark - CBPeripheralDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSString *state = nil;
    switch ([peripheral state]) {
        case CBPeripheralManagerStateUnsupported:
            state = @"The platform hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBPeripheralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBPeripheralManagerStatePoweredOn:
            [myPmanager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[myservice.UUID]}];
            [mMCAdvertiser stopAdvertisingPeer];
            [mMCBrowser stopBrowsingForPeers];
            [mMCAdvertiser startAdvertisingPeer];
            [mMCBrowser startBrowsingForPeers];
            state = @"power-on";
            break;
        case CBPeripheralManagerStateUnknown:
            state = @"Unknown state";
            break;
        default:
            state = @"default";
            break;
    }
    NSLog(@"Peripheral STATE : %@", state);
}


#pragma MCNearbyServiceBrowserDelegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info{
    NSString *uuid = [peerID displayName];
    NSLog(@"Found %@", uuid);
    
    for (int i = 0; i < attdScanningAttendanceIDs.count; i++) {
        [BTAPIs foundDeviceWithAttendance:[NSString stringWithFormat:@"%@", attdScanningAttendanceIDs[i]]
                                     uuid:uuid
                                  success:^(Attendance *attendance) {
                                  } failure:^(NSError *error) {
                                  }];
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID{
}

#pragma MCNearbyServiceAdvertiserDelegate
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler{
}

#pragma Socket.io
- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connected to %@", socket.host);
    [socket sendMessage:@"Hello"];
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Disconnected : %@", socket.host);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    NSLog(@"didReceiveEvent : %@", [packet dataAsJSON]);
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"onConnect"]) {
        
//        AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
//        [AFmanager POST:@"http://localhost:1337/api/clickers/connect" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"responseObject : %@", responseObject);
//        }       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"clickers"]) {
        NSLog(@"clickers : %@", [[[packet dataAsJSON] objectForKey:@"args"][0] objectForKey:@"data"]);
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    NSLog(@"didReceiveJSON : %@", packet);
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"didReceiveMessage : %@", packet);
}

@end
