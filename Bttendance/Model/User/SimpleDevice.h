//
//  SimpleDevice.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface SimpleDevice : BTSimpleObject

@property NSString          *type;
@property NSString          *uuid;
@property NSString          *notification_key;

@end
