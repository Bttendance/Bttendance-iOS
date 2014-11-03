//
//  ClickerRecord.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface ClickerRecord : BTSimpleObject

@property NSString          *email;
@property NSString          *full_name;

//Added by APIs
@property NSString          *grade;
@property NSString          *student_id;
@property NSInteger         course_id;

@end
RLM_ARRAY_TYPE(ClickerRecord)
