//
//  SchoolView.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 23..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolInfoCell.h"

@interface SchoolChooseView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    
    NSUInteger sectionCount;
    NSUInteger rowcount0;
    NSUInteger rowcount1;
    
    NSMutableArray *data0;
    NSMutableArray *data1;

    NSDictionary *userinfo;

    SchoolInfoCell *currentcell;

    Boolean auth;
}
@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic) Boolean auth;

@end