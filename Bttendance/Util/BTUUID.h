//
//  BTUUID.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BTUUID : NSObject

+ (CBMutableService *)getUserService;

+ (NSString *)representativeString:(CBUUID *)_CBUUID;

@end
