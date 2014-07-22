//
//  BTColor.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 7..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "BTColor.h"

@implementation BTColor

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithNavyColor:(CGFloat)_alpha {
    return [self imageWithColor:[self BT_navy:_alpha]];
}

+ (UIImage *)imageWithCyanColor:(CGFloat)_alpha {
    return [self imageWithColor:[self BT_cyan:_alpha]];
}

+ (UIImage *)imageWithBlackColor:(CGFloat)_alpha {
    return [self imageWithColor:[self BT_black:_alpha]];
}

+ (UIColor *)BT_navy:(CGFloat)_alpha {
    return [UIColor colorWithRed:0 green:0.447 blue:0.69 alpha:_alpha];
}

+ (UIColor *)BT_cyan:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.20 green:0.71 blue:0.898 alpha:_alpha];
}

+ (UIColor *)BT_grey:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.914 green:0.914 blue:0.969 alpha:_alpha];
}

+ (UIColor *)BT_black:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.098 green:0.098 blue:0.153 alpha:_alpha];
}

+ (UIColor *)BT_silver:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.427 green:0.427 blue:0.482 alpha:_alpha];
}

+ (UIColor *)BT_white:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.945 green:0.945 blue:1.00 alpha:_alpha];
}

+ (UIColor *)BT_red:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.757 green:0.153 blue:0.176 alpha:_alpha];
}

+ (UIColor *)BT_clicker_a:(CGFloat)_alpha {
    return [UIColor colorWithRed:0 green:0.447 blue:0.69 alpha:_alpha];
}

+ (UIColor *)BT_clicker_b:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.125 green:0.576 blue:0.796 alpha:_alpha];
}

+ (UIColor *)BT_clicker_c:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.498 green:0.788 blue:0.937 alpha:_alpha];
}

+ (UIColor *)BT_clicker_d:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.776 green:0.886 blue:0.976 alpha:_alpha];
}

+ (UIColor *)BT_clicker_e:(CGFloat)_alpha {
    return [UIColor colorWithRed:0.914 green:0.914 blue:0.969 alpha:_alpha];
}

@end

//BT_navy 0, 0.447, 0.69
//BT_cyan 0.20, 0.71, 0.898
//BT_grey 0.914, 0.914, 0.969
//BT_black 0.098, 0.098, 0.153
//BT_silver 0.427, 0.427, 0.482
//BT_white 0.945, 0.945, 1.00
//BT_red 0.757, 0.153, 0.176

//BT_clicker_a 0, 0.447, 0.69
//BT_clicker_b 0.125, 0.576, 0.796
//BT_clicker_c 0.498, 0.788, 0.937
//BT_clicker_d 0.776, 0.886, 0.976
//BT_clicker_e 0.914, 0.914, 0.969