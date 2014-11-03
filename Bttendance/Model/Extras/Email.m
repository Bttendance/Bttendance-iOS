//
//  Email.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Email.h"

@implementation Email

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *jsonDict = @{@"email" : @""};
    return jsonDict;
}

@end
