//
//  StdProfileView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSUInteger rowcount;

    User *user;

    NSMutableArray *data;
    NSMutableArray *alluserschools;
    NSArray *employedschoollist;
    NSArray *enrolledschoollist;

    __strong NSString *fullname;
    __strong NSString *email;

    Boolean first;
}

@property(weak, nonatomic) IBOutlet UINavigationBar *navigationbar;
@property(weak, nonatomic) IBOutlet UITableView *tableview;

@property(strong, nonatomic) NSString *fullname;
@property(strong, nonatomic) NSString *email;

@end
