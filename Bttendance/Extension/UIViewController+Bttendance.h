//
//  UIViewController+Bttendance.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTAPIs.h"
#import "BTDatabase.h"
#import "BTUserDefault.h"
#import "BTNotification.h"

typedef NS_ENUM(NSInteger, LeftMenuType) {
    LeftMenuType_Side,
    LeftMenuType_Back,
    LeftMenuType_Close,
    LeftMenuType_None
};

typedef NS_ENUM(NSInteger, RightMenuType) {
    RightMenuType_Title,
    LeftMenuType_Setting
};

@interface UIViewController (Bttendance)

- (void)setNavTitle:(NSString *)title withSubTitle:(NSString *)subTitle;
- (void)setLeftMenu:(LeftMenuType)leftMenuType;
- (void)setRightMenu:(RightMenuType)rightMenuType withTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
