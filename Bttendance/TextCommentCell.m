//
//  TextCommentCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "TextCommentCell.h"
#import "BTColor.h"

@implementation TextCommentCell
@synthesize comment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        comment = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 310, 20)];
        comment.textColor = [BTColor BT_silver:1];
        comment.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        
        self.backgroundColor = [BTColor BT_grey:1];
        [self addSubview:comment];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
