//
//  Question.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 31..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Question.h"
#import "User.h"
#import "BTDateFormatter.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleQuestion

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.message = [dictionary objectForKey:@"message"];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        self.progress_time = [[dictionary objectForKey:@"progress_time"] integerValue];
        self.show_info_on_select = [[dictionary objectForKey:@"show_info_on_select"] boolValue];
        self.detail_privacy = [dictionary objectForKey:@"detail_privacy"];
    }
    return self;
}

@end


@implementation Question

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.message = [dictionary objectForKey:@"message"];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        self.progress_time = [[dictionary objectForKey:@"progress_time"] integerValue];
        self.show_info_on_select = [[dictionary objectForKey:@"show_info_on_select"] boolValue];
        self.detail_privacy = [dictionary objectForKey:@"detail_privacy"];
        self.owner = [[SimpleUser alloc] initWithDictionary:[dictionary objectForKey:@"owner"]];
    }
    return self;
}


@end
