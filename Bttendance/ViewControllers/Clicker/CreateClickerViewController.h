//
//  CreateClickerViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickerQuestionViewController.h"

@interface CreateClickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ClickerQuestionViewControllerDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(retain, nonatomic) NSString *cid;

@end
