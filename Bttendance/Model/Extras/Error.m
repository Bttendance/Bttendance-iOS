//
//  Error.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Error.h"

@implementation Error

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSDictionary *jsonDict = @{@"type" : @"",
                               @"title" : @"",
                               @"message" : @""};
    return jsonDict;
}

#pragma Public Methods
- (ErrorType)getErrorType {
    if ([self.type isEqualToString:@"alert"])
        return ErrorType_Log;
    else if ([self.type isEqualToString:@"toast"])
        return ErrorType_Log;
    else
        return ErrorType_Log;
}

@end
