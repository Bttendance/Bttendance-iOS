//
//  CourseInfoCell.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "UserInfoCell.h"

@interface UserInfoCell ()

@end

@implementation UserInfoCell

+(UserInfoCell *)cellFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    UserInfoCell *cell = nil;
    NSObject* nibItem = nil;
    while((nibItem = [nibEnumerator nextObject]) != nil){
        if([nibItem isKindOfClass:[UserInfoCell class]]){
            cell = (UserInfoCell *)nibItem;
            break;
        }
    }
    return cell;
}

@end
