//
//  ChooseCountCell.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ChooseCountCell.h"
#import "UIColor+Bttendance.h"

@implementation ChooseCountCell

+ (ChooseCountCell *)cellFromNibNamed {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ChooseCountCell" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ChooseCountCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ChooseCountCell class]]) {
            cell = (ChooseCountCell *) nibItem;
            break;
        }
    }
    return cell;
}

- (void)setExpansionStyle:(UIExpansionStyle)style animated:(BOOL)animated
{
    switch (self.expansionStyle) {
        case UIExpansionStyleExpanded:
            break;
        case UIExpansionStyleCollapsed:
            break;
    }
}

-(IBAction)chooseType2:(id)sender
{
    if (!self.editable)
        return;
    
    self.choice = 2;
    [self updateChoice];
    [self.delegate chosen:2];
}

-(IBAction)chooseType3:(id)sender
{
    if (!self.editable)
        return;
    
    self.choice = 3;
    [self updateChoice];
    [self.delegate chosen:3];
}

-(IBAction)chooseType4:(id)sender
{
    if (!self.editable)
        return;
    
    self.choice = 4;
    [self updateChoice];
    [self.delegate chosen:4];
}

-(IBAction)chooseType5:(id)sender
{
    if (!self.editable)
        return;
    
    self.choice = 5;
    [self updateChoice];
    [self.delegate chosen:5];
}

-(void)updateChoice {
    self.bg2.backgroundColor = [UIColor silver:1.0];
    self.bg3.backgroundColor = [UIColor silver:1.0];
    self.bg4.backgroundColor = [UIColor silver:1.0];
    self.bg5.backgroundColor = [UIColor silver:1.0];
    
    self.typeLable2.backgroundColor = [UIColor white:1.0];
    self.typeLable3.backgroundColor = [UIColor white:1.0];
    self.typeLable4.backgroundColor = [UIColor white:1.0];
    self.typeLable5.backgroundColor = [UIColor white:1.0];
    
    self.typeLable2.textColor = [UIColor silver:1.0];
    self.typeLable3.textColor = [UIColor silver:1.0];
    self.typeLable4.textColor = [UIColor silver:1.0];
    self.typeLable5.textColor = [UIColor silver:1.0];
    
    switch (self.choice) {
        case 2:
            self.bg2.backgroundColor = [UIColor cyan:1.0];
            self.typeLable2.backgroundColor = [UIColor navy:1.0];
            self.typeLable2.textColor = [UIColor cyan:1.0];
            break;
        case 3:
            self.bg3.backgroundColor = [UIColor cyan:1.0];
            self.typeLable3.backgroundColor = [UIColor navy:1.0];
            self.typeLable3.textColor = [UIColor cyan:1.0];
            break;
        case 4:
            self.bg4.backgroundColor = [UIColor cyan:1.0];
            self.typeLable4.backgroundColor = [UIColor navy:1.0];
            self.typeLable4.textColor = [UIColor cyan:1.0];
            break;
        case 5:
            self.bg5.backgroundColor = [UIColor cyan:1.0];
            self.typeLable5.backgroundColor = [UIColor navy:1.0];
            self.typeLable5.textColor = [UIColor cyan:1.0];
            break;
        default:
            break;
    }
}

@end
