//
//  SocketAgent.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 5. 6..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <socket.IO/SocketIO.h>

@interface SocketAgent : NSObject <SocketIODelegate> {
    SocketIO *socketIO;
    NSString *socketID;
    NSInteger reconnectTry;
}

+ (SocketAgent *)sharedInstance;

- (void)socketConnect;

@end
