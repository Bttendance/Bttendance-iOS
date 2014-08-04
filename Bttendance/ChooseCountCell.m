//
//  ChooseCountCell.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ChooseCountCell.h"
#import "BTColor.h"

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

-(IBAction)chooseType2:(id)sender
{
    self.bg2.backgroundColor = [BTColor BT_cyan:1.0];
    self.bg3.backgroundColor = [BTColor BT_silver:1.0];
    self.bg4.backgroundColor = [BTColor BT_silver:1.0];
    self.bg5.backgroundColor = [BTColor BT_silver:1.0];
    
    self.typeLable2.backgroundColor = [BTColor BT_navy:1.0];
    self.typeLable3.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable4.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable5.backgroundColor = [BTColor BT_white:1.0];
    
    self.typeLable2.textColor = [BTColor BT_cyan:1.0];
    self.typeLable3.textColor = [BTColor BT_silver:1.0];
    self.typeLable4.textColor = [BTColor BT_silver:1.0];
    self.typeLable5.textColor = [BTColor BT_silver:1.0];
    
    self.typeMessage2.textColor = [BTColor BT_navy:1.0];
    self.typeMessage3.textColor = [BTColor BT_silver:1.0];
    self.typeMessage4.textColor = [BTColor BT_silver:1.0];
    self.typeMessage5.textColor = [BTColor BT_silver:1.0];
    
    self.choice = 2;
}

-(IBAction)chooseType3:(id)sender
{
    self.bg2.backgroundColor = [BTColor BT_silver:1.0];
    self.bg3.backgroundColor = [BTColor BT_cyan:1.0];
    self.bg4.backgroundColor = [BTColor BT_silver:1.0];
    self.bg5.backgroundColor = [BTColor BT_silver:1.0];
    
    self.typeLable2.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable3.backgroundColor = [BTColor BT_navy:1.0];
    self.typeLable4.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable5.backgroundColor = [BTColor BT_white:1.0];
    
    self.typeLable2.textColor = [BTColor BT_silver:1.0];
    self.typeLable3.textColor = [BTColor BT_cyan:1.0];
    self.typeLable4.textColor = [BTColor BT_silver:1.0];
    self.typeLable5.textColor = [BTColor BT_silver:1.0];
    
    self.typeMessage2.textColor = [BTColor BT_silver:1.0];
    self.typeMessage3.textColor = [BTColor BT_navy:1.0];
    self.typeMessage4.textColor = [BTColor BT_silver:1.0];
    self.typeMessage5.textColor = [BTColor BT_silver:1.0];
    
    self.choice = 3;
}

-(IBAction)chooseType4:(id)sender
{
    self.bg2.backgroundColor = [BTColor BT_silver:1.0];
    self.bg3.backgroundColor = [BTColor BT_silver:1.0];
    self.bg4.backgroundColor = [BTColor BT_cyan:1.0];
    self.bg5.backgroundColor = [BTColor BT_silver:1.0];
    
    self.typeLable2.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable3.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable4.backgroundColor = [BTColor BT_navy:1.0];
    self.typeLable5.backgroundColor = [BTColor BT_white:1.0];
    
    self.typeLable2.textColor = [BTColor BT_silver:1.0];
    self.typeLable3.textColor = [BTColor BT_silver:1.0];
    self.typeLable4.textColor = [BTColor BT_cyan:1.0];
    self.typeLable5.textColor = [BTColor BT_silver:1.0];
    
    self.typeMessage2.textColor = [BTColor BT_silver:1.0];
    self.typeMessage3.textColor = [BTColor BT_silver:1.0];
    self.typeMessage4.textColor = [BTColor BT_navy:1.0];
    self.typeMessage5.textColor = [BTColor BT_silver:1.0];
    
    self.choice = 4;
}

-(IBAction)chooseType5:(id)sender
{
    self.bg2.backgroundColor = [BTColor BT_silver:1.0];
    self.bg3.backgroundColor = [BTColor BT_silver:1.0];
    self.bg4.backgroundColor = [BTColor BT_silver:1.0];
    self.bg5.backgroundColor = [BTColor BT_cyan:1.0];
    
    self.typeLable2.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable3.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable4.backgroundColor = [BTColor BT_white:1.0];
    self.typeLable5.backgroundColor = [BTColor BT_navy:1.0];
    
    self.typeLable2.textColor = [BTColor BT_silver:1.0];
    self.typeLable3.textColor = [BTColor BT_silver:1.0];
    self.typeLable4.textColor = [BTColor BT_silver:1.0];
    self.typeLable5.textColor = [BTColor BT_cyan:1.0];
    
    self.typeMessage2.textColor = [BTColor BT_silver:1.0];
    self.typeMessage3.textColor = [BTColor BT_silver:1.0];
    self.typeMessage4.textColor = [BTColor BT_silver:1.0];
    self.typeMessage5.textColor = [BTColor BT_navy:1.0];
    
    self.choice = 5;
}

@end
