//
//  SocketAgent.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 5. 6..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SocketAgent.h"
#import "SocketIOPacket.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import "BTNotification.h"

@implementation SocketAgent

+ (SocketAgent *)sharedInstance {
    static SocketAgent *agent;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[SocketAgent alloc]init];
    });
    
    return agent;
}

- (id)init {
    self = [super init];
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    clickerConnectingIDs = [[NSMutableArray alloc] init];
    return self;
}

#pragma Socket.id
- (void)socketConnet {
    if (!socketIO.isConnecting)
        [socketIO connectToHost:BTSOCKET onPort:0];
}

- (void)connetWithClicker:(NSString *) clickerID {
    if (socketIO.isConnected) {
        [BTAPIs connectWithClicker:clickerID
                            socket:socketID
                           success:^(Clicker *clicker) {
                               
                           } failure:^(NSError *error) {
                           }];
    } else {
        [clickerConnectingIDs addObject:clickerID];
        [self socketConnet];
    }
}

#pragma Socket.io Delegate
- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connected to %@", socket.host);
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Disconnected : %@", socket.host);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    id data = [packet dataAsJSON];
    NSLog(@"didReceiveEvent : %@", data);
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"onConnect"]) {
        socketID = [[data objectForKey:@"args"][0] objectForKey:@"socketID"];
        for (int i = (int)clickerConnectingIDs.count - 1; i >=0; i--) {
            [self connetWithClicker:clickerConnectingIDs[i]];
            [clickerConnectingIDs removeObjectAtIndex:i];
        }
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"clickers"]) {
        Clicker *clicker = [[Clicker alloc] initWithDictionary:[[data objectForKey:@"args"][0] objectForKey:@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:ClickerUpdated object:clicker];
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    NSLog(@"didReceiveJSON : %@", [packet dataAsJSON]);
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"didReceiveMessage : %@", [packet dataAsJSON]);
}

@end
