//
//  MBProgressHUD+Bttendance.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 5..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "MBProgressHUD+Bttendance.h"
#import "UIColor+Bttendance.h"

@implementation MBProgressHUD (Bttendance)

#pragma Hud Methods
+ (void)showWithMessage:(NSString *)message toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = message;
    hud.yOffset = -40.0f;
}

+ (void)hideForView:(UIView *)view {
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

@end
