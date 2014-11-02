//
//  SimpleUser.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SimpleUser.h"

@implementation SimpleUser

+ (NSDictionary *)defaultPropertyValues {
    NSString *json = @"{\"grade\": \"\", \"student_id\": \"\"}";
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return jsonDict;
}

@end
