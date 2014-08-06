//
//  ClickerTextViewCell.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerTextViewCell.h"

@implementation ClickerTextViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSTextContainer *container = self.inputField.textContainer;
    container.widthTracksTextView = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = textView.contentSize;
    size.height+= 8.0f;
    [self.delegate growingCell:self didChangeSize:size];
}


@end
