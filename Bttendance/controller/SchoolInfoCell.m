//
//  CourseInfoCell.m
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "SchoolInfoCell.h"

@interface SchoolInfoCell ()

@end

@implementation SchoolInfoCell

+(SchoolInfoCell *)cellFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    SchoolInfoCell *cell = nil;
    NSObject* nibItem = nil;
    while((nibItem = [nibEnumerator nextObject]) != nil){
        if([nibItem isKindOfClass:[SchoolInfoCell class]]){
            cell = (SchoolInfoCell *)nibItem;
            break;
        }
    }
    return cell;
}

@end
