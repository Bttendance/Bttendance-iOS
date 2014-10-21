//
//  StudentListViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface StudentListViewController : UITableViewController {
    NSArray *data;
}

@property(strong, nonatomic) Course *course;

@end
