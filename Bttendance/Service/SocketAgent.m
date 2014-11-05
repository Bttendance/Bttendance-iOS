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
#import "BTDatabase.h"
#import "Attendance.h"
#import "Clicker.h"
#import "Notice.h"
#import "Curious.h"
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
    reconnectTry = 0;
    return self;
}

#pragma Socket.id
- (void)socketConnect {
    if (!socketIO.isConnecting && !socketIO.isConnected)
        [socketIO connectToHost:BTSOCKET onPort:0];
}

- (void)socketConnectToServer {
    if (socketIO.isConnected) {
        NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *url = [NSString stringWithFormat:@"/api/sockets/connect?email=%@&password=%@&locale=%@",
                         [BTUserDefault getEmail],
                         [BTUserDefault getPassword],
                         locale];
        NSDictionary *params = @{@"url" : url};
        [socketIO sendEvent:@"put" withData:params];
    } else
        [self socketConnect];
}

#pragma Socket.io Delegate
- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connected to %@", socket.host);
    [self socketConnectToServer];
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Disconnected : %@", socket.host);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, reconnectTry * 5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self socketConnect];
    });
    
    reconnectTry ++;
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error {
    
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    id data = [packet dataAsJSON];
    NSLog(@"didReceiveEvent : %@", data);
    NSLog(@"name : %@", [[packet dataAsJSON] objectForKey:@"name"]);
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"clicker"]) {
        Clicker *clicker = [[Clicker alloc] initWithObject:[data objectForKey:@"args"][0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:ClickerUpdated object:clicker];
        [BTDatabase updateClicker:clicker];
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"attendance"]) {
        Attendance *attendance = [[Attendance alloc] initWithObject:[data objectForKey:@"args"][0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:AttendanceUpdated object:attendance];
        [BTDatabase updateAttendance:attendance];
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"notice"]) {
        Notice *notice = [[Notice alloc] initWithObject:[data objectForKey:@"args"][0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NoticeUpdated object:notice];
        [BTDatabase updateNotice:notice];
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"curious"]) {
        Curious *curious = [[Curious alloc] initWithObject:[data objectForKey:@"args"][0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:CuriousUpdated object:curious];
        [BTDatabase updateCurious:curious];
    }
    
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqual:@"post"]) {
        Post *post = [[Post alloc] initWithObject:[data objectForKey:@"args"][0]];
        [[NSNotificationCenter defaultCenter] postNotificationName:PostUpdated object:post];
        [BTDatabase updatePost:post withData:nil];
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    NSLog(@"didReceiveJSON : %@", [packet dataAsJSON]);
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"didReceiveMessage : %@", [packet dataAsJSON]);
}

@end
