//
//  ButtonCell.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 3..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "ButtonCell.h"

@interface ButtonCell ()

@end

@implementation ButtonCell

+(ButtonCell *)cellFromNibNamed:(NSString *)nibName{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ButtonCell *cell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ButtonCell class]]) {
            cell = (ButtonCell *)nibItem;
            break;
        }
    }
    return cell;
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        _button.alpha = 0.3f;
    }
}



@end