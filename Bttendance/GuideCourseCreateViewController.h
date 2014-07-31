//
//  GuideCourseCreateViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ViewController.h"

@interface GuideCourseCreateViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;
@property (strong, nonatomic) NSString *courseCode;

- (IBAction)next:(id)sender;

@end
