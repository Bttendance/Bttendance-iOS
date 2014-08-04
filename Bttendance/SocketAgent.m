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
    return self;
}

#pragma Socket.id
- (void)socketConnect {
    if (!socketIO.isConnecting)
        [socketIO connectToHost:BTSOCKET onPort:0];
}

#pragma Socket.io Delegate
- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connected to %@", socket.host);
    
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *url = [NSString stringWithFormat:@"/api/sockets/connect?email=%@&password=%@&locale=%@",
                     [BTUserDefault getEmail],
                     [BTUserDefault getPassword],
                     locale];
    NSDictionary *params = @{@"url" : url};
    [socket sendEvent:@"put" withData:params];
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Disconnected : %@", socket.host);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    id data = [packet dataAsJSON];
    NSLog(@"didReceiveEvent : %@", data);
    NSLog(@"name : %@", [[packet dataAsJSON] objectForKey:@"name"]);
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"onConnect"]) {
        socketID = [[data objectForKey:@"args"][0] objectForKey:@"socketID"];
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"clicker"]) {
        Clicker *clicker = [[Clicker alloc] initWithDictionary:[data objectForKey:@"args"][0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:ClickerUpdated object:clicker];
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"attendance"]) {
        Attendance *attendance = [[Attendance alloc] initWithDictionary:[data objectForKey:@"args"][0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:AttendanceUpdated object:attendance];
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"notice"]) {
        Notice *notice = [[Notice alloc] initWithDictionary:[data objectForKey:@"args"][0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NoticeUpdated object:notice];
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    NSLog(@"didReceiveJSON : %@", [packet dataAsJSON]);
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"didReceiveMessage : %@", [packet dataAsJSON]);
}

@end
