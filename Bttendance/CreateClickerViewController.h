//
//  CreateClickerViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateClickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UIButton *loadBt;

@property(retain, nonatomic) NSString *cid;

- (void)start_clicker;
-(IBAction)loadQuestion:(id)sender;

@end
