//
//  MBProgressHUD+Bttendance.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 5..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Bttendance)

+ (void)showWithMessage:(NSString *)message toView:(UIView *)view;
+ (void)hideForView:(UIView *)view;

@end
