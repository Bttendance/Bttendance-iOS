//
//  SimpleClickerQuestion.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface SimpleClickerQuestion : BTSimpleObject

@property NSInteger         author;
@property NSString          *message;
@property NSInteger         choice_count;
@property NSInteger         progress_time;
@property BOOL              show_info_on_select;
@property NSString          *detail_privacy;

@end
