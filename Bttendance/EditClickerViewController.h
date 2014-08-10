//
//  EditClickerViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface EditClickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (strong) Post *post;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
