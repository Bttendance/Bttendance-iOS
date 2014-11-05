//
//  UIViewController+Bttendance.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "UIViewController+Bttendance.h"
#import "RESideMenu.h"

@implementation UIViewController (Bttendance)

#pragma Navigation Title
- (void)setNavTitle:(NSString *)title withSubTitle:(NSString *)subTitle {
    if (title == nil)
        return;
    else if (subTitle == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor white:1.0];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        
        self.navigationItem.titleView = titleLabel;
    } else {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor white:1.0];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.textColor = [UIColor white:1.0];
        subTitleLabel.text = subTitle;
        [subTitleLabel sizeToFit];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
        [titleView addSubview:titleLabel];
        [titleView addSubview:subTitleLabel];
        
        self.navigationItem.titleView = titleView;
    }
}

#pragma Left Menu
- (void)setLeftMenu:(LeftMenuType)leftMenuType {
    
    switch (leftMenuType) {
            
        case LeftMenuType_Side: {
            UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
            UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
            [self.navigationItem setLeftBarButtonItem:leftButtonItem];
            break;
        }
            
        case LeftMenuType_Back: {
            UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
            UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
            [self.navigationItem setLeftBarButtonItem:leftButtonItem];
            break;
        }
            
        case LeftMenuType_Close: {
            UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(close:)];
            [self.navigationItem setLeftBarButtonItem:leftButtonItem];
            break;
        }
            
        case LeftMenuType_None:
        default:
            break;
    }
    
}

#pragma Right Menu
- (void)setRightMenu:(RightMenuType)rightMenuType withTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:title
                                                              style:UIBarButtonItemStyleDone
                                                             target:target
                                                             action:action];
    self.navigationItem.rightBarButtonItem = start;
}

#pragma Private Methods
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
