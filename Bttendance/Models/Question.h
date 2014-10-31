//
//  Question.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 31..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class SimpleUser;

@interface SimpleQuestion : RLMObject

@property NSInteger         id;
@property NSString          *message;
@property NSInteger         choice_count;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end


@interface Question : RLMObject

@property NSInteger         id;
@property NSDate            *createdAt;
@property NSDate            *updatedAt;
@property NSString          *message;
@property NSInteger         choice_count;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;
@property SimpleUser        *owner;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
