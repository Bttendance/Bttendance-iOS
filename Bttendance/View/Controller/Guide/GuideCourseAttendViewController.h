//
//  GuideCourseAttendViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideCourseAttendViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;

- (IBAction)next:(id)sender;

@end
