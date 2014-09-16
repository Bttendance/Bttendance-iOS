//
//  ChooseTypeCell.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ChooseTypeCell.h"
#import "UIColor+Bttendance.h"

@implementation ChooseTypeCell

+ (ChooseTypeCell *)cellFromNibNamed {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ChooseTypeCell" owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    ChooseTypeCell *cell = nil;
    NSObject *nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[ChooseTypeCell class]]) {
            cell = (ChooseTypeCell *) nibItem;
            break;
        }
    }
    return cell;
}

-(IBAction)chooseType1:(id)sender
{
    [self.typeImage1 setImage:[UIImage imageNamed:@"small_attendance.png"]];
    [self.typeImage2 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage3 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage4 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    
    self.typeLable1.textColor = [UIColor navy:1.0];
    self.typeLable2.textColor = [UIColor silver:1.0];
    self.typeLable3.textColor = [UIColor silver:1.0];
    self.typeLable4.textColor = [UIColor silver:1.0];
    
    CGFloat width = MAX(50.0f, self.typeLable1.frame.size.width);
    self.typeSelected.frame = CGRectMake(47 - width / 2, 7, width, 70);
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.type = @"university";
}

-(IBAction)chooseType2:(id)sender
{
    [self.typeImage1 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage2 setImage:[UIImage imageNamed:@"small_attendance.png"]];
    [self.typeImage3 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage4 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    
    self.typeLable1.textColor = [UIColor silver:1.0];
    self.typeLable2.textColor = [UIColor navy:1.0];
    self.typeLable3.textColor = [UIColor silver:1.0];
    self.typeLable4.textColor = [UIColor silver:1.0];
    
    CGFloat width = MAX(50.0f, self.typeLable2.frame.size.width);
    self.typeSelected.frame = CGRectMake(122 - width / 2, 7, width, 70);
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.type = @"school";
}

-(IBAction)chooseType3:(id)sender
{
    [self.typeImage1 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage2 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage3 setImage:[UIImage imageNamed:@"small_attendance.png"]];
    [self.typeImage4 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    
    self.typeLable1.textColor = [UIColor silver:1.0];
    self.typeLable2.textColor = [UIColor silver:1.0];
    self.typeLable3.textColor = [UIColor navy:1.0];
    self.typeLable4.textColor = [UIColor silver:1.0];
    
    CGFloat width = MAX(50.0f, self.typeLable3.frame.size.width);
    self.typeSelected.frame = CGRectMake(197 - width / 2, 7, width, 70);
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.type = @"institute";
}

-(IBAction)chooseType4:(id)sender
{
    [self.typeImage1 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage2 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage3 setImage:[UIImage imageNamed:@"small_attendance_silver.png"]];
    [self.typeImage4 setImage:[UIImage imageNamed:@"small_attendance.png"]];
    
    self.typeLable1.textColor = [UIColor silver:1.0];
    self.typeLable2.textColor = [UIColor silver:1.0];
    self.typeLable3.textColor = [UIColor silver:1.0];
    self.typeLable4.textColor = [UIColor navy:1.0];
    
    CGFloat width = MAX(50.0f, self.typeLable4.frame.size.width);
    self.typeSelected.frame = CGRectMake(272 - width / 2, 7, width, 70);
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.type = @"etc";
}

@end
