//
//  UIImage+Bttendance.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 9. 16..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "UIImage+Bttendance.h"

@implementation UIImage (Bttendance)

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

@end
