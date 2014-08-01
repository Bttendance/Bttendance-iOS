//
//  QuestionListViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *createBt;

- (IBAction)create:(id)sender;

@end
